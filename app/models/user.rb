class User < ActiveRecord::Base
  has_many :events
  has_many :orders

  has_many :rights
  has_many :permitted_orders, through: :rights, source: :order

  delegate :user?, :auditor?, :admin?, :cfo?, :treasurer?, to: :current_role

  def current_role
    (self.role).inquiry
  end

  enum role: [:user, :auditor, :admin, :cfo, :treasurer]
  after_initialize :set_default_role, :if => :new_record?

  validates :name, presence: true, length: { maximum: 48 }

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable
end
