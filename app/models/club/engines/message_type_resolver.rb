class Club::Engines::MessageTypeResolver
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
      },
      facilities_receipts: {
        category: 'facilities income',
        var2: 'inc-facilities',
        type: 'received'
      },
      programme_receipts: {
        category: 'programme sales',
        var2: 'inc-programs',
        type: 'received'
      },
      club_shop_match_income: {
        category: 'club shop match day',
        var2: 'inc-club_shop_match',
        type: 'received'
      },
      tv_income: {
        category: 'TV revenue',
        var2: 'inc-tv_income',
        type: 'received'
      },
      policing_cost: {
        category: 'policing costs',
        var2: 'dec-policing',
        type: 'paid'
      },
      stewarding_cost: {
        category: 'stewarding costs',
        var2: 'dec-stewards',
        type: 'paid'
      },
      medical_cost: {
        category: 'medical costs',
        var2: 'dec-medical',
        type: 'paid'
      }
    }
  end
end
