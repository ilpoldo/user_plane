require 'spec_helper'

describe User::Identities::EmailVerification do


  let :old_password_reset do
    verification_life_span = 2.weeks + 1.day
    Timecop.travel verification_life_span.ago do
      User::Identities::EmailVerification.password_reset.create
    end
  end

  let(:new_password_reset) { User::Identities::EmailVerification.password_reset.create }

  it "has an expiration date" do
    expect(old_password_reset).to be_stale
  end

  it "has a default scope that enforces tokens freshness" do
    old_password_reset
    new_password_reset

    expect(User::Identities::EmailVerification.password_reset).to include(new_password_reset)
    expect(User::Identities::EmailVerification.password_reset).not_to include(old_password_reset)
  end

end
