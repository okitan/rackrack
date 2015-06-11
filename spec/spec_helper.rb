require "rackrack"

# debug
require "tapp"
require "pry"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.run_all_when_everything_filtered = true

  config.warnings = true

  config.order = :random
  Kernel.srand config.seed
end
