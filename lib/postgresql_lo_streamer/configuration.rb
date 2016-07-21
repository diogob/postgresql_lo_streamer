class PostgresqlLoStreamer::Configuration
  attr_accessor :options

  def initialize
    self.reset
  end

  def options
    @options
  end

  def reset
    self.options = {:type => 'image/png', :disposition => 'inline'}
  end
end
