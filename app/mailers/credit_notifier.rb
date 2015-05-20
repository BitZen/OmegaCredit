class CreditNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.credit_notifier.created.subject
  #
  def created(creditholder,credit)
    @creditholder = creditholder
    @credit = credit
    mail to: @creditholder.email_address, subject: 'Omegabooks credit processed'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.credit_notifier.expired.subject
  #
  def expired
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
