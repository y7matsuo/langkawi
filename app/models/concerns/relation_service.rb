module RelationService

  def relation_response(user_id, relation)
    {
      user: resolve_relation_user(user_id, relation),
      position_status: resolve_relation_position_status(user_id, relation),
      next_statuses: resolve_relation_next_statuses(user_id, relation)
    }.merge(relation.extract_id_date)
  end

  def resolve_relation_user(user_id, relation)
    if relation.user_from_id == user_id then
      relation.user_to
    else
      relation.user_from
    end
  end

  def resolve_relation_position_status(user_id, relation)
    if relation.user_from_id == user_id then
      "#{relation.status}_me"
    else
      "#{relation.status}_you"
    end
  end

  def resolve_relation_next_statuses(user_id, relation)
    position_status = resolve_relation_position_status(user_id, relation)
    permitted_transition_statuses(position_status).map(&:to_s)
  end

  def find_relation(owner_user_id, counter_user_id)
    Relation
      .where(user_from_id: owner_user_id, user_to_id: counter_user_id)
      .or(Relation.where(user_from_id: counter_user_id, user_to_id: owner_user_id))
      .eager_load(user_from: :detail, user_to: :detail)
      .first!
  end

  def user_item_condition(user_id, position_status)
    status, position = position_status.split('_')
    case position.to_sym
    when :me then
      user_to_item_condition(user_id, status)
    else
      user_from_item_condition(user_id, status)
    end
  end

  def validate_position_status(position_status)
    unless position_statuses.include? position_status
      raise ApiErrors::ParamsValidationError, position_status
    end
  end

  def create_relation(user_from_id, user_to_id)
    User.find(user_to_id)

    if user_from_id == user_to_id
      raise ApiErrors::IdenticalUserError
    end

    if Relation.exists?(user_from_id: user_to_id, user_to_id: user_from_id)
      raise ApiErrors::CounterRelationExistError
    end

    Relation.create({
      user_from_id: user_from_id,
      user_to_id: user_to_id,
      status: :pending
    }.merge({ action_date_by_next_status(:pending) => DateTime.current }))
  end

  def update_relation(owner_user_id, counter_user_id, status)
    relation = find_relation(owner_user_id, counter_user_id)
    position_status = position_status(owner_user_id, relation)

    validate_update_param(position_status, status)

    relation.status = status
    relation[action_date_by_next_status(status)] = Time.current
    relation.save!
    relation
  end

  private

  def user_from_item_condition(user_id, status)
    Relation.where(user_to_id: user_id, status: status).eager_load(user_from: :detail)
  end 

  def user_to_item_condition(user_id, status)
    Relation.where(user_from_id: user_id, status: status).eager_load(user_to: :detail)
  end

  def position_statuses
    statues_with("me").zip(statues_with "you").flatten
  end

  def statues_with(suffix)
    Relation.statuses.map(&:first).map { |s| "#{s}_#{suffix}"}
  end

  def validate_update_param(position_status, status, &)
    validate_position_status(position_status)
    unless permitted_transition_statuses(position_status).include? status.to_sym
      raise ApiErrors::ParamsValidationError, status
    end
  end

  def action_date_by_next_status(status)
    case status.to_sym
    when :pending then
      :action_a_date
    when :withdraw, :declined, :accepted then
      :action_b_date
    else
      :action_c_date
    end
  end

  def permitted_transition_statuses(position_status)
    case position_status.to_sym
    when :pending_me then
      [:withdraw]
    when :pending_you then
      [:accepted, :declined]
    when :withdraw_me then
      [:pending]
    when :accepted_me then
      [:disconnected]
    when :accepted_you then
      [:refused]
    else
      []
    end
  end
end
