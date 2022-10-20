module Mutations
  class BaseAuthMutation < Mutations::BaseMutation
    include AuthService
    def ready?(params = nil)
      check_auth(context)
    end
  end
end