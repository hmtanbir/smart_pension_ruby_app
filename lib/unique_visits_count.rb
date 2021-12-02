# frozen_string_literal: true

require "set"

class UniqueVisitsCount

  def initialize
    @data = {}
  end

  def add(record)
    @report = nil
    path, ip = record.values_at("path", "ip")
    @data[path]&.add(ip) || (@data[path] = Set.new([ip]))
    @data[path].size
  end

  def report
    @report ||= @data
      .map { |key, value| [key, value.size] }
      .sort_by(&:last)
      .reverse
      .map { |key, value| { path: key, count: value } }
  end

end
