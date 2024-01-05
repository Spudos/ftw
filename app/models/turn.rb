class Turn < ApplicationRecord
  belongs_to :turnsheet, optional: true
  attribute :turnsheet_id, :integer
end