module SensuPluginsZFS
  class ZFS
    def self.zpools
      %x[sudo zpool list -H -o name].lines('').map do |l|
        ZPool.new(l.strip)
      end
    end
  end

  class ZPool
    attr_reader :state, :name, :vdevs

    def initialize(name)
      @name = name
      @state = %x[sudo zpool status #{name} | grep '^ state: ' | cut -d ' ' -f 3].strip
      @vdevs = create_vdevs name
    end

    def ok?
      return @state == "ONLINE"
    end

    private

    def create_vdevs(name)
      cmd_out = %x[sudo zpool status #{name} | grep ONLINE | grep -v state | awk '{print $1 " " $2 " " $3 " " $4 " " $5}']
      cmd_out.lines('').map do |l|
        arr = l.strip.split(' ')
        VDev.new(self, arr[0], arr[1], arr[2].to_i, arr[3].to_i, arr[4].to_i)
      end
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
