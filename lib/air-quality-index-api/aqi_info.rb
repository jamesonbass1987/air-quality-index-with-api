class AirQualityIndex::AQI_Information

  #prints general AQI information
  def call

    puts ''
    puts "Each category corresponds to a different level of health concern. The six levels of health concern and what they mean are:"
    puts ''
    puts '"Good" AQI is 0 to 50. Air quality is considered satisfactory, and air pollution poses little or no risk.'
    puts ''
    puts '"Moderate" AQI is 51 to 100. Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people. For example, people who are unusually sensitive to ozone may experience respiratory symptoms.'
    puts ''
    puts '"Unhealthy for Sensitive Groups" AQI is 101 to 150. Although general public is not likely to be affected at this AQI range, people with lung disease, older adults and children are at a greater risk from exposure to ozone, whereas persons with heart and lung disease, older adults and children are at greater risk from the presence of particles in the air.'
    puts ''
    puts '"Unhealthy" AQI is 151 to 200. Everyone may begin to experience some adverse health effects, and members of the sensitive groups may experience more serious effects.'
    puts ''
    puts '"Very Unhealthy" AQI is 201 to 300. This would trigger a health alert signifying that everyone may experience more serious health effects.'
    puts ''
    puts '"Hazardous" AQI greater than 300. This would trigger a health warnings of emergency conditions. The entire population is more likely to be affected.'
    puts ''

  end

end
