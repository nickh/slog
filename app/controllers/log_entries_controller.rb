class LogEntriesController < ApplicationController
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
    if @current_user
      @entry = LogEntry.new
    else
      flash[:error] = 'You must be logged in to add log entries'
    end
    respond_to {|format| format.html}
  end

  # Create a new log entry
  def create
    if @current_user
      begin
        @entry = LogEntry.new(params[:log_entry])
        @entry.user = @current_user
        @entry.save!
        return redirect_to(:action => :index)
      rescue Exception => e
        flash[:error] = "Unable to create log entry: #{e}"
      end
    else
      flash[:error] = 'You must be logged in to add log entries'
    end
    respond_to {|format| format.html}
  end
end
