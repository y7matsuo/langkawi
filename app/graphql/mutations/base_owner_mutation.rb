module Mutations
  class BaseOwnerMutation < Mutations::BaseAuthMutation
    include AuthService
    def ready?(params)
      check_owner(params, context)
    end
  end
end
