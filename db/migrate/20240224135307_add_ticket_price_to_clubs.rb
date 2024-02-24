class AddTicketPriceToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :ticket_price, :integer
  end
end
