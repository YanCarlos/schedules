class CreateEventService
  attr_reader :errors

  def initialize(params)
    @schedules = params.delete(:schedules)
    @event = params
    @errors = []
  end

  def create
    ActiveRecord::Base.transaction do
      begin
        save_event(@event)

        @schedules.each do |schedule|
          save_schedule(schedule)
        end

        return true
      rescue ActiveRecord::RecordInvalid
        @errors = generate_errors
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def save_event(event)
    @event = Event.new(event)
    @event.save!
  end

  def save_schedule(schedule)
    @schedule = Schedule.new(schedule)
    @schedule.event = @event
    @schedule.save!
  end

  def generate_errors
    schedule_errors = @schedule&.errors ? @schedule.errors.full_messages : []
    event_errors = @event&.errors ?  @event.errors.full_messages : []
    event_errors + schedule_errors
  end
end
