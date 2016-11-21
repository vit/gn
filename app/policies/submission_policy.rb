class SubmissionPolicy < ApplicationPolicy
    def is_owner?
        record.owner?(user)
    end
#    def update?
#        is_owner? && record.may_sm_update?
#    end
#    def update_text?
#        is_owner? && record.may_sm_update_text?
#    end
    def update?
        update_file? || update_metadata?
    end
    def update_file?
        is_owner? && record.may_sm_update_file?
    end
    def update_metadata?
        is_owner? && record.may_sm_update_metadata?
    end
    def submit?
        is_owner? && record.may_sm_submit?
    end
    def revise?
        is_owner? && record.may_sm_revise?
    end
    def destroy?
        is_owner? && record.may_sm_destroy?
    end

#    def can_editor?
#        true
##        can_role? :editor
#    end


    def show?
        is_owner?
    end

#    def is_owner?
#        record.owner?(user)
#    end
#    def can_admin?
#        is_owner? || can_role?(:chief_editor)
#    end
#    def can_author?
#        is_owner?
#    end

#    def can_chief_editor?
#        can_role? :chief_editor
#    end

private

#    def can_role? role
#        false || record.user_roles(user).include?(role)
#    end

end
