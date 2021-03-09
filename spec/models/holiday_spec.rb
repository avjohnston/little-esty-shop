require 'rails_helper'

RSpec.describe HolidayService, type: :model do
  describe 'class methods' do
    it '#get_holidays' do
      expect(HolidayService.get_holidays.class).to eq(Array)
      expect(HolidayService.get_holidays.first.class).to eq(Hash)
    end

    it '#holiday_objects' do
      expect(HolidayService.holiday_objects.class).to eq(Array)
      expect(HolidayService.holiday_objects.first.class).to eq(Holiday)
    end
  end
end
