require 'simplecov'
SimpleCov.start

require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

require 'triggerable'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

load 'schema.rb'
require 'models'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = :should
  end
end

def constantize_time_now(time)
  Time.stub(:now).and_return(time)
end