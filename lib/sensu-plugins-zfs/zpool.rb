module SensuPluginsZFS
  class ZPool
    def state
      %x[zpool status | grep '^ state: ' | cut -d ' ' -f 3]
    end
  end
end
