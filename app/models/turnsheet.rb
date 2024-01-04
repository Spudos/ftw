class Turnsheet < ApplicationRecord
  has_many :selections, dependent: :destroy
  has_many :upgrades, dependent: :destroy
  has_many :turns, dependent: :destroy
end
