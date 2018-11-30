# frozen_string_literal: true

require 'securerandom'
require 'mime/types'

module Backend
  # Main API
  class API < Grape::API
    helpers GrapeDeviseTokenAuth::AuthHelpers
    version 'v1', using: :path
    format :json
    prefix :api

    before do
      authenticate_user!
    end

    resource :reminders do
      desc 'Get events by month'
      get ':year/:month' do
        present Reminder.published.by_user(current_user.id).by_period(year: params[:year].to_i, month: params[:month].to_i),
                with: Reminder::Entity, year: params[:year].to_i, month: params[:month].to_i
      end

      desc 'Create a reminder'
      params do
        requires :title, type: String
        requires :repeat_type, type: String, values: Reminder.repeat_types.map(&:first)
        optional :user_date, type: String
        optional :date_at, type: String
      end
      post do
        present Reminder.create(params.merge(user_id: current_user.id)), with: Reminder::Entity
      end

      desc 'Update the reminder'
      params do
        requires :id, type: Integer
        requires :title, type: String
        requires :repeat_type, type: String, values: Reminder.repeat_types.map(&:first)
        optional :user_date, type: String
        optional :date_at, type: String
      end
      put ':id' do
        Reminder.find(params[:id]).update(params)
        present Reminder.find(params[:id]), with: Reminder::Entity
      end

      desc 'Shadow delete the reminder'
      delete ':id' do
        Reminder.find(params[:id]).deleted!
      end
    end
  end
end
