# frozen_string_literal: true

require_relative "../../lib/configurator"

RSpec.describe Configurator do

  let(:report_args) do
    {
      "--report total webserver.log" => { report: :total, action: :parse },
      "--report unique webserver.log" => { report: :unique, action: :parse },
      "webserver.log --report total" => { report: :total, action: :parse },
      "webserver.log --report unique" => { report: :unique, action: :parse },
      "-r total webserver.log" => { report: :total, action: :parse },
      "-r unique webserver.log" => { report: :unique, action: :parse },
      "webserver.log -r total" => { report: :total, action: :parse },
      "webserver.log -r unique" => { report: :unique, action: :parse },
      "webserver.log" => { report: :total, action: :parse },
      "--report unique" => { report: :unique, action: :help },
      "--report total" => { report: :total, action: :help },
    }
  end

  describe "::call" do

    context "when is_tty true" do
      it "parses --report argument" do
        report_args.each do |args, expected|
          result = described_class.call(args: args.split, is_tty: true, script_name: "parser.rb")
          expect(result).to include(expected)
        end
      end

      it "parses --help argument" do
        result = described_class.call(args: ["--help"], is_tty: true, script_name: "parser.rb")
        expect(result).to include({ action: :help, source: nil })
      end
    end

    context "when is_tty false" do
      it "parses --help argument" do
        report_args.each do |args, expected|
          result = described_class.call(args: args.split, is_tty: false, script_name: "parser.rb")
          expect(result).not_to eq(expected)
          expect(result).to include({ action: :parse })
        end
      end
    end

  end

end
