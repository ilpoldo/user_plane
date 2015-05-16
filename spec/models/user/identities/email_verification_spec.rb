require 'spec_helper'

describe User::Identities::EmailVerification do
  subject :password_reset do
    described_class.password_reset.create(recipient: Faker::Internet.safe_email)
  end

  it 'can be spent' do
    password_reset.spend
    expect(password_reset).to be_valid
  end


  context 'after two weeks' do
    subject :old_password_reset do
      verification_life_span = 2.weeks + 1.day
      Timecop.travel verification_life_span.ago do
        described_class.password_reset.create(recipient: Faker::Internet.safe_email)
      end
    end

    it {is_expected.to be_stale}

    it 'cannot be spent' do
      old_password_reset.spend
      expect(old_password_reset).not_to be_valid
    end
  end

  context 'once spent' do
    subject :spent_password_reset do
      described_class.password_reset.create(recipient: Faker::Internet.safe_email, spent_at: Time.now)
    end

    it 'cannot be spent again' do
      spent_password_reset.spend
      expect(spent_password_reset).not_to be_valid
    end

  end

end
