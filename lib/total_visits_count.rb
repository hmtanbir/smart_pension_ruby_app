# frozen_string_literal: true

class TotalVisitsCount

  def initialize
    @data = Hash.new(0)
  end

  def add(record)
    @report = nil
    @data[record["path"]] += 1
  end

  def report
    @report ||= @data
      .sort_by(&:last)
      .reverse
      .map { |key, value| { path: key, count: value } }
  end

end
