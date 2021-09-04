class ListingsController < ApplicationController


  # This is used to get all listings based on a query
  def index

    @listings = []

    # Check if we only want free items
    free = params[:free]

    # If only Free items then show listing with 0 price.
    if(free == "true" || free == true)

      @listings = Listing.where("price <= ?", 0.0)

    # Else Return search results based on ransack logic
    else

      @q = Listing.ransack(params[:q])
     
      @listings = @q.result

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

  # Used to perform the action of creating a listing
  def create

    # Create a new one
    @listing = Listing.new(listing_params)
  
    # Set the seller to the profile of the logged in user
    @listing.seller_id = current_user.profile.id

    respond_to do |format|

      # Provided the save worked, show new listing
      if @listing.save
        format.html { redirect_to @listing, notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end

  end


  # Used to get an individual item and mark as sold
  def show

    # Find single item
    @listing = Listing.find(params[:id])

    # If the checkout was successful
    if params[:checkout] == "success"

      # Mark as sold
      @listing.buyer_id = current_user.profile.id
      @listing.save
    end

  end  

  def edit
    @listing = Listing.find(params[:id])
  end

  # This is the action to perform update on listing
  def update


    respond_to do |format|

      # Find the single listing
      @listing = Listing.find(params[:id])

      # Provided the listing seller is the same as logged in user
      if current_user.profile == @listing.seller

        # Update the record
        @listing = Listing.update(params[:id],listing_params)
        if @listing
          format.html { redirect_to @listing, notice: "Listing was successfully updated." }
          format.json { render :show, status: :ok, location: @listing }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @listing.errors, status: :unprocessable_entity }
        end

        # Otherwise return a 401 unauthorized
      else
        format.html { render :edit, status: :unauthorized }
        format.json { render json: @listing.errors, status: :unauthorized }
      end
    end

  end  

  # Used to delete the listing
  def destroy

    respond_to do |format|

      # Get individual listing
      @listing = Listing.find(params[:id])

      # Profiled the current user is the same as the seller
      if current_user.profile == @listing.seller

        # Delete the single record
        @listing = Listing.destroy(params[:id])
        if @listing
          format.html { redirect_to @listing, notice: "Listing was successfully destroyed." }
          format.json { render :show, status: :ok, location: @listing }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @listing.errors, status: :unprocessable_entity }
        end
        # Otherwise return 401 unauthorized
      else
        format.html { render :edit, status: :unauthorized }
        format.json { render json: @listing.errors, status: :unauthorized }        
      end
    end

  end

  
  # Here we apply generic filters for acceptable listing fields.
  private

  # Only allow a list of trusted parameters through.
  def listing_params
    params.require(:listing).permit(:title, :description, :price, :status, :location, :create_at, :buyer_id, :seller_id, :profile_id, pictures: [])
  end

end
