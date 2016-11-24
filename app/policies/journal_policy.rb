#class JournalPolicy < ContextPolicy
#end

class JournalPolicy < ApplicationPolicy
    def is_owner?
        record.owner?(user)
    end
    def can_admin?
        is_owner? || can_role?(:chief_editor)
    end
    def can_author?
        true
    end
    def can_editor?
#        true
        can_role? :editor
    end
    def can_chief_editor?
        can_role? :chief_editor
    end
    def can_reviewer?
        true
    end

private

    def can_role? role
        false || record.user_roles(user).include?(role)
    end

end
