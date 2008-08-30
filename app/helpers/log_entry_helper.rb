module LogEntryHelper
  def trip_time(entry)
    # strftime templates for displaying date/time info
    date_str = '%m-%d-%y'
    time_str = '%H:%M'
    dt_str   = date_str + ' ' + time_str

    if entry.departed_at
      start_str   = entry.departed_at.strftime(dt_str)
      if entry.arrived_at
        depart_date = Date.parse(entry.departed_at.to_s)
        arrive_date = Date.parse(entry.arrived_at.to_s)
        end_str     = entry.arrived_at.strftime(depart_date == arrive_date ? time_str : dt_str)
        start_str + '-' + end_str
      else
        'Departed at ' + start_str
      end
    else
      'Preparing to leave'
    end
  end
end