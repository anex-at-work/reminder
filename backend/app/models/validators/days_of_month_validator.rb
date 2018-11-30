# frozen_string_literal: true

module Validators
  # FutureValidator
  class DaysOfMonthValidator < ActiveModel::Validator
    def validate(record)
      options[:fields].any?  do |field|
        record.errors[field] << 'Can\'t parse date' unless ::DaysOfMonth.decode(string: record.send(field))
      end
    end
  end
end
