require 'test_helper'

class CreditNotifierTest < ActionMailer::TestCase
  test "created" do
    mail = CreditNotifier.created
    assert_equal "Created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "expired" do
    mail = CreditNotifier.expired
    assert_equal "Expired", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
