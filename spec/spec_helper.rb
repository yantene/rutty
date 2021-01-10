RSpec.configure do |config|
  # rspec-expectation config
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true # RSpec4 default
  end

  # rspec-mocks config
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true # RSpec4 default
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups # RSpec4 default and fixed

  # for :focus tag
  config.filter_run_when_matching :focus

  # for --only-failures and --next-failure CLI option
  config.example_status_persistence_file_path = "spec/examples.txt"

  # disable monkey patching
  config.disable_monkey_patching!

  # enable warnings
  config.warnings = true

  # allow more verbose output when running an individual spec file
  if config.files_to_run.one?
    # use the documentation formatter
    config.default_formatter = "doc"
  end

  # print slow examples
  config.profile_examples = 10

  # run specs in random order
  config.order = :random

  # seed global randomization
  Kernel.srand config.seed

  # require all application code
  Dir.glob(File.join(__dir__, "../app/**/*.rb")).sort.each(&method(:require))
end
