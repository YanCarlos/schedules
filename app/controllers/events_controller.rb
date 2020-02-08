class EventsController < ApplicationController
  def create
    service = CreateEventService.new(event_params)
    if service.create
      render json: { 
        message: 'The event have been created sucessfully!'
      }, status: :created
    else
      render json: {
        message: service.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(
      :starts_at,
      :ends_at,
      schedules: [:day, :time]
    )
  end
end
