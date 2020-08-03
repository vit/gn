class User < ApplicationRecord

  has_many :journals
  has_many :submissions
  has_many :appointments, class_name: 'JournalAppointment', dependent: :destroy


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable


#    mount_uploader :avatar, AvatarUploader
#    acts_as_followable
#    acts_as_follower

    validates :fname, presence: true
    validates :lname, presence: true
    validates :country, presence: true

    def full_name
#        "#{fname} #{mname} #{lname}".strip # <#{email}>"
        "#{lname} #{fname} #{mname}".strip # <#{email}>"
    end

    def country_name
        country = ISO3166::Country[self.country] rescue nil
        country ? country.translations[I18n.locale.to_s] || country.name : '-'
    end


    # CREATE VIRTUAL TABLE users_fts USING fts4(full_name);
    # insert into users_fts (docid, full_name) values (123, 'user name');
#    def self.find_fts search
#        User.find_by_sql ["SELECT docid, full_name FROM users_fts WHERE full_name MATCH ?", search]
#    end


    before_save do |u|
        u.search = u.lname.mb_chars.downcase.to_s
    end




    # =========== FOR DISABLED ACCOUNTS ===========

    def active_for_authentication?
      super && !disabled
    end
    
    def inactive_message
      !disabled ? super : :the_user_account_is_blocked
    end




end
