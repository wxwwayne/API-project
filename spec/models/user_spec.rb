require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  subject { user }
  specify { should respond_to :email }
  specify { should respond_to :password }
  specify { should respond_to :password_confirmation }
  specify { should be_valid }

  specify { should validate_presence_of :email }
  specify { should validate_presence_of :password }
  specify { should validate_confirmation_of :password }
  it { should allow_value('what@ever.com').for(:email) }

end
