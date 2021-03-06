class ApplicationController < ActionController::Base
before_action :authenticate_user!, except: [:show]

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                                        { roles: [] },
                                                        :first_name,
                                                        :last_name,
                                                        :email,
                                                        :current_password,
                                                        :password,
                                                        :password_confirmation
                                                      ])
  end

    def check_permissions
      item = model.find(params[:id])

      if !current_user || !current_user.can_modify?(item)
        flash[:alert] = 'You do not have permission to complete that action.'
        redirect_to root_path
      end
    end

    private

    def model
      self.class.name.sub("Controller", "").singularize.constantize
    end
end
