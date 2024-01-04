class Turn < ApplicationRecord
  belongs_to :turnsheet
  attribute :turnsheet_id, :integer
end
