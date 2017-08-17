class SubmissionReviewerInvitationPolicy < ApplicationPolicy

    def can_decline?
        record.user==user && record.may_sm_decline? #&& !record.inv_expired?
    end
    def can_accept?
        record.user==user && record.may_sm_accept? #&& !record.inv_expired?
    end

private


end
