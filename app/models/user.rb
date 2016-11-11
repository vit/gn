class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


#    mount_uploader :avatar, AvatarUploader
#    acts_as_followable
#    acts_as_follower

    validates :fname, presence: true
    validates :lname, presence: true

    def full_name
        "#{fname} #{mname} #{lname}".strip # <#{email}>"
    end



end
