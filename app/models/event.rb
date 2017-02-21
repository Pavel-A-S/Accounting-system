class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  #     attr_accessible :state

  validates_presence_of :order_id
  #validates_inclusion_of :state, in: Order::STATES
  validates :state, inclusion: { in: Order::states.keys }
  validates_presence_of :user_id
  validates :note, presence: true, if: :necessary?

  def necessary?
    ["preparation","verification","canceled"].include? state
  end

  def self.with_last_state(state)
    order("id desc").group("order_id").having(state: state)
    #
    #order("id desc").group("order_id").having(:events => { :state => state })   
    #state: state)
  end
  
  
end
