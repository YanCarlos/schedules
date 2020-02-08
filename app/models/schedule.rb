class Schedule < ApplicationRecord
  belongs_to :event

  enum day: {
    monday: 0,
    tuesday: 1,
    wednesday: 2,
    thursday: 3,
    friday: 4,
    saturday: 5,
    sunday: 6
  }

  validates :day, presence: true
  validates :day, inclusion: { in: days.keys }
  validates :time, presence: true

  validate :schedule_integrity

  def schedule_integrity
    if is_there_a_same_schedule?
      errors.add(:base, 
        "You can't create repeated schedules: #{day} at #{nice_time} is repeated."
      )
    end
  end

  def nice_time
    time.strftime('%H:%M')
  end

  private
  
  def is_there_a_same_schedule?
    Schedule.where(event: event, day: day, time: time).empty? ? false : true
  end
end
