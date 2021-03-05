class HolidayService

  def self.get_holidays
    response = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/US")
    parsed = JSON.parse(response.body, symbolize_names: true)
  end

  def self.holiday_objects
    get_holidays[0..2].map do |data|
      Holiday.new(data)
    end
  end
end
