require "time"

module SensuPluginsZFS
  class ZFS
    def self.zpools
      %x[sudo zpool list -H -o name].lines('').map do |l|
        ZPool.new(l.strip)
      end
    end
  end

  class ZPool
    attr_reader :name, :state, :capacity, :vdevs

    def initialize(name)
      @name = name
      @state = %x[sudo zpool status #{name} | grep '^ state: ' | cut -d ' ' -f 3].strip
      @capacity = %x[sudo zpool get -H capacity #{@name} | awk '{print $3}' | cut -d '%' -f1].strip.to_i
      @vdevs = create_vdevs name
    end

    def ok?
      @state == "ONLINE"
    end

    def scrubbed_at
      if never_scrubbed?
        return Time.at(0)
      elsif scrub_in_progress?
        return Time.now
      end
      Time.parse %[zpool status tank | grep '^  scan: scrub' | awk '{print $11" "$12" "$13" "$14" "$15}'].strip
    end

    private

    def create_vdevs(name)
      cmd_out = %x[sudo zpool status #{name} | grep ONLINE | grep -v state | awk '{print $1 " " $2 " " $3 " " $4 " " $5}']
      cmd_out.lines('').map do |l|
        arr = l.strip.split(' ')
        VDev.new(self, arr[0], arr[1], arr[2].to_i, arr[3].to_i, arr[4].to_i)
      end
    end
    
    def never_scrubbed?
      %x[sudo zpool status #{@name} | egrep -c "none requested"].strip.to_i == 1
    end

    def scrub_in_progress?
      %x[sudo zpool status #{@name} | egrep -c "scrub in progress|resilver"].strip.to_i == 1
    end
  end

  class VDev
    attr_reader :zpool, :name, :read, :write, :chksum
    def initialize(zpool, name, state, read, write, chksum)
      @zpool = zpool
      @name = name
      @state = state
      @read = read
      @write = write
      @chksum = chksum
    end

    def ok?
      return !!(@state =~ /(ONLINE|AVAIL)/) &&
             @read == 0 &&
             @write == 0 &&
             @chksum == 0
    end
  end
end
