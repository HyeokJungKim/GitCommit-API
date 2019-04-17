class Commit < ActiveRecord::Base
  belongs_to :user, counter_cache: :streak
  validates :date_reference, uniqueness: true

end
