require 'spec_helper'

describe User::Identities::EmailVerification do

  context 'after two weeks' do
    subject :old_password_reset do
      verification_life_span = 2.weeks + 1.day
      Timecop.travel verification_life_span.ago do
        User::Identities::EmailVerification.password_reset.create(recipient: Faker::Internet.safe_email)
      end
    end

    it {is_expected.to be_stale}
  end

  it 'cannot be created with a badly formatted email address'

end
