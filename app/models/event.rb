class Event < ApplicationRecord
  has_many :schedules, dependent: :destroy

  validates :starts_at, presence: true
  validates :ends_at, presence: true

  validate :starts_at_integrity


  def starts_at_integrity
    return if starts_at.nil? || ends_at.nil?

    if starts_at > ends_at
      errors.add(:base, "Starts at must be less than ends at")
    end

    if starts_at < Time.zone.today
      errors.add(:base, "Starts at can't be in the past")
    end
  end
end
