class BoatsController < ApplicationController
  before_filter :require_logged_in_user, :except => :index

  def index
    @boats  = Boat.find(:all)
  end

  # Create a new boat
  def create
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

  # Edit an existing boat
  def edit
    begin
      @boat = Boat.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Unable to find boat with id #{params[:id]}"
      return redirect_to(:action => :index)
    end

    respond_to {|format| format.html}
  end

  # Update an existing boat
  def update
    begin
      @boat = Boat.find(params[:id])
      @boat.update_attributes! params[:boat]
      flash[:notice] = "Boat updated"
      return redirect_to(:action => :index)
    rescue ActiveRecord::RecordNotFound
      @entry = nil
      flash[:error] = "Unable to find boat with id #{params[:id]}"
      return redirect_to(:action => :index)
    rescue Exception => e
      flash[:error] = "Unable to update boat: #{e}"
    end

    respond_to do |format|
      format.html { render :action => :edit }
    end
  end

  # Add a boat model
  def create_model
    begin
      @model = BoatModel.new(params[:boat_model])
      @model.save!
      flash[:notice] = "New boat model created"
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.info "error creating boat model: #{e}"
      flash[:error] = "Unable to create boat model: #{e}"
    end

    return redirect_to(:action => :index)
  end

  # Add a boat owner
  def create_owner
    begin
      @owner = BoatOwner.new(params[:boat_owner])
      @owner.save!
      flash[:notice] = "New boat owner created"
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.info "error creating boat owner: #{e}"
      flash[:error] = "Unable to create boat owner: #{e}"
    end

    return redirect_to(:action => :index)
  end
end