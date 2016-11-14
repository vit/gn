# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



Journal.delete_all
Journal.create([{
    id: 1,
    title: 'Журнал "Гироскопия и Навигация"',
    description: 'Журнал "Гироскопия и Навигация" более длинное описание',
    slug: 'gn',
    user_id: 1
}])

Submission.delete_all
Submission.create([{
    id: 1,
    title: 'My paper 1 w qwer qwej wekjr lqweih qwhtqwri tuhqwoirt uqweoir uhqweri qweri uhqweori uhqweori qwehr oiqweur hqowieru hqwoeiru hqweriu qweh',
    abstract: 'My paper 1 abstract ejwr qweurh qweru hqoweru hqwoeri uqhweori uqhwero iquwehro iqwuerh qwieurh qoweiruqhweoriuqwhero iqwuehr oqweriuh qoweiru hqweoiru hqweori uqwheroiu qwheroiuqwehr wiqeurh qweiruh qweoriuqhweri uhweroi uqwheriuqweriuhewri uqewriu qhewr',
    user_id: 1,
    journal_id: 1,
    revision_seq: 1,
    last_created_revision_id: 1,
    last_submitted_revision_id: false,
    aasm_state: 'draft'
}, {
    id: 2,
    title: 'My paper 2 w qwer qwej wekjr lqweih qwhtqwri tuhqwoirt uqweoir uhqweri qweri uhqweori uhqweori qwehr oiqweur hqowieru hqwoeiru hqweriu qweh',
    abstract: 'My paper 2 abstract ejwr qweurh qweru hqoweru hqwoeri uqhweori uqhwero iquwehro iqwuerh qwieurh qoweiruqhweoriuqwhero iqwuehr oqweriuh qoweiru hqweoiru hqweori uqwheroiu qwheroiuqwehr wiqeurh qweiruh qweoriuqhweri uhweroi uqwheriuqweriuhewri uqewriu qhewr',
    user_id: 1,
    journal_id: 1,
    revision_seq: 1,
    last_created_revision_id: 2,
    last_submitted_revision_id: false,
    aasm_state: 'draft'
}, {
    id: 3,
    title: 'My paper 3 w qwer qwej wekjr lqweih qwhtqwri tuhqwoirt uqweoir uhqweri qweri uhqweori uhqweori qwehr oiqweur hqowieru hqwoeiru hqweriu qweh',
    abstract: 'My paper 3 abstract ejwr qweurh qweru hqoweru hqwoeri uqhweori uqhwero iquwehro iqwuerh qwieurh qoweiruqhweoriuqwhero iqwuehr oqweriuh qoweiru hqweoiru hqweori uqwheroiu qwheroiuqwehr wiqeurh qweiruh qweoriuqhweri uhweroi uqwheriuqweriuhewri uqewriu qhewr',
    user_id: 1,
    journal_id: 1,
    revision_seq: 1,
    last_created_revision_id: 3,
    last_submitted_revision_id: false,
    aasm_state: 'draft'
}, {
    id: 4,
    title: 'My paper 4 w qwer qwej wekjr lqweih qwhtqwri tuhqwoirt uqweoir uhqweri qweri uhqweori uhqweori qwehr oiqweur hqowieru hqwoeiru hqweriu qweh',
    abstract: 'My paper 4 abstract ejwr qweurh qweru hqoweru hqwoeri uqhweori uqhwero iquwehro iqwuerh qwieurh qoweiruqhweoriuqwhero iqwuehr oqweriuh qoweiru hqweoiru hqweori uqwheroiu qwheroiuqwehr wiqeurh qweiruh qweoriuqhweri uhweroi uqwheriuqweriuhewri uqewriu qhewr',
    user_id: 1,
    journal_id: 1,
    revision_seq: 1,
    last_created_revision_id: 4,
    last_submitted_revision_id: false,
    aasm_state: 'draft'
}, {
    id: 5,
    title: 'My paper 5 w qwer qwej wekjr lqweih qwhtqwri tuhqwoirt uqweoir uhqweri qweri uhqweori uhqweori qwehr oiqweur hqowieru hqwoeiru hqweriu qweh',
    abstract: 'My paper 5 abstract ejwr qweurh qweru hqoweru hqwoeri uqhweori uqhwero iquwehro iqwuerh qwieurh qoweiruqhweoriuqwhero iqwuehr oqweriuh qoweiru hqweoiru hqweori uqwheroiu qwheroiuqwehr wiqeurh qweiruh qweoriuqhweri uhweroi uqwheriuqweriuhewri uqewriu qhewr',
    user_id: 1,
    journal_id: 1,
    revision_seq: 1,
    last_created_revision_id: 5,
    last_submitted_revision_id: false,
    aasm_state: 'draft'
}, {
    id: 6,
    title: 'My paper 6 w qwer qwej wekjr lqweih qwhtqwri tuhqwoirt uqweoir uhqweri qweri uhqweori uhqweori qwehr oiqweur hqowieru hqwoeiru hqweriu qweh',
    abstract: 'My paper 6 abstract ejwr qweurh qweru hqoweru hqwoeri uqhweori uqhwero iquwehro iqwuerh qwieurh qoweiruqhweoriuqwhero iqwuehr oqweriuh qoweiru hqweoiru hqweori uqwheroiu qwheroiuqwehr wiqeurh qweiruh qweoriuqhweri uhweroi uqwheriuqweriuhewri uqewriu qhewr',
    user_id: 1,
    journal_id: 1,
    revision_seq: 1,
    last_created_revision_id: 6,
    last_submitted_revision_id: false,
    aasm_state: 'draft'
}])

SubmissionRevision.delete_all
SubmissionRevision.create([{
    submission_id: 1,
    revision_n: 1,
    aasm_state: 'draft'
}, {
    submission_id: 2,
    revision_n: 1,
    aasm_state: 'draft'
}, {
    submission_id: 3,
    revision_n: 1,
    aasm_state: 'draft'
}, {
    submission_id: 4,
    revision_n: 1,
    aasm_state: 'draft'
}, {
    submission_id: 5,
    revision_n: 1,
    aasm_state: 'draft'
}, {
    submission_id: 6,
    revision_n: 1,
    aasm_state: 'draft'
}]);



