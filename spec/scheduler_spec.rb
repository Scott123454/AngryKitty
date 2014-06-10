require 'rails_helper'
require_relative '../lib/tasks/scheduler'

describe "Scheduler" do

  let(:user){ create( :user ) }
  let(:user2){ build( :user, email: 'will@test.com' ) }

  before do 
    @event = Event.new
    @event.organiser = user
  end

  context 'when last_harassed date is nil' do

    it 'will send an email if last harrassment date is nil' do
      @event.deadline = DateTime.now + 4
      @event.save
      @event.users << user2
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq true
    end

  end

  context 'days 7 down to 4' do

    it 'will send an email if the due date more than 3 days away' do
      @event.deadline = DateTime.now + 4
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 2
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq true
    end

    it 'will send an email if the due date is less than or equal to 7 days away' do
      @event.deadline = DateTime.now + 7
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 2
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq true
    end

    it 'will not send an email if last harassed date is less than 1 day before' do
      @event.deadline = DateTime.now + 7
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 0.4
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq false
    end

  
  end

  context 'days 30 down to 8' do

    it 'will send an email if the due date is between 1 week and 1 month' do
      @event.deadline = DateTime.now + 8
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 4
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq true
    end

    it 'will not send an email if the last harassment email is within 3 days' do
     @event.deadline = DateTime.now + 30
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 3
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq false
    end
  

  end

  context 'days 60 down to 31' do
    
    it 'will send an email if the due date is between 1 month and 2 months' do
      @event.deadline = DateTime.now + 31
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 8
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq true
    end

    it 'will not send an email if the last harassment email is within 7 days' do
      @event.deadline = DateTime.now + 60
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 7
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq false
    end
  end

  context 'days 61-120' do
    
    it 'will send an email if the due date is between 2 months and 4 months' do
      @event.deadline = DateTime.now + 61
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 15
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq true
    end

    it 'will not send an email if the last harassment email is within 14 days' do
      @event.deadline = DateTime.now + 120
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 14
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq false
     end
  end

  context 'days 121+' do
    
    it 'will send an email if the due date is over 4 months' do
      @event.deadline = DateTime.now + 121
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 31
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq true
    end

    it 'will not send an email if the last harassment email is within 30 days' do
      @event.deadline = DateTime.now + 121
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 30
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq false
    end
  end

  context 'last three days to deadline' do
    it 'will send an email if the due date less than three days' do
      @event.deadline = DateTime.now + 2
      @event.save
      @event.users << user2
      debt = Debt.find_by(user: user2, event: @event)
      debt.last_harassed = DateTime.now - 1
      debt.save
      expect(send_mail?(@event.deadline, Debt.first.last_harassed)).to eq true
    end

  end
end




