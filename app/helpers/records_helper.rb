module RecordsHelper

  def all_incomes
    Income.all.collect { |income| [truncate(income.name, length: 117),
                                   income.id] }
  end

  def set_source(record)
    if record.income?
      if income = record.income
        if name = truncate(income.try(:name), length: 117)
          link_to name, income_path(record.source_id), class: 'simple_link'
        end
      else
        if record.description.blank? || controller.action_name == 'show'
          t(:no_source)
        else
          truncate(t(:no_source) + '. ' + record.description, length: 117)
        end
      end
    elsif record.expenditure?
      if expenditure = record.expenditure
        name = truncate(expenditure.try(:subject), length: 117)
        link_to name, order_path(record.source_id), class: 'simple_link' if name
      else
        if record.description.blank? || controller.action_name == 'show'
          t(:no_order)
        else
          truncate(t(:no_order) + '. ' + record.description, length: 117)
        end
      end
    elsif record.exchange?
      exchange = record.exchange
      if exchange
        name = t(exchange.from_currency) + '/' + t(exchange.to_currency)
        link_to name, exchange_path(record.source_id), class: 'simple_link'
      end
    end
  end

  def set_initiator(record)
    if record.expenditure?
      if order = record.expenditure
        if name = order.user.try(:name)
          name
        end
      else
        record.user.try(:name)
      end
    elsif record.exchange?
      if exchange = record.exchange
        if name = exchange.user.try(:name)
          name
        end
      end
    end
  end

  def options_for_income(record)
    record.income? ? default_value = record.source_id : default_value = nil
    options_for_select(all_incomes, default_value)
  end

  def options_for_expenditure(record)
    record.expenditure? ? default_value = record.source_id : default_value = nil
    options_for_select(permitted_selection_values(default_value), default_value)
  end

  def options_for_expenditure_type(record)
    if record.expenditure_id.blank?
      default_value = nil
    else
      default_value = record.expenditure_id
    end

    options_for_select(Expenditure.all.collect { |e| [e.name, e.id] },
                       default_value)
  end

  def options_for_project(record)
    if record.project_id.blank?
      default_value = nil
    else
      default_value = record.project_id
    end
    options_for_select(Project.all.collect { |p| [p.name, p.id] },
                       default_value)
  end

  def options_for_user(record)
    if record.user_id.blank?
      default_value = nil
    else
      default_value = record.user_id
    end
    options_for_select(User.all.collect { |u| [u.name, u.id] },
                       default_value)
  end

  def permitted_selection_values(default_value)
    options = []
    all_orders = Order.executed
    paid_amounts_by_orders = Record.expenditure.group(:source_id, :ccy)
                                               .sum(:amount)
    all_orders.each do |o|
      order_data = [o.id, Order.ccys[o.ccy]]
      if (paid_amounts_by_orders[order_data].blank? ||
          o.id == default_value ||
          (paid_amounts_by_orders[order_data] &&
           -o.amount < paid_amounts_by_orders[order_data])) && !o.handled?
        options << [truncate(o.subject, length: 117), o.id]
      end
    end
    options
  end

  def set_record_color?(record)
    set_color = false
    source_id = record.source_id
    if record.expenditure? && source_id && order = Order.find_by(id: source_id)
      paid_amount = Record.expenditure.where(source_id: source_id).group(:ccy)
                                                                  .sum(:amount)
      if !(paid_amount[Order.ccys[order.ccy]] == -order.amount &&
           paid_amount.count == 1) && !order.handled?
        set_color = true
      end
    end
    return set_color
  end

  def show_project(record)
    if record.expenditure?
      if order = record.expenditure
        if project = order.project
          project.name
        end
      else
        record.project.try(:name)
      end
    elsif record.income?
      if income = record.income
        if project = income.project
          project.name
        end
      else
        record.project.try(:name)
      end
    end
  end

  def show_state(record)
    if record.expenditure?
      if order = record.expenditure
        if state = order.expenditure
          state.name
        end
      else
        record.expenditure_type.try(:name)
      end
    end
  end

end
