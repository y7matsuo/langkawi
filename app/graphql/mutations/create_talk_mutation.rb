module Mutations
  class CreateTalkMutation < Mutations::BaseAuthMutation
    include TalkService

    argument :relation_id, Int
    argument :message, String

    field :talk, Types::TalkType

    def resolve(**params)
      { talk: create_talk(context[:user]&.id, params[:relation_id], params[:message]) }
    end
  end
end
