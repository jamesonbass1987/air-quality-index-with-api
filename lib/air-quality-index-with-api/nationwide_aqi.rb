class AirQualityIndexWithApi::NationwideAQI

  attr_accessor :todays_date, :national_aqi, :first_city, :second_city, :third_city, :fourth_city, :fifth_city, :html, :selected_city

  #instantiates a new pull from AirNow.gov for the top 5 current rankings on air pollution
  def call

    self.get_nationwide_data
    puts self.todays_rankings_output
    self.get_more_info?
  end

  #sets instance variables for each piece of ranking data from scraped html
  def get_nationwide_data

    #scrape page for top ranking cities
    @html = AirQualityIndex::Scraper.new.nationwide_aqi_scraper

    #create and store first rank data
    @first_city = AirQualityIndex::City.new

    self.first_city.location_name_full = self.html.search("a.NtnlSummaryCity")[0].text.strip
    self.first_city.index = self.html.search("div.TabbedPanelsContent").children.css("tr td")[1].children.text.strip
    self.first_city.message = aqi_message_set(self.first_city.index)
    self.first_city.link = html.search("a.NtnlSummaryCity")[0]['href']

    #store second rank data
    @second_city = AirQualityIndex::City.new

    self.second_city.location_name_full = self.html.search("a.NtnlSummaryCity")[1].text.strip
    self.second_city.index = self.html.search("div.TabbedPanelsContent").children.css("tr td")[6].children.text.strip
    self.second_city.message = aqi_message_set(self.second_city.index)
    self.second_city.link = html.search("a.NtnlSummaryCity")[1]['href']

    #store third rank data
    @third_city = AirQualityIndex::City.new

    self.third_city.location_name_full = self.html.search("a.NtnlSummaryCity")[2].text.strip
    self.third_city.index = self.html.search("div.TabbedPanelsContent").children.css("tr td")[11].children.text.strip
    self.third_city.message = aqi_message_set(self.third_city.index)
    self.third_city.link = html.search("a.NtnlSummaryCity")[2]['href']

    #store fourth rank data
    @fourth_city = AirQualityIndex::City.new

    self.fourth_city.location_name_full = self.html.search("a.NtnlSummaryCity")[3].text.strip
    self.fourth_city.index = self.html.search("div.TabbedPanelsContent").children.css("tr td")[16].children.text.strip
    self.fourth_city.message = aqi_message_set(self.fourth_city.index)
    self.fourth_city.link = html.search("a.NtnlSummaryCity")[3]['href']

    #store fifth rank data
    @fifth_city = AirQualityIndex::City.new

    self.fifth_city.location_name_full = self.html.search("a.NtnlSummaryCity")[4].text.strip
    self.fifth_city.index = self.html.search("div.TabbedPanelsContent").children.css("tr td")[21].children.text.strip
    self.fifth_city.message = aqi_message_set(self.fifth_city.index)
    self.fifth_city.link = html.search("a.NtnlSummaryCity")[4]['href']

  end

  #sets today's date for data output
  def todays_date
    @todays_date = Time.new
  end

  #set aqi messages based off of aqi index ranking
  def aqi_message_set(index)
    case index.to_i
      when 0..50
        "Good"
      when 51..100
        "Moderate"
      when 101..150
        "Unhealthy For Sensitive Groups"
      when 151..200
        "Unhealthy"
      when 201..300
        "Very Unhealthy"
      else
        "Hazardous"
    end
  end

  #outputs nationwide ranking information from scraped web data
  def todays_rankings_output
    puts ""
    puts "Nationwide AQI Rankings for #{self.todays_date.month}/#{self.todays_date.day}/#{self.todays_date.year}"
    puts ""
    puts <<-DOC
    1. #{self.first_city.location_name_full} - #{self.first_city.index} (#{self.first_city.message})
    2. #{self.second_city.location_name_full} - #{self.second_city.index} (#{self.second_city.message})
    3. #{self.third_city.location_name_full} - #{self.third_city.index} (#{self.third_city.message})
    4. #{self.fourth_city.location_name_full} - #{self.fourth_city.index} (#{self.fourth_city.message})
    5. #{self.fifth_city.location_name_full} - #{self.fifth_city.index} (#{self.fifth_city.message})
    DOC
  end

  #asks user if they would like additional information on any of the ranked cities, if so, passes selected city instance to the local_aqi method call and then returns instance
  def get_more_info?

    puts "Would you like local information for any of the cities listed? Please enter a numerical value 1-5, type 'exit' to end program, or type return to go to the main menu."
    puts ""

    @selected_city = nil

    user_input = nil

    #perform until user types a correct response from the available options
    while !['1','2','3','4','5','exit','return'].include?(user_input)

      #gets user input
      user_input = gets.strip.downcase

      #depending on user input, sets new local aqi instance to city_info variable
      case user_input
        when '1'
          self.selected_city = AirQualityIndex::LocalAQI.new.call_from_ranking(self.first_city)
        when '2'
          self.selected_city = AirQualityIndex::LocalAQI.new.call_from_ranking(self.second_city)
        when '3'
          self.selected_city = AirQualityIndex::LocalAQI.new.call_from_ranking(self.third_city)
        when '4'
          self.selected_city = AirQualityIndex::LocalAQI.new.call_from_ranking(self.fourth_city)
        when '5'
          self.selected_city = AirQualityIndex::LocalAQI.new.call_from_ranking(self.fifth_city)
        when 'exit'
          exit!
        when 'return'
          AirQualityIndex::CLI.new.call
        else
          puts "I'm sorry. I didn't quite understand what you meant. Please enter a numerical value 1-5, type 'exit' to end program, or type return to go to the main menu."
        end

      end

    #return city_info if user selected one
    self.selected_city.local_aqi_return unless self.selected_city.nil?

  end

end
