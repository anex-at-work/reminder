# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate

  private

  def authenticate
    authenticate_user! unless devise_controller?
  end
end
