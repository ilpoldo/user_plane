require 'spec_helper'
require 'shared_contexts/user'

describe User::SignIn do
  include_context 'user'

  context 'with a valid email/password combination' do
    subject :sign_in do
      described_class.new(email: a_user.email.address, 
                 password: a_user.email.password)
            .sign_in_with(User::Identities::Email)
    end

    it {is_expected.to be_valid}
  end

  context 'with a bad email/password combination' do
    subject :sign_in do
      described_class.new(email: a_user.email.address, 
                 password: '')
            .sign_in_with(User::Identities::Email)
    end

    before {subject.valid?}

    it {is_expected.not_to be_valid}
    it {expect(subject.errors).to include(:base)}
    it {expect(subject.errors).not_to include(:identity)}
  end

end