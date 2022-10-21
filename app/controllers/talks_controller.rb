class TalksController < ApplicationController
  include TalkService
  include RelationService

  before_action :set_pager_params, only: [:index, :index_rooms]

  def index
    relation_id = params.require(:relation_id)
    validate_owners(@user.id, Relation.find(relation_id))

    render :json => pager_response(Talk.where(relation_id: relation_id).order(created_at: :desc))
  end

  def create
    args = params.require(:talk).permit(:relation_id, :message)
    render :json => create_talk(@user.id, args[:relation_id], args[:message])
  end

  def update
    id = params.required(:id)
    args = params.required(:talk).permit(:message, :status)
    render :json => update_talk(@user.id, id, args)
  end

  def index_rooms
    talks = last_talks_condition(@user.id)
    resp = pager_response(talks) do |talk|
      { relation: relation_response(talk.relation), last_talk: talk }
    end
    render :json => resp
  end
end
