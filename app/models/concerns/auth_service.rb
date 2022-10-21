module AuthService
  
  def check_auth(context)
    user_id = Session.get(context[:token])
    context[:user] = user_id && User.find(user_id)
    user_id.present? || (raise GraphQL::ExecutionError, "Authorization required")
  end

  def check_owner(arguments, context)
    (check_auth(context) && arguments.key?(:user_id) && context[:user]&.id == arguments[:user_id]) || (raise GraphQL::ExecutionError, "Owner required")
  end

  def check_admin(context)
    (check_auth(context) && context[:user]&.admin?) || (raise GraphQL::ExecutionError, "Admin required")
  end
end