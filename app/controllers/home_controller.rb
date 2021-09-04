class HomeController < ApplicationController

  # This is the main home page.
  def page
    # Get all listings to show on the home page
    @listings = Listing.all
  end
end
