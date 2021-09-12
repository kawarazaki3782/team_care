class InquiryMailer < ApplicationMailer
  
  def received_email(inquiry)
    @inquiry = inquiry
    mail to: Rails.application.credentials.config[:google_email_address], subject: 'お問い合わせ'
  end
end
