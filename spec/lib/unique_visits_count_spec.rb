# frozen_string_literal: true

require_relative "../../lib/unique_visits_count"

RSpec.describe UniqueVisitsCount do

  let(:instance) { described_class.new }

  describe "#add" do

    it "returns counter" do
      expect(instance.add({ "path" => "example.com", "ip" => "127.0.0.1" })).to eq(1)
      expect(instance.add({ "path" => "example.com", "ip" => "127.0.0.2" })).to eq(2)
    end

  end

  describe "#report" do

    it "returns array of hashes with unique counts" do
      5.times do
        instance.add({ "path" => "example.com", "ip" => "127.0.0.1" })
        instance.add({ "path" => "example.com", "ip" => "127.0.0.2" })
      end
      10.times do
        instance.add({ "path" => "example.net", "ip" => "127.0.0.1" })
        instance.add({ "path" => "example.net", "ip" => "127.0.0.2" })
        instance.add({ "path" => "example.net", "ip" => "127.0.0.3" })
      end
      20.times do
        instance.add({ "path" => "example.org", "ip" => "127.0.0.1" })
        instance.add({ "path" => "example.org", "ip" => "127.0.0.2" })
        instance.add({ "path" => "example.org", "ip" => "127.0.0.3" })
      end

      expect(instance.report).to eq([{ path: "example.org", count: 3 },
                                     { path: "example.net", count: 3 },
                                     { path: "example.com", count: 2 },])
    end

  end

end
