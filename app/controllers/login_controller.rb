class LoginController < ApplicationController
  include LoginService

  skip_before_action :authenticate, except: :logout

  def login
    email = params.require :email
    password = params.require :password
    render :json => dologin(email, password)
  end

  def logout
    token = token_and_options(request).first
    dologout(token)
    success_message
  end
end
