class Permission < Struct.new(:user)
  def allow?(controller, action)
    return true if controller == "sessions"
    case user.role
    when "stock_manager"
      return true if controller == "products" && action.in?(%w[show new create edit update destroy])
    when "client_manager"
      return true if controller == "products" && action == "show"
      return true if controller == "orders"
      return true if controller == "clients"
    else
      if user.admin?
        true
      end
    end
  end
end