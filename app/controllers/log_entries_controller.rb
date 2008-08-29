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
end
