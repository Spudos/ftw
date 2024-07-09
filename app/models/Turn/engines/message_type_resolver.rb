class Turn::Engines::MessageTypeResolver
  def initialize(club_messages)
    @club_messages = club_messages
  end

  def message(club_id, action_id, week, expenses)
    expenses.each do |key, value|
      @club_messages << {
        action_id:,
        week:,
        club_id:,
        var1: "Due to your home game this week, you #{message_types[key][:type]} #{value} in #{message_types[key][:category]}",
        var2: message_types[key][:var2],
        var3: value
      }
    end
  end

  def result
    @club_messages
  end

  private

  def message_types
    {
      gate_receipts: {
        category: 'gate receipts',
        var2: 'inc-gate_receipts',
        type: 'received'
      },
      hospitality_receipts: {
        category: 'hospitality income',
        var2: 'inc-hospitality',
        type: 'received'
      }
    }
  end

  # def message_types
  #   [['gate receipts', gate_receipts, 'inc-gate_receipts', 'received'],
  #    ['hospitality income', hospitality_receipts, 'inc-hospitality', 'received'],
  #    ['facilities income', facilities_receipts, 'inc-facilities', 'received'],
  #    ['programme sales', programme_receipts, 'inc-programs', 'received'],
  #    ['club shop match day', club_shop_match_income, 'inc-club_shop_match', 'received'],
  #    ['TV revenue', tv_income, 'inc-tv_income', 'received'],
  #    ['policing costs', policing_cost, 'dec-policing', 'paid'],
  #    ['stewarding costs', stewarding_cost, 'dec-stewards', 'paid'],
  #    ['medical costs', medical_cost, 'dec-medical', 'paid']]
  # end
end
