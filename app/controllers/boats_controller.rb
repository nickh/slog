class BoatsController < ApplicationController
  before_filter :require_logged_in_user, :except => :index

  def index
  end

  def create_boat
    begin
      @boat = Boat.new(params[:boat])
      @boat.save!
      flash[:notice] = "New boat created"
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.info "error creating boat: #{e}"
      flash[:error] = "Unable to create boat: #{e}"
    end

    return redirect_to(:action => :index)
  end

  def create_model
    begin
      @model = BoatModel.new(params[:model])
      @model.save!
      flash[:notice] = "New boat model created"
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.info "error creating boat model: #{e}"
      flash[:error] = "Unable to create boat model: #{e}"
    end

    return redirect_to(:action => :index)
  end

  def create_owner
    begin
      @owner = BoatOwner.new(params[:owner])
      @owner.save!
      flash[:notice] = "New boat owner created"
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.info "error creating boat owner: #{e}"
      flash[:error] = "Unable to create boat owner: #{e}"
    end

    return redirect_to(:action => :index)
  end
end