module LoginSupport
  def sign_in_as(user)
    visit login_path
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    expect(page).to have_button 'ログイン'
    click_button 'ログイン'
    expect(page).to have_content 'マイページ'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
