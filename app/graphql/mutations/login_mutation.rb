module Mutations
  class LoginMutation < Mutations::BaseMutation
    include LoginService
    
    argument :email, String
    argument :password, String

    field :token, String
    field :user_id, Int

    def resolve(email:, password:)
      dologin(email, password)
    end
  end
end