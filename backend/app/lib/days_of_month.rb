# frozen_string_literal: true

# DaysOfMonth
class DaysOfMonth
  DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze

  attr_accessor :string
  attr_accessor :month
  attr_accessor :year

  class << self
    def decode(string:, month: nil, year: nil)
      return false if string.nil?

      kl = new
      kl.string = string
      kl.month = month || Date.today.month
      kl.year = year || Date.today.year
      kl.proceed
    end
  end

  def proceed
    return convert_to_days(as_ordinal) if ordinal?
    return convert_to_repeat(as_repeated) if repeated?

    false
  end

  private

  # very easy decoding
  def as_ordinal
    string.to_i * (backward? ? -1 : 1)
  end

  def as_repeated
    DAYS.map.with_index { |d, i| i if string.match? d }.compact[0]
  end

  def backward?
    string.match?(/last /) # potential bug
  end

  def ordinal?
    string.match?(/^\d/)
  end

  def repeated?
    string.match?(/^every /)
  end

  def convert_to_days(days)
    if days.is_a? Integer
      return days if days.abs <= Time.days_in_month(month || Date.current.month)
    end
    false
  end

  def convert_to_repeat(day)
    return false unless day

    calculated_month = month || Date.today.month
    date = Date.new(year, calculated_month)
    range = date.beginning_of_month..date.end_of_month
    { calculated_month => range.to_a.select { |date| date.wday == day } }
  end
end
