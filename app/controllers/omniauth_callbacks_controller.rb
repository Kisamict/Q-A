class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def twitter
    authenticate(request.env['omniauth.auth'])
  end
  
  def authenticate(auth)
    @user = User.find_for_auth(auth)
  
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication 
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to omniauth_enter_email_path
    end
  end
  
  def enter_email
    flash[:notice] = 'Please enter your email'
  end

  def create_auth
    session["devise.twitter_data"]['info']['email'] = params[:email]
    authenticate(session["devise.twitter_data"])
  end
end
