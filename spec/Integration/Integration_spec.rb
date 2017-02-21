require 'rails_helper'
require 'devise'

RSpec.describe 'Check Statuses:', type: :feature do

  before :all do
    #----------------------------- User data -----------------------------------

    # User
    @user_data = { id: 1, name: 'User', email: 'User@test.ru', role: :user,
                   password: "12345678" }

    @user = FactoryGirl.create(:user, @user_data)

    # Orders
    @user_order1 = { id: 1, user_id: 1, state: 'preparation', subject: 'test',
                                                              amount: 100,
                                                              sent_to: nil }
    @user_order2 = { id: 2, user_id: 1, state: 'verification', subject: 'test',
                                                               amount: 100,
                                                               sent_to: 6 }
    @user_order3 = { id: 3, user_id: 1, state: 'approval', subject: 'test',
                                                           amount: 100,
                                                           sent_to: 4 }
    @user_order4 = { id: 4, user_id: 1, state: 'execution', subject: 'test',
                                                            amount: 100,
                                                            sent_to: 5 }
    @user_order5 = { id: 5, user_id: 1, state: 'canceled', subject: 'test',
                                                           amount: 100,
                                                           sent_to: nil }
    @user_order6 = { id: 6, user_id: 1, state: 'executed', subject: 'test',
                                                           amount: 100,
                                                           sent_to: nil }

    FactoryGirl.create(:order, @user_order1)
    FactoryGirl.create(:order, @user_order2)
    FactoryGirl.create(:order, @user_order3)
    FactoryGirl.create(:order, @user_order4)
    FactoryGirl.create(:order, @user_order5)
    FactoryGirl.create(:order, @user_order6)

    #------------------------ Verificator data ---------------------------------

    # User
    @verificator_data = { id: 6, name: 'Verificator',
                          email: 'Verificator@test.ru', role: :user,
                          password: "12345678" }

    @verificator = FactoryGirl.create(:user, @verificator_data)

    # Orders
    @verificator_order1 = { id: 11, user_id: 6, state: 'preparation',
                                                subject: 'test',
                                                amount: 100,
                                                sent_to: nil }
    @verificator_order2 = { id: 12, user_id: 6, state: 'verification',
                                                subject: 'test',
                                                amount: 100,
                                                sent_to: 6 }
    @verificator_order3 = { id: 13, user_id: 6, state: 'approval',
                                                subject: 'test',
                                                amount: 100,
                                                sent_to: 4 }
    @verificator_order4 = { id: 14, user_id: 6, state: 'execution',
                                                subject: 'test',
                                                amount: 100,
                                                sent_to: 5 }
    @verificator_order5 = { id: 15, user_id: 6, state: 'canceled',
                                                subject: 'test',
                                                amount: 100,
                                                sent_to: nil }
    @verificator_order6 = { id: 16, user_id: 6, state: 'executed',
                                                subject: 'test',
                                                amount: 100,
                                                sent_to: nil }

    FactoryGirl.create(:order, @verificator_order1)
    FactoryGirl.create(:order, @verificator_order2)
    FactoryGirl.create(:order, @verificator_order3)
    FactoryGirl.create(:order, @verificator_order4)
    FactoryGirl.create(:order, @verificator_order5)
    FactoryGirl.create(:order, @verificator_order6)

    #----------------------------- CFO data ------------------------------------

    # User
    @cfo_data = { id: 4, name: 'CFO', email: 'CFO@test.ru', role: :cfo,
                  password: '12345678' }

    @cfo = FactoryGirl.create(:user, @cfo_data)

    # Orders
    @cfo_order1 = { id: 21, user_id: 4, state: 'preparation',
                                               subject: 'test',
                                               amount: 100,
                                               sent_to: nil }
    @cfo_order2 = { id: 22, user_id: 4, state: 'verification',
                                               subject: 'test',
                                               amount: 100,
                                               sent_to: 6 }
    @cfo_order3 = { id: 23, user_id: 4, state: 'approval',
                                               subject: 'test',
                                               amount: 100,
                                               sent_to: 4 }
    @cfo_order4 = { id: 24, user_id: 4, state: 'execution',
                                               subject: 'test',
                                               amount: 100,
                                               sent_to: 5 }
    @cfo_order5 = { id: 25, user_id: 4, state: 'canceled',
                                               subject: 'test',
                                               amount: 100,
                                               sent_to: nil }
    @cfo_order6 = { id: 26, user_id: 4, state: 'executed',
                                               subject: 'test',
                                               amount: 100,
                                               sent_to: nil }
    FactoryGirl.create(:order, @cfo_order1)
    FactoryGirl.create(:order, @cfo_order2)
    FactoryGirl.create(:order, @cfo_order3)
    FactoryGirl.create(:order, @cfo_order4)
    FactoryGirl.create(:order, @cfo_order5)
    FactoryGirl.create(:order, @cfo_order6)

    #-------------------------- Treasurer data ---------------------------------

    # User
    @treasurer_data = { id: 5, name: 'Treasurer', email: 'Treasurer@test.ru',
                        role: :treasurer, password: '12345678' }

    @treasurer = FactoryGirl.create(:user, @treasurer_data)

    # Orders
    @treasurer_order1 = { id: 31, user_id: 5, state: 'preparation',
                                              subject: 'test',
                                              amount: 100,
                                              sent_to: nil }
    @treasurer_order2 = { id: 32, user_id: 5, state: 'verification',
                                              subject: 'test',
                                              amount: 100,
                                              sent_to: 6 }
    @treasurer_order3 = { id: 33, user_id: 5, state: 'approval',
                                              subject: 'test',
                                              amount: 100,
                                              sent_to: 4 }
    @treasurer_order4 = { id: 34, user_id: 5, state: 'execution',
                                              subject: 'test',
                                              amount: 100,
                                              sent_to: 5 }
    @treasurer_order5 = { id: 35, user_id: 5, state: 'canceled',
                                              subject: 'test',
                                              amount: 100,
                                              sent_to: nil }
    @treasurer_order6 = { id: 36, user_id: 5, state: 'executed',
                                              subject: 'test',
                                              amount: 100,
                                              sent_to: nil }

    FactoryGirl.create(:order, @treasurer_order1)
    FactoryGirl.create(:order, @treasurer_order2)
    FactoryGirl.create(:order, @treasurer_order3)
    FactoryGirl.create(:order, @treasurer_order4)
    FactoryGirl.create(:order, @treasurer_order5)
    FactoryGirl.create(:order, @treasurer_order6)

    #--------------------------- Auditor data ----------------------------------

    # User
    @auditor_data = { id: 3, name: 'Auditor', email: 'Auditor@test.ru',
                      role: :auditor, password: '12345678' }

    @auditor = FactoryGirl.create(:user, @auditor_data)

    # -------------------------- In Progress -----------------------------------

    @admin_data = { id: 2, name: 'Admin', email: 'Admin@test.ru', role: :admin,
                    password: '12345678' }

    @admin = FactoryGirl.create(:user, @admin_data)

    # --------------------------- Rights for CFO -------------------------------

    @cfo_right_to_user_order_in_preparation = { order_id: 1, user_id: 4 }
    @cfo_right_to_user_order_in_verification = { order_id: 2, user_id: 4 }
    @cfo_right_to_user_order_in_approval = { order_id: 3, user_id: 4 }
    @cfo_right_to_user_order_in_execution = { order_id: 4, user_id: 4 }
    @cfo_right_to_user_order_in_canceled = { order_id: 5, user_id: 4 }
    @cfo_right_to_user_order_in_executed = { order_id: 6, user_id: 4 }

    FactoryGirl.create(:right, @cfo_right_to_user_order_in_preparation)
    FactoryGirl.create(:right, @cfo_right_to_user_order_in_verification)
    FactoryGirl.create(:right, @cfo_right_to_user_order_in_approval)
    FactoryGirl.create(:right, @cfo_right_to_user_order_in_execution)
    FactoryGirl.create(:right, @cfo_right_to_user_order_in_canceled)
    FactoryGirl.create(:right, @cfo_right_to_user_order_in_executed)

    # --------------------- Rights for verificator -----------------------------

    @verificator_right_to_user_order_in_preparation = { order_id: 1,
                                                        user_id: 6 }
    @verificator_right_to_user_order_in_verification = { order_id: 2,
                                                         user_id: 6 }
    @verificator_right_to_user_order_in_approval = { order_id: 3,
                                                     user_id: 6 }
    @verificator_right_to_user_order_in_execution = { order_id: 4,
                                                      user_id: 6 }
    @verificator_right_to_user_order_in_canceled = { order_id: 5,
                                                     user_id: 6 }
    @verificator_right_to_user_order_in_executed = { order_id: 6,
                                                     user_id: 6 }

    FactoryGirl.create(:right, @verificator_right_to_user_order_in_preparation)
    FactoryGirl.create(:right, @verificator_right_to_user_order_in_verification)
    FactoryGirl.create(:right, @verificator_right_to_user_order_in_approval)
    FactoryGirl.create(:right, @verificator_right_to_user_order_in_execution)
    FactoryGirl.create(:right, @verificator_right_to_user_order_in_canceled)
    FactoryGirl.create(:right, @verificator_right_to_user_order_in_executed)

    # ----------------------- Rights for treasurer -----------------------------

    @treasurer_right_to_user_order_in_preparation = { order_id: 1, user_id: 5 }
    @treasurer_right_to_user_order_in_verification = { order_id: 2, user_id: 5 }
    @treasurer_right_to_user_order_in_approval = { order_id: 3, user_id: 5 }
    @treasurer_right_to_user_order_in_execution = { order_id: 4, user_id: 5 }
    @treasurer_right_to_user_order_in_canceled = { order_id: 5, user_id: 5 }
    @treasurer_right_to_user_order_in_executed = { order_id: 6, user_id: 5 }

    FactoryGirl.create(:right, @treasurer_right_to_user_order_in_preparation)
    FactoryGirl.create(:right, @treasurer_right_to_user_order_in_verification)
    FactoryGirl.create(:right, @treasurer_right_to_user_order_in_approval)
    FactoryGirl.create(:right, @treasurer_right_to_user_order_in_canceled)
    FactoryGirl.create(:right, @treasurer_right_to_user_order_in_execution)
    FactoryGirl.create(:right, @treasurer_right_to_user_order_in_executed)
  end

  # -------------------------------- User --------------------------------------
  describe "User" do

    it 'Must get main page' do
      log_in @user_data
      expect(page).to have_content I18n.t(:current_orders)
    end

    it "Records must be 'In progress' and must have correct select options" do
      log_in @user_data
      visit orders_path
      expect(page).to have_select("state", count: 1)
      expect(page).to have_css("div.order_state", count: 3)

      expect(page).to have_select("state", options: ['preparation',
                                                     'verification',
                                                     'approval',
                                                     'canceled'],
                                           count: 1)

      expect(page).to have_css("div.order_state", text: 'verification',
                                                  count: 1)

      expect(page).to have_css("div.order_state", text: 'approval',
                                                  count: 1)

      expect(page).to have_css("div.order_state", text: 'execution',
                                                  count: 1)
    end

    it 'No select tags in canceled orders and only canceled records exist' do
      log_in @user_data
      visit canceled_orders_path
      expect(page).to have_css("td", text: "canceled", count: 1)
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "executed")
    end

    it 'No select tags in executed orders and only executed records exist' do
      log_in @user_data
      visit executed_orders_path
      expect(page).to have_css("td", text: "executed", count: 1)
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "canceled")
    end
  end

  #-------------------------------- Verificator --------------------------------
  describe "Verificator" do
    it "Records must be 'In progress' and must have correct select options" do
      log_in @verificator_data
      visit orders_path
      expect(page).to have_select("state", count: 3)
      expect(page).to have_css("div.order_state", count: 5)



      expect(page).to have_css("div.order_state", text: 'preparation',
                                                  count: 1)

      expect(page).to have_select("state", options: ['preparation',
                                                     'verification',
                                                     'approval',
                                                     'canceled'],
                                           count: 3)



      expect(page).to have_css("div.order_state", text: 'approval',
                                                  count: 2)



      expect(page).to have_css("div.order_state", text: 'execution',
                                                  count: 2)

    end

    it 'No select tags in canceled orders and only canceled records exist' do
      log_in @verificator_data
      visit canceled_orders_path
      expect(page).to have_css("td", text: "canceled", count: 2)
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "executed")
    end

    it 'No select tags in executed orders and only executed records exist' do
      log_in @verificator_data
      visit executed_orders_path
      expect(page).to have_css("td", text: "executed", count: 2)
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "canceled")
    end
  end

  #--------------------------------- CFO ---------------------------------------

  describe "CFO" do
    it "Records must be 'In progress' and must have correct select options" do
      log_in @cfo_data
      visit orders_path
      expect(page).to have_select("state", count: 3)
      expect(page).to have_css("div.order_state", count: 5)

      expect(page).to have_css("div.order_state", text: 'preparation',
                                                  count: 1)

      expect(page).to have_select("state", options: ['preparation',
                                                     'verification',
                                                     'approval',
                                                     'canceled'],
                                           count: 1)

      expect(page).to have_css("div.order_state", text: 'verification',
                                                  count: 2)


      expect(page).to have_select("state", options: ['preparation',
                                                     'approval',
                                                     'canceled',
                                                     'execution'],
                                           count: 2)

      expect(page).to have_css("div.order_state", text: 'execution',
                                                  count: 2)
    end

    it 'No select tags in canceled orders and only canceled records exist' do
      log_in @cfo_data
      visit canceled_orders_path
      expect(page).to have_css("td", text: "canceled", count: 2)
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "executed")
    end

    it 'No select tags in executed orders and only executed records exist' do
      log_in @cfo_data
      visit executed_orders_path
      expect(page).to have_css("td", text: "executed", count: 2)
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "canceled")
    end
  end

  #--------------------------- CFO as Treasurer --------------------------------

  describe "CFO as Treasurer" do
    before :each do
      @treasurer = User.treasurer.first
      @treasurer.role = 'user'
      @treasurer.save
    end

    it "Records must be 'In progress' and must have correct select options" do
      log_in @cfo_data
      visit orders_path
      expect(page).to have_select("state", count: 9)
      expect(page).to have_css("div.order_state", count: 7) # 5

      expect(page).to have_css("div.order_state", text: 'preparation',
                                                  count: 3) # 1

      expect(page).to have_select("state", options: ['preparation',
                                                     'verification',
                                                     'approval',
                                                     'canceled'],
                                           count: 1)

      expect(page).to have_css("div.order_state", text: 'verification',
                                                  count: 4) # 2


      expect(page).to have_select("state", options: ['preparation',
                                                     'approval',
                                                     'canceled',
                                                     'executed'],
                                           count: 4)

      expect(page).to have_select("state", options: ['execution',
                                                     'canceled',
                                                     'executed'],
                                           count: 4)
    end

    it 'No select tags in canceled orders and only canceled records exist' do
      log_in @cfo_data
      visit canceled_orders_path
      expect(page).to have_css("td", text: "canceled", count: 4) # 2
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "executed")
    end

    it 'No select tags in executed orders and only executed records exist' do
      log_in @cfo_data
      visit executed_orders_path
      expect(page).to have_css("td", text: "executed", count: 4) # 2
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "canceled")
    end
  end

  #------------------------------- Treasurer -----------------------------------

  describe "Treasurer" do
    it "Records must be 'In progress' and must have correct select options" do
      log_in @treasurer_data
      visit orders_path
      expect(page).to have_select("state", count: 5) # 3
      expect(page).to have_css("div.order_state", count: 11) # 5

      expect(page).to have_css("div.order_state", text: 'preparation',
                                                  count: 3) # 1

      expect(page).to have_select("state", options: ['preparation',
                                                     'verification',
                                                     'approval',
                                                     'canceled'],
                                           count: 1)

      expect(page).to have_css("div.order_state", text: 'verification',
                                                  count: 4) # 2

      expect(page).to have_css("div.order_state", text: 'approval',
                                                  count: 4) # 2

      expect(page).to have_select("state", options: ['execution',
                                                     'executed',
                                                     'canceled'],
                                           count: 4) # 2
    end

  #-------------------------- Treasurer old case -------------------------------

#    it "Records must be 'In progress' and must have correct select options" do
#      log_in @treasurer_data
#      visit orders_path
#      expect(page).to have_select("state", count: 3)
#      expect(page).to have_css("div.order_state", count: 5)

#      expect(page).to have_css("div.order_state", text: 'preparation',
#                                                  count: 1)

#      expect(page).to have_select("state", options: ['preparation',
#                                                     'verification',
#                                                     'approval',
#                                                     'canceled'],
#                                           count: 1)

#      expect(page).to have_css("div.order_state", text: 'verification',
#                                                  count: 2)

#      expect(page).to have_css("div.order_state", text: 'approval',
#                                                  count: 2)

#      expect(page).to have_select("state", options: ['execution',
#                                                     'executed',
#                                                     'canceled'],
#                                           count: 2)
#    end

    it 'No select tags in canceled orders and only canceled records exist' do
      log_in @treasurer_data
      visit canceled_orders_path
      expect(page).to have_css("td", text: "canceled", count: 4) # 2
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "executed")
    end

    it 'No select tags in executed orders and only executed records exist' do
      log_in @treasurer_data
      visit executed_orders_path
      expect(page).to have_css("td", text: "executed", count: 4) # 2
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "canceled")
    end
  end

  #-------------------------------- Auditor ------------------------------------

  describe "Auditor" do
    it "Records must be 'In progress' and must have correct select options" do
      log_in @auditor_data
      visit orders_path
      expect(page).to have_css("div.order_state", count: 16)

      expect(page).to have_css("div.order_state", text: 'preparation',
                                                  count: 4)

      expect(page).to have_css("div.order_state", text: 'verification',
                                                  count: 4)

      expect(page).to have_css("div.order_state", text: 'approval',
                                                  count: 4)

      expect(page).to have_css("div.order_state", text: 'execution',
                                                  count: 4)
    end

    it 'No select tags in canceled orders and only canceled records exist' do
      log_in @auditor_data
      visit canceled_orders_path
      expect(page).to have_css("td", text: "canceled", count: 4)
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "executed")
    end

    it 'No select tags in executed orders and only executed records exist' do
      log_in @auditor_data
      visit executed_orders_path
      expect(page).to have_css("td", text: "executed", count: 4)
      expect(page).not_to have_select("order_state")
      expect(page).not_to have_css("td", text: "preparation")
      expect(page).not_to have_css("td", text: "verification")
      expect(page).not_to have_css("td", text: "approval")
      expect(page).not_to have_css("td", text: "execution")
      expect(page).not_to have_css("td", text: "canceled")
    end
  end

  # puts "#{page.html.inspect}"
end
