require "spec_helper"

RSpec.describe Sensu::Plugins::Zfs do
  it "has a version number" do
    expect(Sensu::Plugins::Zfs::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
