class AirQualityIndexWithApi::APICall

  #scrape AQI webpage based on submitted zip code
  def local_aqi_scraper(zip_code)
    Nokogiri::HTML(open("https://airnow.gov/index.cfm?action=airnow.local_city&zipcode=#{zip_code}"))
  end

  #scrape main AQI website to grab top rankings for air quality
  def nationwide_aqi_scraper
    Nokogiri::HTML(open("https://airnow.gov/index.cfm?action=airnow.main"))
  end

  #scrape main AQI website to grab individual page from top ranking based on user input
  def nationwide_scraper_more_info(link)
    Nokogiri::HTML(open(link))
  end

end
