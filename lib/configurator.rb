# frozen_string_literal: true

require "optparse"

class Configurator

  def self.call(args:, is_tty:, script_name:)
    output = { report: :total,
               source: nil,
               action: :parse, }

    options_parser = OptionParser.new do |opts|

      opts.banner = "Usage: #{script_name} [options] [FILE]"

      opts.on("--report TYPE", "-r TYPE", String, %i[total unique], "Choose report type (total, unique)") do |type|
        output[:report] = type
      end

      opts.on("-h", "--help", "To get help") do
        output[:action] = :help
      end

      output[:help] = opts.to_s

    end

    options_parser.parse!(args)

    if args.size == 1
      output[:source] = File.foreach(args[0])
    elsif !is_tty
      output[:source] = $stdin
    else
      output[:action] = :help
    end

    output
  end

end
