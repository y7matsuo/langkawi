module Types
  class BaseAuthField < Types::BaseField
    include AuthService
    def authorized?(obj, args, ctx)
      check_auth(ctx)
    end
  end
end