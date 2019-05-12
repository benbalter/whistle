require 'bundler/setup'
require 'whistle'
require 'timecop'

require 'webmock/rspec'
WebMock.disable_net_connect!

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end

def fixture_dir
  File.expand_path './fixtures', __dir__
end

def fixture_path(fixture)
  File.join fixture_dir, fixture
end

def fixture_contents(fixture)
  File.read fixture_path(fixture)
end
