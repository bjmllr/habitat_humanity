class ShiftEvent < ActiveRecord::Base
  ACTIONS = {
    'start_shift' => 'Start Shift',
    'start_break' => 'Start Break',
    'end_break'   => 'End Break',
    'end_shift'   => 'End Shift'
  }.freeze

  belongs_to :shift

  validates :shift,       presence: true
  validates :action,      presence: true, inclusion: { in: ACTIONS }
  validates :occurred_at, presence: true
  validate :shift_day_matches_occurred_at

  delegate :address, :day, :volunteer_name, :volunteer_email, :minor, to: :shift

  scope :shift_starts, -> { where(action: 'start_shift') }
  scope :shift_ends, -> { where(action: 'end_shift') }

  def shift_day_matches_occurred_at
    return if day == occurred_at.to_date
    msg = "occurred_at (#{occurred_at.to_date}) does not match day (#{day})"
    errors.add(:day, msg)
  end
end
