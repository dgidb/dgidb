require 'date'

version_file = File.join(Rails.root, 'VERSION')

class CurrentVersion
  attr_reader :version
  attr_reader :sha
  attr_reader :time

  def initialize(path)
    @version, time, @sha = File.read(path).strip.split("\t")
    @time = DateTime.parse(time).strftime("%F")
  end
end

CURRENT_VERSION = CurrentVersion.new(version_file)
