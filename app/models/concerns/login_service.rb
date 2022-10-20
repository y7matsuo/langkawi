module LoginService
  def dologin(email, password)
    account = Account.eager_load(:user).where(email: email, password: password).first!

    uuid = SecureRandom.uuid
    Session.put(uuid, account.user.id)
    { token: uuid, user_id: account.user.id }
  end

  def dologout(token)
    Session.erase token
  end
end