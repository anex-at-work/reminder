# frozen_string_literal: true

# Reminder
class Reminder < ApplicationRecord
  audited

  belongs_to :user

  enum status: {
    active: 0,
    sended: 1,
    deleted: 2
  }

  enum repeat_type: {
    never: 0,
    weekly: 1,
    monthly: 2
  }

  validates :title, presence: true
  validates :date_at, presence: true, if: [proc { |r| !r.user_date.present? }]
  validates :user_date, presence: true, if: [proc { |r| !r.date_at.present? || r.date_at.past? }]
  validates_with Validators::FutureValidator, fields: [:date_at], if: [proc { |r| !r.user_date.present? }]
  validates_with Validators::DaysOfMonthValidator, fields: [:user_date], if: [proc { |r| r.user_date.present? }]

  scope :published, -> { where.not(status: :deleted) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_period, ->(year:, month:) {
                      repeated.or(every).or(where(date_at: nil))
                              .or(where(date_at: [Date.new(year, month).beginning_of_month...Date.new(year, month).end_of_month]))
                    }
  scope :repeated, -> { where.not(repeat_type: :never) }
  scope :every, -> { where.not(calculated_date: nil, user_date: nil) }

  before_save :set_calculated_date, if: [proc { |r| r.user_date.present? }]

  class Entity < Grape::Entity
    expose :id, :title, :description, :date_at, :user_date, :repeat_type
    expose :time_at do |object| object.time_at.strftime('%H:%M') end
    expose :calculated_date

    private

    def calculated_date
      at_date = Date.new(options[:year] || Date.current.year, options[:month] || Date.current.month)
      if object.user_date.present?
        return ::DaysOfMonth.decode(string: object.user_date, month: at_date.month, year: at_date.year).values[0] if object.calculated_date.values[0].is_a? Array

        return [Date.new(object.date_at.year, object.date_at.month, object.calculated_date.values[0].to_i)]
      elsif object.repeat_type != 'never'
        return object.repeat_weekly(at_date) if object.repeat_type == 'weekly'
      end
      [object.time_at.change(year: object.date_at.year, month: object.date_at.month, day: object.date_at.day)]
    end
  end

  def repeat_weekly(date)
    range = (date.beginning_of_month..date.end_of_month)
    range.to_a.select { |date| date.wday == date_at.wday }
  end

  private

  def set_calculated_date
    self.calculated_date = get_parsed
    self.date_at = Date.current unless date_at.present?
  end

  def get_parsed
    month = date_at.try(:month) || Date.today.month
    year = date_at.try(:year) || Date.today.year
    parsed = ::DaysOfMonth.decode(string: user_date, month: month, year: year)
    if parsed.is_a? Integer
      real_day = parsed < 0 ? Time.days_in_month(month) + parsed + 1 : parsed
      parsed = { Date.today.month => real_day }
    end
    parsed
  end
end
