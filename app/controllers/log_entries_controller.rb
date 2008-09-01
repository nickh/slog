class LogEntriesController < ApplicationController
  before_filter :require_logged_in_user, :except => :index

  def index
    # If the request is from a logged-in user, show their full list of
    # log entries; otherwise show a list of the 20 most recent completed
    # entries.
    if @current_user
      @entries = @current_user.log_entries
    else
      @entries = LogEntry.find(
        :all,
        :order => 'arrived_at DESC',
        :conditions => 'arrived_at IS NOT NULL',
        :limit => 20
      )
    end

    respond_to do |format|
      format.html
      format.json { render :json => {:entries => @entries } }
    end
  end

  # Provide a basic view for adding new log entries
  def new
    @entry = LogEntry.new
    respond_to {|format| format.html}
  end

  # Create a new log entry
  def create
    begin
      @entry = LogEntry.new(params[:log_entry])
      @entry.user = @current_user
      @entry.save!
      flash[:notice] = "New log entry created"
    rescue Exception => e
      flash[:error] = "Unable to create log entry: #{e}"
    end

    return redirect_to(:action => :index)
  end

  # Edit an existing log entry
  def edit
    begin
      @entry = LogEntry.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Unable to find log entry with id #{params[:id]}"
      return redirect_to(:action => :index)
    end

    respond_to {|format| format.html}
  end

  # Update an existing log entry
  def update
    begin
      @entry = @current_user.log_entries.find(params[:id])
      @entry.update_attributes! params[:log_entry]
      flash[:notice] = "Log entry updated"
      return redirect_to(:action => :index)
    rescue ActiveRecord::RecordNotFound
      @entry = nil
      flash[:error] = "Unable to find log entry with id #{params[:id]}"
      return redirect_to(:action => :index)
    rescue Exception => e
      flash[:error] = "Unable to update log entry: #{e}"
    end

    respond_to {|format| format.html}
  end
end
