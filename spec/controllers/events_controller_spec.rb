require 'rails_helper'

describe EventsController do
  describe '#create' do
    context 'when everything is ok' do
      let(:event) {
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

      before do
        post :create, params: { event: event }
      end

      it 'creates the event and its schedules' do
        last_event_created = Event.last

        expect(last_event_created.starts_at).to eq(event[:starts_at])
        expect(last_event_created.ends_at).to eq(event[:ends_at])
      end

      it 'creates the schedules of event' do
        schedules = Event.last.schedules

        expect(schedules.count).to eq(3)
        expect(schedules.first.day).to eq('monday')
      end

      it 'returns a success message' do
        result = JSON.parse(response.body)['message']

        expect(result).to eq('The event have been created sucessfully!')
      end

      it 'returns a code 201 (created)' do
        expect(response.status).to eq(201)
      end
    end

    context 'when starts_at is empty' do
      let(:event) {
        {
          starts_at: '',
          ends_at: Time.zone.today + 5,
          schedules: [
            { day: 'monday', time: Time.zone.now },
            { day: 'tuesday', time: Time.zone.now },
            { day: 'wednesday', time: Time.zone.now }
          ]
        }
      }

      before do
        post :create, params: { event: event }
      end

      it 'does not create the event' do
        expect(Event.count).to eq(0)
      end

      it 'does no create any schedule' do
        expect(Schedule.count).to eq(0)
      end

      it 'returns an error message' do
        result = JSON.parse(response.body)['message'][0]

        expect(result).to eq("Starts at can't be blank")
      end

      it 'returns a code 402 (unprocessable_entity)' do
        expect(response.status).to eq(422)
      end
    end

    context 'when ends_at is empty' do
      let(:event) {
        {
          starts_at: Time.zone.today,
          ends_at: '',
          schedules: [
            { day: 'monday', time: Time.zone.now },
            { day: 'tuesday', time: Time.zone.now },
            { day: 'wednesday', time: Time.zone.now }
          ]
        }
      }

      before do
        post :create, params: { event: event }
      end

      it 'does not create the event' do
        expect(Event.count).to eq(0)
      end

      it 'does no create any schedule' do
        expect(Schedule.count).to eq(0)
      end

      it 'returns an error message' do
        result = JSON.parse(response.body)['message'][0]

        expect(result).to eq("Ends at can't be blank")
      end

      it 'returns a code 402 (unprocessable_entity)' do
        expect(response.status).to eq(422)
      end
    end

    context 'when starts_at is less than ends_at is empty' do
      let(:event) {
        {
          starts_at: Time.zone.today,
          ends_at: Time.zone.today - 1,
          schedules: [
            { day: 'monday', time: Time.zone.now },
            { day: 'tuesday', time: Time.zone.now },
            { day: 'wednesday', time: Time.zone.now }
          ]
        }
      }

      before do
        post :create, params: { event: event }
      end

      it 'does not create the event' do
        expect(Event.count).to eq(0)
      end

      it 'does no create any schedule' do
        expect(Schedule.count).to eq(0)
      end

      it 'returns an error message' do
        result = JSON.parse(response.body)['message'][0]

        expect(result).to eq("Starts at must be less than ends at")
      end

      it 'returns a code 402 (unprocessable_entity)' do
        expect(response.status).to eq(422)
      end
    end

    context 'when date (starts_at) is in past' do
      let(:event) {
        {
          starts_at: Time.zone.today - 3,
          ends_at: Time.zone.today,
          schedules: [
            { day: 'monday', time: Time.zone.now },
            { day: 'tuesday', time: Time.zone.now },
            { day: 'wednesday', time: Time.zone.now }
          ]
        }
      }

      before do
        post :create, params: { event: event }
      end

      it 'does not create the event' do
        expect(Event.count).to eq(0)
      end

      it 'does no create any schedule' do
        expect(Schedule.count).to eq(0)
      end

      it 'returns an error message' do
        result = JSON.parse(response.body)['message'][0]

        expect(result).to eq("Starts at can't be in the past")
      end

      it 'returns a code 402 (unprocessable_entity)' do
        expect(response.status).to eq(422)
      end
    end

    context 'When schedules are not valid' do
      context 'when day empty' do
        let(:event) {
          {
            starts_at: Time.zone.today,
            ends_at: Time.zone.today + 1,
            schedules: [
              { day: '', time: Time.zone.now },
              { day: 'tuesday', time: Time.zone.now },
              { day: 'wednesday', time: Time.zone.now }
            ]
          }
        }

        before do
          post :create, params: { event: event }
        end

        it 'does not create the event' do
          expect(Event.count).to eq(0)
        end

        it 'does no create any schedule' do
          expect(Schedule.count).to eq(0)
        end

        it 'returns an error message' do
          result = JSON.parse(response.body)['message'][0]

          expect(result).to eq("Day can't be blank")
        end

        it 'returns a code 402 (unprocessable_entity)' do
          expect(response.status).to eq(422)
        end
      end

      context 'when time empty' do
        let(:event) {
          {
            starts_at: Time.zone.today,
            ends_at: Time.zone.today + 1,
            schedules: [
              { day: 'monday', time: '' },
              { day: 'tuesday', time: Time.zone.now },
              { day: 'wednesday', time: Time.zone.now }
            ]
          }
        }

        before do
          post :create, params: { event: event }
        end

        it 'does not create the event' do
          expect(Event.count).to eq(0)
        end

        it 'does no create any schedule' do
          expect(Schedule.count).to eq(0)
        end

        it 'returns an error message' do
          result = JSON.parse(response.body)['message'][0]

          expect(result).to eq("Time can't be blank")
        end

        it 'returns a code 402 (unprocessable_entity)' do
          expect(response.status).to eq(422)
        end
      end

      context 'when there are repeated schedules' do
        let(:event) {
          {
            starts_at: Time.zone.today,
            ends_at: Time.zone.today + 1,
            schedules: [
              { day: 'tuesday', time: Time.zone.now },
              { day: 'tuesday', time: Time.zone.now },
              { day: 'wednesday', time: Time.zone.now }
            ]
          }
        }

        before do
          post :create, params: { event: event }
        end

        it 'does not create the event' do
          expect(Event.count).to eq(0)
        end

        it 'does no create any schedule' do
          expect(Schedule.count).to eq(0)
        end

        it 'returns an error message' do
          result = JSON.parse(response.body)['message'][0]

          expect(result).to include("You can't create repeated schedules")
        end

        it 'returns a code 402 (unprocessable_entity)' do
          expect(response.status).to eq(422)
        end
      end
    end
  end
end
