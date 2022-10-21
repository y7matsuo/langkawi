module Types
  class TalkRoomType < Types::BaseObject
    field :relation, Types::RelationType
    field :last_talk, Types::TalkType

    def relation
      object.relation
    end

    def last_talk
      object
    end
  end
end