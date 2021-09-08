class ApplicationController < ActionController::Base
  
        # the after sign in action will allow the seller to create a profile if doesn't have one, and then redirect it to the new food item to add to its listing
      def after_sign_in_path_for(profile)
        if (current_user.profile)
          #  if the user either is buyer or returning_user it will take the user to the root path 
          root_path
        else
          new_profile_path(user_type: params[:user][:user_type] ) || root_path 
        end
      end
end

