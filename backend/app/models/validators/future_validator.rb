# frozen_string_literal: true

module Validators
  # FutureValidator
  class FutureValidator < ActiveModel::Validator
    def validate(record)
      options[:fields].any?  do |field|
        record.errors[field] << 'Not in the future' if record.send(field).respond_to?(:future?) && !record.send(field).future?
      end
    end
  end
end
