module Types
  class RelationPositionCategory < Types::BaseEnum
    value 'pending_me'
    value 'pending_you'
    value 'withdraw_me'
    value 'accepted_me'
    value 'accepted_you'
    value 'declined_me'
    value 'declined_you'
    value 'disconnected_me'
    value 'disconnected_you'
    value 'refused_me'
    value 'refused_you'
  end
end
