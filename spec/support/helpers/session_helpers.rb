module Features
  module SessionHelpers
    def sign_up_with(email, password, confirmation)
      visit new_user_registration_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', :with => confirmation
      click_button 'Sign up'
    end

    def log_in(user_data)
      visit new_user_session_path
      fill_in I18n.t(:email), with: user_data[:email]
      fill_in I18n.t(:password), with: user_data[:password]
      click_button I18n.t(:sign_in)
    end
  end
end
