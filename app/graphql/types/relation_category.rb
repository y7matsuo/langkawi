module Types
  class RelationCategory < Types::BaseEnum
    value 'pending'
    value 'withdraw'
    value 'accepted'
    value 'declined'
    value 'disconnected'
    value 'refused'
  end
end
