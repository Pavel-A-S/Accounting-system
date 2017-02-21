class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipient, class_name: 'User', foreign_key: 'sent_to'
  belongs_to :project
  belongs_to :expenditure
  has_many :events, class_name: 'Event'
  has_many :records, foreign_key: :source_id
  has_many :rights
  has_many :permitted_users, through: :rights, source: :user
  has_many :order_files

  enum ccys: [:RUR, :USD, :EUR, :CHF]
  enum state: [:preparation , :verification, :approval, :execution, :canceled,
                                                                    :executed]
  delegate :preparation?, :verification?, :approval?, :execution?, :canceled?,
                                          :executed?,  to: :current_state

  validates :subject, presence: true
  validates :amount, numericality: { greater_than: 0, less_than: 2000000000 }

  def current_state
    (self.state).inquiry
  end

  def handled?
    self.handled
  end

  def author?(user_id)
    self.user_id == user_id
  end

  def recipient?(user_id)
    self.sent_to == user_id
  end

  def has_right?(user_id)
    permitted_users.find_by(id: user_id)
  end

  def withdraw
    right = self.rights.find_by(user_id: self.sent_to)
    if right && right.delete
      self.sent_to = self.user_id
      self.preparation!
      new_event = events.create state: 'preparation', order_id: self.id,
                                                      user_id: self.user_id,
                                                      note: I18n.t(:withdrawn)
      return true
    else
      return false
    end
  end

  #-------------------------- TEMPORARY SOLUTION -------------------------------

  def get_cfo_id
    User.cfo.first.try(:id)
  end

  def get_treasurer_id
    User.treasurer.first.try(:id)
  end

  def user_cfo?(current_user_id)
    get_cfo_id && get_cfo_id == current_user_id
  end

  def user_treasurer?(current_user_id)
    get_treasurer_id && get_treasurer_id == current_user_id
  end

  #---------------------- One event of two must be deleted ---------------------

  def send_notification(new_state, current_user_id, recipient_id)
    if current_user_id != user_id
      UserMailer.new_event(id, user.email).deliver_now
    end

    if ['verification', 'approval', 'execution'].include? new_state
      if recipient_id != user_id # must not be double delivering
        recipient_email = User.find_by(id: recipient_id).try(:email)
        UserMailer.new_event(id, recipient_email).deliver_now
      end
    end
  end

  def handle_event(new_event, current_user_id, recipient_id = nil)
    if new_event.errors.any?
      new_event.errors.full_messages.map{ |error| error }
    else
      self.state = new_event.state
      self.sent_to = recipient_id if recipient_id
      self.save
      send_notification(new_event.state, current_user_id, recipient_id) and nil
    end
  end

  def set_right(user_id)
    if rights.where(user_id: user_id).blank?
      Right.create(order_id: id, user_id: user_id) if self.user_id != user_id
    end
    return nil
  end

  def changestate(newstate, current_user_id, verificator_id, note)
    message = nil
    result = nil
    case newstate
    when "preparation"
      if (verification? && recipient?(current_user_id)) ||
         (approval? && user_cfo?(current_user_id))
        new_event = events.create state: newstate, order_id: id,
                                                   user_id: current_user_id,
                                                   note: note
        result = handle_event(new_event, current_user_id)
      else
        message = I18n.t(:order_state_was_not_changed)
      end
    when "verification"
      if preparation? && author?(current_user_id)
        new_event = events.create state: newstate, order_id: id,
                                                   user_id: verificator_id,
                                                   note: note
        set_right(verificator_id) if !new_event.errors.any?
        result = handle_event(new_event, current_user_id, verificator_id)
      else
        message = I18n.t(:order_state_was_not_changed)
      end
    when "approval"
      if (preparation? && author?(current_user_id)) ||
         (verification? && recipient?(current_user_id))
        new_event = events.create state: newstate, order_id: id,
                                                   user_id: get_cfo_id,
                                                   subject: subject,
                                                   ccy: ccy,
                                                   amount: amount,
                                                   project_id: project_id
        set_right(get_cfo_id) if !new_event.errors.any?
        result = handle_event(new_event, current_user_id, get_cfo_id)
      else
        message = I18n.t(:order_state_was_not_changed)
      end
    when "execution"
      if approval? && user_cfo?(current_user_id)
        new_event = events.create state: newstate, order_id: id,
                                                   user_id: get_treasurer_id
        set_right(get_treasurer_id) if !new_event.errors.any?
        result = handle_event(new_event, current_user_id, get_treasurer_id)
      else
        message = I18n.t(:order_state_was_not_changed)
      end
    when "canceled"
      if (preparation? && author?(current_user_id)) ||
         (verification? && recipient?(current_user_id)) ||
         (approval? && user_cfo?(current_user_id)) ||
         (execution? && user_treasurer?(current_user_id)) ||
         (execution? && !get_treasurer_id && user_cfo?(current_user_id))

        new_event = events.create state: newstate, order_id: id,
                                                   user_id: current_user_id,
                                                   note: note
        result = handle_event(new_event, current_user_id)
      else
        message = I18n.t(:order_state_was_not_changed)
      end
    when "executed"
      if (execution? && user_treasurer?(current_user_id)) ||
         (approval? && !get_treasurer_id && user_cfo?(current_user_id)) ||
         (execution? && !get_treasurer_id && user_cfo?(current_user_id))

        new_event = events.create state: newstate, order_id: id,
                                                   user_id: current_user_id
        send_to_journal if !new_event.errors.any?
        result = handle_event(new_event, current_user_id)
      else
        message = I18n.t(:order_state_was_not_changed)
      end
    end
    if message
      return message
    else
      return result
    end
  end

  def log_it(current_user_id)
    events.create project_id: project_id, user_id: current_user_id,
                                          order_id: id,
                                          state: state,
                                          subject: subject,
                                          ccy: ccy,
                                          amount: amount
  end

  def send_to_journal
    records.create record_type: 'expenditure', source_id: id, ccy: ccy,
                   date: DateTime.now, description: I18n.t(:added_by_default),
                   amount: -amount
  end
end
