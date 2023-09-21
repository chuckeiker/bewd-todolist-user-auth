class SessionsController < ApplicationController
  # Create action for logging in
  def create
    @user = User.find_by(username: params[:user][:username])

    if @user&.authenticate(params[:user][:password])
      session = @user.sessions.create
      cookies.permanent.signed[:todolist_session_token] = {
        value: session.token,
        httponly: true
      }
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  # Authenticated action for checking if a user is logged in
  def authenticated
    token = cookies.signed[:todolist_session_token]
    session = Session.find_by(token: token)

    if session
      user = session.user
      render json: { authenticated: true, username: user.username }
    else
      render json: { authenticated: false }
    end
  end

  # Destroy action for logging out
  def destroy
    token = cookies.signed[:todolist_session_token]
    session = Session.find_by(token: token)

    if session&.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end
end
