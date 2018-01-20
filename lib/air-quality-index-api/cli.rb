class AirQualityIndex::CLI

  #instantiates a new CLI instance for the program
  def call

    puts ''
    puts "Welcome to Air Quality Index (AQI) Grabber"
    puts ''

    self.list_options
    self.menu

  end

  #lists menu options for user to select from
  def list_options
    puts <<-DOC.gsub /^\s*/, ''

    1. Local AQI Information
    2. Top 5 Nationwide AQI Rankings
    3. General AQI Information
    4. View Previously Searched Cities

    DOC
  end

  #grabs user selection from menu and instantiates appropriate method based on that selection
  def menu

    puts ''
    puts "Please enter a numeric selection (1-4), or type exit."
    puts ''

    user_input = nil

    while user_input != 'exit'

      #gets user input
      user_input = gets.strip.downcase
      #based on user input, call appropriate class method
      case user_input
      when '1'
        if self.time_check
          puts data_unavailable_message
        else
          AirQualityIndex::LocalAQI.new.call_from_zip_code
        end
        self.return_message
      when '2'
        if self.time_check
          puts data_unavailable_message
        else
          AirQualityIndex::NationwideAQI.new.call
        end
        self.return_message
      when '3'
        AirQualityIndex::AQI_Information.new.call
        self.return_message
      when '4'

        @city_list = AirQualityIndex::City.all

        binding.pry

        if city_list.size = 0
          puts "You have no previously searched cities. Please select another option."
        else
          self.display_saved_city_info
        end

      when 'return'
        self.list_options
        self.menu
      when 'exit'
        exit!
      else
        puts "I'm sorry. I didn't understand what you meant. Please enter a numeric selection (1-3), or type exit."
      end
    end
  end

  #return message displayed after each menu selection call
  def return_message
    puts "Type 'return' to go back to the main menu, or type 'exit'."
    puts ""
  end

  #check to see if current time is between midnight and 4am EST (Data Unavailable During This Time)
  def time_check
    time =  Time.now.getlocal('-04:00')
    time.hour.between?(0,4)
  end

  #data unavailability message if hours between midnight and 4am EST
  def data_unavailable_message
    puts ''
    puts 'Updates for current conditions are not available between 12:00 a.m. and 4:00a.m. EST.'
  end

  def display_saved_city_info
    @city_list.each.with_index(1) do |city, index|
      puts "#{index}. #{city.location_city}, #{city.location_state}"
    end
  end

end
