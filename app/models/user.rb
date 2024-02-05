class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [:user, :manager, :gm]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :gm
  end
end

#------------------------------------------------------------------------------
# User
#
# Name                   SQL Type             Null    Primary Default
# ---------------------- -------------------- ------- ------- ----------
# id                     INTEGER              false   true              
# email                  varchar              false   false             
# encrypted_password     varchar              false   false             
# reset_password_token   varchar              true    false             
# reset_password_sent_at datetime(6)          true    false             
# remember_created_at    datetime(6)          true    false             
# role                   INTEGER              true    false   0         
# created_at             datetime(6)          false   false             
# updated_at             datetime(6)          false   false             
#
#------------------------------------------------------------------------------
