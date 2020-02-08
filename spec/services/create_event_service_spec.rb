require 'rails_helper'

describe CreateEventService do
  describe '#create' do
    let!(:service) { CreateEventService.new(params) }

    context 'When event is valid' do
      let(:params) {
        {
          starts_at: Time.zone.today,
          ends_at: Time.zone.today + 5,
          schedules: [
            { day: 'monday', time: Time.zone.now },
            { day: 'tuesday', time: Time.zone.now },
            { day: 'wednesday', time: Time.zone.now }
          ]
        }
      }

      it 'returns a true' do
        expect(service.create).to eq(true)
      end

      it 'does not contain errors' do
        service.create

        expect(service.errors).to eq([])
      end

      it 'creates the event' do
        service.create

        expect(Event.count).to eq(1)
      end

      it 'creates schedules of the event' do
        service.create

        expect(Event.last.schedules.count).to eq(3)
      end
    end

    context 'when event is not valid' do
      let(:params) {
        {
          starts_at: '',
          ends_at: '',
          schedules: [
            { day: 'monday', time: Time.zone.now },
            { day: 'tuesday', time: Time.zone.now },
            { day: 'wednesday', time: Time.zone.now }
          ]
        }
      }

      it 'does not create the event' do
        service.create

        expect(Event.count).to eq(0)
      end

      it 'does not create schedules of the event' do
        service.create

        expect(Schedule.count).to eq(0)
      end
      

      it 'does contains 2 errors' do
        service.create

        expect(service.errors.count).to eq(2)
      end

      it 'contains the starts_at validation error' do
        service.create

        expect(service.errors).to include("Starts at can't be blank")
      end

      it 'contains the ends_at validation error' do
        service.create

        expect(service.errors).to include("Ends at can't be blank")
      end
    end

    context 'when schedule is not valid' do
      let(:params) {
        {
          starts_at: Time.zone.today,
          ends_at: Time.zone.today + 2,
          schedules: [
            { day: '', time: '' },
            { day: 'tuesday', time: Time.zone.now },
            { day: 'wednesday', time: Time.zone.now }
          ]
        }
      }

      it 'does not create the event' do
        service.create

        expect(Event.count).to eq(0)
      end

      it 'does not create schedules of the event' do
        service.create

        expect(Schedule.count).to eq(0)
      end
      
      it 'does contains 1 error' do
        service.create

        expect(service.errors.count).to eq(3)
      end

      it 'contains the day validation error' do
        service.create

        expect(service.errors).to include("Day can't be blank")
      end

      it 'contains the time validation error' do
        service.create

        expect(service.errors).to include("Time can't be blank")
      end
    end


    context 'when day of schedule is not valid weekday' do
      let(:params) {
        {
          starts_at: Time.zone.today,
          ends_at: Time.zone.today + 2,
          schedules: [
            { day: '', time: Time.zone.now },
            { day: 'tuesday', time: Time.zone.now },
            { day: 'wednesday', time: Time.zone.now }
          ]
        }
      }

      it 'does not create the event' do
        service.create

        expect(Event.count).to eq(0)
      end

      it 'does not create schedules of the event' do
        service.create

        expect(Schedule.count).to eq(0)
      end

      it 'contains the day inclusion error' do
        service.create

        expect(service.errors).to include("Day is not included in the list")
      end
    end
  end
end
