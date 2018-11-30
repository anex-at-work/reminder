# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe '::validation' do
    context 'with valid attributes' do
      subject(:reminder) do
        FactoryBot.build :reminder
      end

      it 'passeses validation' do
        expect(reminder.valid?).to be true
      end
    end

    context 'with invalid attributes' do
      subject(:reminder) do
        Reminder.create
      end

      it 'checks user' do
        expect(reminder.errors).to include(:user)
      end

      it 'checks title' do
        expect(reminder.errors).to include(:title)
      end

      it 'checks user_date' do
        expect(reminder.errors).to include(:user_date)
      end

      it 'checks date_at' do
        expect(reminder.errors).to include(:date_at)
      end

      it 'check past date' do
        reminder.date_at = 2.days.ago
        reminder.valid?
        expect(reminder.errors).to include(:date_at)
      end

      it 'check priorities by dates' do
        reminder.user_date = '1st of month'
        reminder.valid?
        expect(reminder.errors).not_to include(:date_at)
      end

      it 'check priorities by dates2' do
        reminder.user_date = '45st of month'
        reminder.valid?
        expect(reminder.errors).not_to include(:date_at)
      end
    end
  end

  describe '.save' do
    let(:reminder) do
      FactoryBot.build :reminder
    end

    let(:reminder_every_friday) do
      FactoryBot.build :reminder, :every_friday
    end

    let(:reminder_monthly) do
      FactoryBot.build :reminder, :repeat_monthly
    end

    context 'with ordinal attributes' do
      it 'create new' do
        expect { reminder.save }.to change(Reminder, :count)
      end
    end

    context 'with repeated attributes' do
      it 'create new' do
        expect { reminder.save }.to change(Reminder, :count)
      end
    end

    context 'with repeated attributes' do
      it 'create new' do
        expect { reminder_monthly.save }.to change(Reminder, :count)
      end
    end

    context 'with every friday' do
      it 'create new' do
        expect { reminder_every_friday.save }.to change(Reminder, :count)
      end

      it 'check filled calculated_date' do
        reminder_every_friday.save
        expect(reminder_every_friday.calculated_date).not_to be nil
      end
    end
  end
end
