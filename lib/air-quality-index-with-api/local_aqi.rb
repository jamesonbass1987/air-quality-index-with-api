class AirQualityIndexWithApi::LocalAQI

  attr_accessor :zip_code, :doc, :city

  #instantiates new instance based on the Local AQI option in the CLI menu
  def call_from_zip_code

    #grab user's zip code,
    self.zip_code_grabber

    #call scraper class method to access html of page based on zip code
    @doc = AirQualityIndex::Scraper.new.local_aqi_scraper(self.zip_code)

    #return aqi information, unless unavailable for that zip code
    self.aqi_info_validation_return(self.doc)
  end

  # grab zip code from user for local aqi instance
  def zip_code_grabber

    puts ''
    puts "Please enter your 5-digit zip code:"
    puts ''

    @zip_code = nil

    # checks for zip code validation utilzing is_zip_code? method
    while !self.is_zip_code?(self.zip_code)

      self.zip_code = gets.chomp

      if !self.is_zip_code?(self.zip_code)
          puts ""
          puts "I'm sorry. That entry was invalid. Please enter a valid 5 digit zip code."
          puts ""
      end
    end

    #return zip_code
    self.zip_code.to_i
  end

  #check to see if zip code is valid
  def is_zip_code?(user_zip)
    if user_zip.nil?
      false
    else
      user_zip.size == 5 && user_zip.to_i.to_s == user_zip && !user_zip.nil?
    end
  end

  #passes ranked_city instance from the Nationwide rankings based on user selection
  def call_from_ranking(ranked_city)

    site_link = 'https://airnow.gov/'

    #call scraper class method to access html of page based ranking
    @doc = AirQualityIndex::Scraper.new.nationwide_scraper_more_info(site_link.concat(ranked_city.link))

    #return aqi information for ranked city
    self.aqi_info_validation_return(self.doc, ranked_city)
  end

  #check to see if page information is available based on scraped web site data (based on zip), otherwise proceed with aqi info pull
  def aqi_info_validation_return(html, city = nil)

    page_message = html.search("h2").text.strip

    if page_message.include? "does not currently have Air Quality data"
      puts ""
      puts page_message
    else
      #store information as local instance variables
      self.local_aqi_index(city)
      #return aqi index information
      self.local_aqi_return
    end
  end

  #assign scraped information to instance variables
  def local_aqi_index(city)

    #If a ranked city instance is supplied, set @city to this instance, otherwise, create a new city instance
    city.nil?? @city = AirQualityIndex::City.new : @city = city

    #store location information
    self.city.location_city = self.doc.search(".ActiveCity").text.strip
    self.city.location_state = self.doc.search("a.Breadcrumb")[1].text.strip

    #store aqi index
    set_msg_or_attribute('current_aqi_index', self.doc.at('.TblInvisible').css('tr td').children[1])
    set_msg_or_attribute('current_aqi_msg', self.doc.search("td.AQDataLg")[0])
    set_msg_or_attribute('current_health_msg', self.doc.search("td.HealthMessage")[0])

    #store current aqi/ozone data
    set_msg_or_attribute('current_pm', self.doc.search("table")[14].children.css("td")[4])
    set_msg_or_attribute('current_pm_msg', self.doc.search("td.AQDataPollDetails")[3])
    set_msg_or_attribute('current_ozone', self.doc.search("table")[14].children.css("td")[1])
    set_msg_or_attribute('current_ozone_msg', self.doc.search("td.AQDataPollDetails")[1])

    #Extract time from site
    self.city.current_aqi_timestamp = self.timestamp
    self.doc.search("td.AQDataContent")[0].css("tr")[2].text.strip

    #store todays forecast data
    set_msg_or_attribute('today_aqi', self.doc.search("td.AQDataContent")[0].css("td")[3])
    set_msg_or_attribute('today_aqi_num', self.doc.search("td.AQDataContent")[0].css("tr")[2])
    set_msg_or_attribute('today_health_msg', self.doc.search("td.HealthMessage")[1])

    #store tomorrows forecast data
    set_msg_or_attribute('tomorrow_aqi', self.doc.search("td.AQDataContent")[1].css("td")[3])
    set_msg_or_attribute('tomorrow_aqi_num', self.doc.search("td.AQDataContent")[1].css("tr")[2])
    set_msg_or_attribute('tomorrow_health_msg', self.doc.search("td.HealthMessage")[2])

    #save instance to City.all
    self.city.save

    #return self
    self
  end

  #Checks attribute passed in checking for nil, if nil, appends "Information Not Available" message, else, sets parsed/scraped data to attribute
  def set_msg_or_attribute(attribute, data)

    #Store 'Data Unavailable Message' as variable. Each method below checks for a nil return and sets message if found.
    unavailable_msg = "Data Not Currently Available"

    #if data is nil and assessing a health message attribute, concatinate "Health Message" to unavailable msg
    if data.nil? && attribute.include?("health_msg")
      self.city.send("#{attribute}=", "Health Message: ".concat(unavailable_msg))

    #Else if data is nil and not part of Health Message attribute, set unavailable message to attribute
    elsif data.nil?
      self.city.send("#{attribute}=", unavailable_msg)

    #Else data is available, set to attribute
    else
      self.city.send("#{attribute}=", data.text.strip)
    end
  end

  #grabs timestamp of aqi measurement, if none available, sets to "Time Unavailable" and returns
  def timestamp
    timestamp = self.doc.search("td.AQDataSectionTitle").css("small").text.split(" ")
    if timestamp != []
      timestamp[0].capitalize!
      timestamp = timestamp.join(" ")
    else
      timestamp = 'Time Captured Unavailable'
    end
    timestamp
  end

  #return output message with scraped information
  def local_aqi_return

    puts <<-DOC

    Current Conditions in #{self.city.location_city}, #{self.city.location_state} (#{self.city.current_aqi_timestamp}):

    AQI: #{self.city.current_aqi_index} (#{self.city.current_aqi_msg})
    #{self.city.current_health_msg}

    Ozone: #{self.city.current_ozone} (#{self.city.current_ozone_msg})
    Particulate Matter: #{self.city.current_pm} (#{self.city.current_pm_msg})

    Today's Forecast in #{self.city.location_city}, #{self.city.location_state}

    AQI: #{self.city.today_aqi_num} (#{self.city.today_aqi})
    #{self.city.today_health_msg}

    Tomorrow's Forecast in #{self.city.location_city}, #{self.city.location_state}

    AQI: #{self.city.tomorrow_aqi_num} (#{self.city.tomorrow_aqi})
    #{self.city.tomorrow_health_msg}

    DOC
  end

end
