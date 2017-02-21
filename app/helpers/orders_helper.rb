module OrdersHelper

  def allowed_states(order)
    order_user_id = order.user_id
    sent_to = order.sent_to
    current_state = order.state
    @allowed_states = [current_state]

    case current_state
    when "preparation"
      if current_user.id == order_user_id
        @allowed_states = [current_state] | ["verification", "approval", "canceled"]
      else
        @allowed_states = [current_state]
      end
    when "verification"
      if current_user.user? && sent_to == current_user.id
        @allowed_states = [current_state, "preparation", "approval", "canceled"]
      else
        @allowed_states = [current_state]
      end
    when "approval"
      if current_user.cfo? && cfo_treasurer_case?
        @allowed_states = [current_state] | ["preparation", "executed", "canceled"]
      elsif current_user.cfo?
        @allowed_states = [current_state] | ["preparation", "execution", "canceled"]
      else
        @allowed_states = [current_state]
      end
    when "execution"
      if cfo_treasurer_case?
        @allowed_states = [current_state] | ["canceled", "executed"]
      else
        @allowed_states = [current_state]
      end
    when "canceled"
      @allowed_states = [current_state]
    when "executed"
      @allowed_states = [current_state]
    end
  end

  def show_sender(order)
    if order.verification?
      " (" + (order.recipient.try(:name) || order.recipient.try(:email)) + ") "
    end
  end

  def users_for_verification
    accepted_users = User.where
                         .not("id = ? or role = ? or role = ? or role = ? " +
                              "or role = ?",
                              current_user.id,
                              User.roles[:cfo],
                              User.roles[:treasurer],
                              User.roles[:auditor],
                              User.roles[:admin])
    accepted_users.map{ |u| [u.name, u.id] } rescue ""
  end

  def set_order_color?(order)
    set_color = false
    if order.executed?
      paid_amount = Record.expenditure.where(source_id: order.id)
                                      .group(:ccy).sum(:amount)
      if !(paid_amount[Order.ccys[order.ccy]] == -order.amount &&
           paid_amount.count == 1) && !order.handled?
        set_color = true
      end
    end
    return set_color
  end

  def amount_checker_state(state)
    state ? t(:amount_checker_disabled) : t(:amount_checker_enabled)
  end

  def set_length(text)
    truncate(text, length: 117)
  end

  def order_get_records(order)
    records = order.try(:records)
    if records.blank?
      return nil
    else
      return records
    end
  end

end
