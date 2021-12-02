# frozen_string_literal: true

if ENV["RUBY_ENV"] == "test"
  require "pry"
  require "ori"
end

# Autoload stuff

$: << File.expand_path("../lib", __dir__)

autoload :Configurator,      "configurator.rb"
autoload :GenerateReport,    "generate_report.rb"
autoload :ParseLine,         "parse_line.rb"
autoload :PrintOutput,       "print_output"
autoload :TotalVisitsCount,  "total_visits_count.rb"
autoload :UniqueVisitsCount, "unique_visits_count.rb"
