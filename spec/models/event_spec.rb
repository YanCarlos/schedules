require 'rails_helper'

describe Event do
  it { should have_many(:schedules) }
  it { should validate_presence_of(:starts_at) }
  it { should validate_presence_of(:ends_at) }
end
