module SensuPluginsZFS
  class ZPool
    def state
      %x[sudo zpool status | grep '^ state: ' | cut -d ' ' -f 3].strip
    end
  end
end
