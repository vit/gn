class SubmissionPolicy < ApplicationPolicy
    def is_owner?
        record.owner?(user)
    end
    def can_write_review?
        record.user_invitation(user).accepted? && record.last_submitted_revision.under_consideration? &&
        !(record.last_submitted_revision.user_review(user) && record.last_submitted_revision.user_review(user).submitted?)
        rescue false
    end
    def can_process?
        record.user_invitation(user) && !record.user_invitation(user).inactive? || Pundit.policy(user,record.journal).can_editor? rescue false
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
#        is_owner? && record.may_sm_destroy?
        is_owner? && record.draft?
    end

    def write_review?
        is_owner? && record.may_sm_revise?
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
