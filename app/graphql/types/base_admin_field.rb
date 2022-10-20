module Types
  class BaseAdminField < Types::BaseField
    include AuthService
    def authorized?(obj, args, ctx)
      check_admin(ctx)
    end
  end
end