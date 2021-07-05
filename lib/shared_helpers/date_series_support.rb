module SharedHelpers
  module DateSeriesSupport

    def run_validation_rules
      raise Errors::ParameterValidation, "Please select one or more custom event dates." if custom_date_series? && custom_dates.blank?
      raise Errors::ParameterValidation, "Please select one or more days of the week." if weekly_date_series? && days_of_week.blank?
      if (weekly_date_series? || daily_date_series?) && (params[:from_date].blank? || params[:to_date].blank?)
        raise Errors::ParameterValidation, "Please select start and end dates."
      end
      raise Errors::ParameterValidation, "Invalid Time Range: End time must occur after start time" unless valid_time_range?
    end

    def valid_time_range?
      start_time < end_time
    end

    def start_time
      Time.parse(params[:from_time]).seconds_since_midnight.seconds
    end

    def end_time
      Time.parse(params[:to_time]).seconds_since_midnight.seconds
    end

    def new_dates
      @new_dates ||= public_send("construct_#{params[:series_type]}_dates")
    end

    def days_of_week
      params[:cwday]
    end

    def custom_dates
      params[:custom_dates]
    end

    def daily_date_series?
      params[:series_type] == 'daily'
    end

    def weekly_date_series?
      params[:series_type] == 'weekly'
    end

    def custom_date_series?
      params[:series_type] == 'custom'
    end

    def construct_custom_dates
      params[:custom_dates].delete(' ').split(',').map {|d| DateTime.strptime(d, '%Y-%m-%d')}
    end

    def construct_daily_dates
      (Date.strptime(params[:from_date], '%Y-%m-%d')..Date.strptime(params[:to_date], '%Y-%m-%d'))
    end

    def construct_weekly_dates
      days_of_week = params[:cwday].map(&:to_i)
      (Date.strptime(params[:from_date], '%Y-%m-%d')..Date.strptime(params[:to_date], '%Y-%m-%d')).select {|d| days_of_week.include?(d.cwday)}
    end
  end
end