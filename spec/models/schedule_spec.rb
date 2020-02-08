require 'rails_helper'

describe Schedule do
  it { should belong_to(:event) }
  it { should validate_presence_of(:day) }
  it { should validate_presence_of(:time) }

  describe '#nice_time' do
    let(:time) { '12:40' }
    let!(:event) { 
      Event.new({ starts_at: Time.zone.today, ends_at: Time.zone.today })
    }

    let!(:schedule) {
      Schedule.new({ event: event, day: 'monday', time: time })
    }

    it 'returns hour and minute' do
      expect(schedule.nice_time).to eq(time)
    end
  end
end
