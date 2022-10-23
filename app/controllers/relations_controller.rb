class RelationsController < ApplicationController
  include RelationService

  before_action :set_pager_params, only: :index
  
  def index
    position_status = params.require(:position_status)
    validate_position_status(position_status)

    cond = user_item_condition(@user.id, position_status)

    resp = pager_response(cond.order(updated_at: :desc)) do |r|
      relation_response(@user.id, r)
    end
    render :json => resp, include: :detail
  end

  def show
    counter_user_id = params.require(:id)

    relation = find_relation(@user.id, counter_user_id)

    render_relation_response(relation)
  end

  def create
    user_from_id = @user.id
    user_to_id = params.require(:user_id)

    relation = create_relation(user_from_id, user_to_id)

    render_relation_response(relation)
  end

  def update
    counter_user_id = params.require(:id)
    status = params.require(:status)

    relation = update_relation(@user.id, counter_user_id, status)

    render_relation_response(relation)
  end

  private

  def render_relation_response(relation)
    render :json => relation_response(@user.id, relation), include: :detail
  end
end
