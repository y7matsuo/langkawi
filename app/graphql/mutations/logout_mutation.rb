module Mutations
  class LogoutMutation < Mutations::BaseAuthMutation
    include LoginService
    
    field :message, String

    def resolve
      dologout(context[:token])
      { message: 'success' }
    end
  end
end