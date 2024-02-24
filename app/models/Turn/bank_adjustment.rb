class Turn::BankAdjustment
  attr_reader :action_id, :week, :club_id, :reason, :dept, :amount

  def initialize(action_id, week, club_id, reason, dept, amount)
    @action_id = action_id
    @week = week
    @club_id = club_id
    @reason = reason
    @dept = dept
    @amount = amount
  end

  def call
    bank_adjustment
  end

  private

  def bank_adjustment
    club_full = Club.find_by(id: club_id)
    new_bal = club_full.bank_bal.to_i - amount.to_i
    club_full.update(bank_bal: new_bal)

    if reason == 'coach'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}", var2: 'payment', var3: amount.to_i)
    elsif reason == 'property'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{dept}", var2: 'payment', var3: amount.to_i)
    elsif reason == 'unmanaged_bid'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due a player purchase (#{dept})", var2: 'payment', var3: amount.to_i)
    elsif reason == 'circuit'
      amount_positive = (amount * -1).to_i
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was creditied with #{amount_positive} due a player sale (#{dept})", var2: 'receipt', var3: amount.to_i)
    elsif reason.end_with?('condition')
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{reason}", var2: 'payment', var3: amount.to_i)
    elsif reason == 'contract'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to a 24 week contract renewal for #{dept}", var2: 'payment', var3: amount.to_i)
    elsif reason == 'loyalty'
      Message.create(action_id:, week:, club_id:, var1: "You paid an amount to #{dept} to thank him for his contribution to the club.  He now feels more loyal and is more likely to stick with the team in difficult times.  You bank was charged with #{amount}", var2: 'payment', var3: amount.to_i)
    elsif reason == 'listed_sale'
      amount_positive = (amount * -1).to_i
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was creditied with #{amount_positive} due a player sale (#{dept})", var2: 'receipt', var3: amount.to_i)
    elsif reason == 'deal_sale'
      amount_positive = (amount * -1).to_i
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was creditied with #{amount_positive} due a player sale (#{dept})", var2: 'payment', var3: amount.to_i)
    elsif reason == 'listed_purchase'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due a player purchase (#{dept})", var2: 'payment', var3: amount.to_i)
    elsif reason == 'deal_purchase'
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due a player purchase (#{dept})", var2: 'payment', var3: amount.to_i)
    else
      Message.create(action_id:, week:, club_id:, var1: "Your bank account was charged with #{amount} due to starting an upgrade to #{club_full[reason.gsub("capacity", "name")]}", var2: 'payment', var3: amount.to_i)
    end
  end
end
