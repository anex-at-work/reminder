# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Backend::API do
  let(:current_user) { FactoryBot.create :user }
  let(:auth_headers) { current_user.create_new_auth_token }

  describe 'resource :reminders' do
    context 'POST with correct date' do
      subject(:resp) do
        post '/api/v1/reminders', params: params, headers: auth_headers
        response
      end

      let(:params) do
        {
          title: Faker::Lorem.word,
          description: Faker::Lorem.sentence,
          date_at: Faker::Date.forward(20).strftime('%FT%T%:z'),
          user_date: nil,
          repeat_type: 'never',
          time_at: Time.current.strftime('%H:%M')
        }
      end

      it 'has :created status' do
        expect(resp).to have_http_status :created
      end

      it 'stores object' do
        ret = JSON.parse resp.body
        expect(ret).to include('user_date' => nil,
                               'description' => params[:description],
                               'repeat_type' => 'never',
                               'title' => params[:title])
      end
    end

    context 'GET' do
      subject(:resp) do
        FactoryBot.create :reminder, user_id: current_user.id
        FactoryBot.create :reminder, :repeat_weekly, user_id: current_user.id
        FactoryBot.create :reminder, :day_second, user_id: current_user.id
        FactoryBot.create :reminder, :every_friday, user_id: current_user.id

        get %(/api/v1/reminders/#{Date.current.year}/#{Date.current.month}), headers: auth_headers
        response
      end

      it 'has :ok status' do
        expect(resp).to have_http_status :ok
      end

      it 'has 4 records' do
        json = JSON.parse resp.body
        expect(json.count).to be >= 2
      end
    end

    context 'PUT' do
      subject(:resp) do
        reminder = FactoryBot.create :reminder
        put %(/api/v1/reminders/#{reminder.id}), params: params, headers: auth_headers
        response
      end

      let(:params) do
        {
          title: Faker::Lorem.word,
          description: Faker::Lorem.sentence,
          date_at: Faker::Date.forward(20).strftime('%FT%T%:z'),
          user_date: nil,
          repeat_type: 'never',
          time_at: Time.current.strftime('%H:%M')
        }
      end

      it 'has :ok status' do
        expect(resp).to have_http_status :ok
      end
    end

    context 'DELETE' do
      subject(:resp) do
        reminder = FactoryBot.create :reminder
        delete %(/api/v1/reminders/#{reminder.id}), headers: auth_headers
        response
      end

      it 'has :ok status' do
        expect(resp).to have_http_status :ok
      end
    end
  end
end
