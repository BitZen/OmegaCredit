# Preview all emails at http://localhost:3000/rails/mailers/credit_notifier
class CreditNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/credit_notifier/created
  def created
    CreditNotifier.created
  end

  # Preview this email at http://localhost:3000/rails/mailers/credit_notifier/expired
  def expired
    CreditNotifier.expired
  end

end
