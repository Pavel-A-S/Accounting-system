module RightsDeterminer
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
  end

  def can_see_as_auditor_cfo_treasurer?
    current_user.auditor? || current_user.cfo? || current_user.treasurer?
  end

  def can_he_edit_as_author?(order)
    order.author?(current_user.id) && order.preparation?
  end

  def cfo_treasurer_case?
    (current_user.cfo? && User.treasurer.first.try(:id).blank?) ||
     current_user.treasurer?
  end

  def cfo_or_treasurer?
    current_user && (current_user.cfo? || current_user.treasurer?)
  end

  # Has CFO access as Treasurer?
  def cfo_as_treasurer?
    current_user.cfo? && User.treasurer.first.try(:id).blank?
  end

  # Can he edit? (Yes/No)
  def can_he_edit?(order)
    (order.author?(current_user.id) && order.preparation?) ||
    special_access_for_cfo_or_treasurer?(order.state)
  end

  # Is it special access for CFO or Treasurer?
  def special_access_for_cfo_or_treasurer?(state)
    (current_user.cfo? && state == 'approval') ||
    (current_user.treasurer? && ['execution', 'executed'].include?(state)) ||
    (cfo_as_treasurer? && ['approval', 'execution', 'executed'].include?(state))
  end

  def can_he_see?(order)
    order.author?(current_user.id) || order.has_right?(current_user.id) ||
    cfo_treasurer_case? || current_user.auditor? ||
    (current_user.cfo? && order.state == 'approval')
  end
end
