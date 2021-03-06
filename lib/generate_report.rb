# frozen_string_literal: true

require "parse_line"

class GenerateReport

  attr_reader :line_parser, :on_parse_error, :renderer, :reporter

  def initialize(reporter:, line_parser: ParseLine, renderer: ->(o) { o }, on_parse_error: nil)
    @line_parser = line_parser
    @on_parse_error = on_parse_error
    @renderer = renderer
    @reporter = reporter
  end

  def call(source)
    source.each do |line|
      parsed_line = line_parser.call(line)
      if parsed_line
        reporter.add(parsed_line)
      else
        on_parse_error.call(line)
      end
    end
    renderer.load(reporter.report)
  end

end
