require 'spec_helper'

describe Spree::User do
  let(:user) { Spree::User.create!(:email => 'test-user@pos.com', :password => 'testuser') }
  describe 'unpaid_pos_orders' do
    before do
      @paid_order = user.orders.create!
      @paid_order.update_column(:total,100)
      @paid_order.update_column(:payment_state,'paid')
      @unpaid_pos_order = user.orders.create!(:is_pos => true, :payment_state => 'checkout')
      @paid_pos_order = user.orders.create!(:is_pos => true, :payment_state => 'paid')
      @paid_pos_order.update_column(:payment_state,'paid')    
      @unpaid_order = user.orders.create!(:payment_state => 'checkout')
    end

    it { user.unpaid_pos_orders.should eq([@unpaid_pos_order]) }
  end

  describe '.create_with_random_password' do
    it 'returns a new user' do
      Spree::User.where(:email => 'test_user@pos.com').should be_blank      
      Spree::User.create_with_random_password('test_user@pos.com').should eq(Spree::User.where(:email => 'test_user@pos.com').first)
    end
  end
end