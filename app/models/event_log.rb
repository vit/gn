class EventLog < ApplicationRecord
    belongs_to :loggable, polymorphic: true

end
