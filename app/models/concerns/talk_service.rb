module TalkService

  def create_talk(user_id, relation_id, message)
    relation = Relation.find(relation_id)
    validate_owners(user_id, relation)

    unless relation.status.to_sym == :accepted
      raise ApiErrors::AcceptedStatusError
    end

    Talk.create({
      relation_id: relation_id,
      message: message,
      submitter: resolve_submitter(user_id, relation),
      status: :enabled
    })
  end

  def update_talk(user_id, talk_id, params)
    talk = Talk.find(talk_id)
    validate_owner(user_id, talk, Relation.find(talk.relation_id))
    validate_update_param(talk, params)
    Talk.update(talk_id, params)
  end

  def validate_owners(user_id, relation)
    unless user_id == relation.user_from_id || user_id == relation.user_to_id
      raise ApiErrors::OwnersRequiredError
    end
  end

  def last_talks_condition(user_id)
    talk_ids = Talk.joins(:relation)
      .merge(Relation.where(user_from_id: user_id).or(Relation.where(user_to_id: user_id)))
      .group(:relation_id)
      .select('talks.id as id, max(talks.updated_at) as updated_at')
      .map { |talk| talk.id }

    Talk.where(id: talk_ids, status: :enabled)
      .eager_load(:relation)
      .order(updated_at: :desc)
  end

  private
  
  def validate_owner(user_id, talk, relation)
    validated =
      case talk.submitter.to_sym
      when :relation_from then
        user_id == relation.user_from_id
      else
        user_id == relation.user_to_id
      end
    unless validated
      raise ApiErrors::OwnerRequiredError
    end
  end

  def validate_update_param(talk, params)
    if talk.status.to_sym == :disabled
      raise ApiErrors::EnabledStatusError
    end

    status = params[:status]&.to_sym
    if status.present?
      unless status == :disabled
        raise ApiErrors::ParamsValidationError, status
      end
    end
  end

  def resolve_submitter(user_id, relation)
    user_id == relation.user_from_id ? :relation_from : :relation_to
  end
end
