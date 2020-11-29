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



    def roles_for_journal(journal)
        self.appointments.where(journal_id: journal.id)
    end

=begin
    def self.list_with_roles(journal, args = {})
		found = User.select("users.*", "journal_appointments.role_name"). #select("teams_users.team_id IS NOT NULL AS member FROM teams").
    		joins("LEFT OUTER JOIN journal_appointments on users.id=journal_appointments.user_id and journal_appointments.journal_id = #{journal.id.to_i}") #.
		#where(account_id: account.id)

        result = []
        current = nil
        found.each do |u|
            unless current && current['id']==u.id
                current = u.as_json
                current['full_name'] = u.full_name
                current['roles'] = []
                result << current
            end
            current['roles'] << u.role_name if u.role_name
        end

        result
    end
=end

    # =========== FOR DISABLED ACCOUNTS ===========

    def active_for_authentication?
      super && !disabled
    end
    
    def inactive_message
      !disabled ? super : :the_user_account_is_blocked
    end




end
