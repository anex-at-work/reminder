# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DaysOfMonth do
  describe '.decode' do
    context 'with ordinals forward' do
      it 'check "x1st of month"' do
        %w[1st 11th 21st].each_with_index do |st, i|
          expect(described_class.decode(string: %(#{st} of month))).to equal i * 10 + 1
        end
      end

      it 'check "2nd and 3rd of month"' do
        %w[2nd 3rd].each_with_index do |st, i|
          expect(described_class.decode(string: %(#{st} of month))).to equal i + 2
        end
      end

      it 'check "Nth of month"' do
        Array.new(5) { rand(3..28) }.each do |n|
          expect(described_class.decode(string: %(#{n}th of month))).to equal n
        end
      end
    end

    context 'with ordinals backward' do
      it 'check "x1st of month"' do
        %w[1st 11th 21st].each_with_index do |st, i|
          expect(described_class.decode(string: %(#{st} last of month))).to equal(-i * 10 - 1)
        end
      end

      it 'check "Nth of month"' do
        Array.new(5) { rand(3..28) }.each do |n|
          expect(described_class.decode(string: %(#{n}th last of month))).to equal(-n)
        end
      end
    end

    context 'with repeated' do
      it 'check "every Tuesday"' do
        month = 4
        date = Date.new(Date.current.year, month)
        days = (date.beginning_of_month..date.end_of_month).to_a.select { |date| date.wday == 2 }
        expect(described_class.decode(string: 'every Tuesday', month: month, year: Date.today.year)).to eq(month => days)
      end
    end

    context 'with incorrect values' do
      it 'check overdrawn positive values' do
        expect(described_class.decode(string: '32th of month')).to be false
      end

      it 'check overdrawn negative values' do
        expect(described_class.decode(string: '32th last of month')).to be false
      end

      it 'check non-correct string' do
        expect(described_class.decode(string: Faker::Lorem.sentence)).to be false
      end
    end
  end
end
