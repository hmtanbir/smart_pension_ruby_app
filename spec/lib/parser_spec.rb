# frozen_string_literal: true

require "open3"

RSpec.describe "parser script" do

  let(:source) { "spec/fixtures/webserver.log" }
  let(:total_visits_report) { File.read("spec/fixtures/total_visits_report.yml") }
  let(:unique_visits_report) { File.read("spec/fixtures/unique_visitors_report.yml") }
  let(:script) { "lib/parser.rb " }

  def command(string, **args)
    Open3.capture3(string.strip, args)
  end

  it "shows help if no arguments provided" do
    expected = "Usage: parser.rb [options] [FILE]"
    out = `lib/parser.rb`
    expect(out).to include(expected)
    expect($CHILD_STATUS).not_to be_success
  end

  it "displays IO errors" do
    _out, err, result = command(script + "spec")
    expect(err).to match("Is a directory")
    expect(result).not_to be_success
  end

  describe "file input" do
    context "with long format" do
      it "outputs total visits report" do
        out, err, result = command(script + "--report total " + source)
        expect(out).to eq(total_visits_report)
        expect(result).to be_success, err
      end

      it "outputs unique visitors report" do
        out, err, result = command(script + "--report unique " + source)
        expect(out).to eq(unique_visits_report)
        expect(result).to be_success, err
      end
    end

    context "with short format" do
      it "outputs total visits report" do
        out, err, result = command(script + "-r total " + source)
        expect(out).to eq(total_visits_report)
        expect(result).to be_success, err
      end

      it "outputs unique visitors report" do
        out, err, result = command(script + "-r unique " + source)
        expect(out).to eq(unique_visits_report)
        expect(result).to be_success, err
      end
    end
  end

  describe "stdin input" do

    let(:payload) { File.read(source) }

    context "with long format" do
      it "outputs total visits report" do
        out, err, result = command(script + "--report total", stdin_data: payload)
        expect(out).to eq(total_visits_report)
        expect(result).to be_success, err
      end

      it "outputs unique visitors report" do
        out, err, result = command(script + "--report unique", stdin_data: payload)
        expect(out).to eq(unique_visits_report)
        expect(result).to be_success, err
      end
    end

    context "with short format" do
      it "outputs total visits report" do
        out, err, result = command(script + "-r total", stdin_data: payload)
        expect(out).to eq(total_visits_report)
        expect(result).to be_success, err
      end

      it "outputs unique visitors report" do
        out, err, result = command(script + "-r unique", stdin_data: payload)
        expect(out).to eq(unique_visits_report)
        expect(result).to be_success, err
      end
    end

  end

end
