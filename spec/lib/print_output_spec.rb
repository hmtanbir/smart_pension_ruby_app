# frozen_string_literal: true

require_relative "../../lib/print_output"

RSpec.describe PrintOutput do

  let(:report) do
    [
      { path: "x" * 5, count: "0" * 12 },
      { path: "y" * 6, count: "0" * 13 },
    ]
  end
  let(:formatter) { ->(_record, widths) { "%-#{widths[:path] + 1}{path}%{count}" } }
  let(:instance) { described_class.new(formatter: formatter) }

  describe "#formatter" do

    it "returns formatter" do
      expect(instance.formatter).to eq(formatter)
    end

  end

  describe "#load" do

    it "loads report and returns self" do
      result = instance.load(report)
      expect(instance.report).to eq(report)
      expect(result).to eq(instance)
    end

  end

  describe "#each" do

    it "returns Enumerable" do
      expect(instance.each).to be_a(Enumerable)
    end

  end

end
