require "spec"
require "m3u-copy"

describe "Validating command-line parameters" do
  it "Exits with status code 1 if there are no arguments given" do
    Playlist.new(nil)
  end
  
end
