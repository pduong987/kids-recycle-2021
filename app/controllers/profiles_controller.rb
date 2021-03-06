class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1 or /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
   
    @user_type = params[:user_type] if params[:user_type]
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
  

    respond_to do |format|
      if @profile.save
       
        format.html { redirect_to root_path, notice: "Profile was successfully created." }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update

    respond_to do |format|

      if current_user.profile == @profile
        if @profile.update(profile_params)
          format.html { redirect_to @profile, notice: "Profile was successfully updated." }
          format.json { render :show, status: :ok, location: @profile }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end        
      else
        format.html { render :edit, status: :unauthorized }
        format.json { render json: @profile.errors, status: :unauthorized }
      end



    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy

    # Provided the current user owns this profile
    if current_user.profile == @profile

      @profile.destroy
      respond_to do |format|
        format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
        format.json { head :no_content }
      end
      # Otherwise return 401 Unauthorized
    else
      respond_to do |format|
        format.html { render :edit, status: :unauthorized }
        format.json { render json: @profile.errors, status: :unauthorized }  
      end
    end
  end

  # Add generic filters to permit profile fields
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :user_name, :user_id)
    end
end
