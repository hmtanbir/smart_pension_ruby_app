#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../config/autoload"

opts = Configurator.call(args: ARGV, is_tty: $stdin.tty?, script_name: File.basename(__FILE__))

at_exit do
  $stdout.puts opts[:help] unless $!&.success?
end

exit(false) if opts[:action] == :help

case opts[:report]
when :unique
  output_format = ->(_record, widths) { "%-#{widths[:path] + 1}{path}%{count} unique visitors" }
  reporter = UniqueVisitsCount.new
when :total
  output_format = ->(_record, widths) { "%-#{widths[:path] + 1}{path}%{count} visits" }
  reporter = TotalVisitsCount.new
end

begin
  report_builder = GenerateReport.new(reporter: reporter,
                                      renderer: PrintOutput.new(formatter: output_format),
                                      on_parse_error: ->(line) { $stderr.puts "Can't parse:\n #{line}" })
  report_builder.call(opts[:source]).each do |line|
    $stdout.puts line
  end
  exit(true)
rescue SystemCallError => e
  $stderr.puts "Error: #{e.message[/(.*) @/, 1]}"
  exit(false)
end
