module Mutations
  class UpdateTalkMutation < Mutations::BaseAuthMutation
    include TalkService
    
    argument :talk_id, Int
    argument :message, String, required: false
    argument :status, Types::EnabledCategory, required: false

    field :talk, Types::TalkType

    def resolve(**params)
      { talk: update_talk(context[:user]&.id, params[:talk_id], params.slice(:message, :status)) }
    end
  end
end