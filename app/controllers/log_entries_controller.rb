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

    # The only currently supported format is JSON
    respond_to do |format|
      format.json { render :json => @entries }
    end
  end
end
