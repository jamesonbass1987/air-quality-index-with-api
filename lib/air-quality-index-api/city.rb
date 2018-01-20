class AirQualityIndex::City

  attr_accessor :location_city, :location_state, :todays_index, :location_city, :location_state, :current_aqi_index, :current_health_msg, :current_aqi_msg, :current_pm, :current_pm_msg, :current_ozone, :current_ozone_msg, :current_aqi_timestamp, :today_aqi, :today_aqi_num, :today_health_msg, :tomorrow_aqi, :tomorrow_health_msg, :tomorrow_aqi_num, :location_name_full, :index, :message, :link

  @@all = []


  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

end
