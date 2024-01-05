class Turnsheet < ApplicationRecord
  has_many :selections
  has_many :upgrades
  has_many :turns
end
