class ListingsController < ApplicationController


  def index

    @listings = []

    free = params[:free]

    if(free == "true" || free == true)

      @listings = Listing.where("price <= ?", 0.0)

      render "free"
    else


      @q = Listing.ransack(params[:q])
     
      @listings = @q.result

      #@listings = Listing.where("price > ?", 0.0)
    end

  end
  
  def new
      #If user is login then redirect to the login page
      #else redirect to the sell form page
      if user_signed_in?
        # if user has created a profile, show the sell page , else redirect to creating profile page 
        if current_user.profile
          @listing = Listing.new
        else
          redirect_to new_profile_path
        end
      else
        redirect_to new_user_session_path
      end    
  end

  def create

    @listing = Listing.new(listing_params)
  
    @listing.seller_id = current_user.profile.id

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end

  end


  def show

    @listing = Listing.find(params[:id])

    if params[:checkout] == "success"

      @listing.buyer_id = current_user.profile.id
      @listing.save
    end

  end  

  def edit
    @listing = Listing.find(params[:id])
  end

  def update

    respond_to do |format|

      @listing = Listing.update(params[:id],listing_params)
      if @listing
        format.html { redirect_to @listing, notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end

  end  

  def destroy

    respond_to do |format|

      @listing = Listing.destroy(params[:id])
      if @listing
        format.html { redirect_to @listing, notice: "Listing was successfully destroyed." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end

  end

  
  private

  # Only allow a list of trusted parameters through.
  def listing_params
    params.require(:listing).permit(:title, :description, :price, :status, :location, :create_at, :buyer_id, :seller_id, :profile_id, pictures: [])
  end

end
