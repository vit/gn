
User.delete_all

u1 = User.create!({
    email: 'dt@example.com',
    fname: 'D',
    lname: 'T',
	country: 'ru',
    password: '123456',
    password_confirmation: '123456'
})

u2 = User.create!({
    email: 'vs@example.com',
    fname: 'V',
    lname: 'S',
	country: 'ru',
    password: '123456',
    password_confirmation: '123456'
})

u3 = User.create!({
    email: 'rv1@example.com',
    fname: 'rv1',
    lname: 'rv1',
	country: 'ru',
    password: '123456',
    password_confirmation: '123456'
})

u4 = User.create!({
    email: 'rv2@example.com',
    fname: 'rv2',
    lname: 'rv2',
	country: 'ru',
    password: '123456',
    password_confirmation: '123456'
})

u5 = User.create!({
    email: 'a1@example.com',
    fname: 'a1',
    lname: 'a1',
	country: 'ru',
    password: '123456',
    password_confirmation: '123456'
})

u6 = User.create!({
    email: 'a2@example.com',
    fname: 'a2',
    lname: 'a2',
	country: 'ru',
    password: '123456',
    password_confirmation: '123456'
})

Journal.delete_all
j1 = Journal.create!({
    title: 'Журнал "Гироскопия и Навигация"',
    description: 'Журнал "Гироскопия и Навигация", более длинное описание',
    slug: 'gn',
    user: u1
})

Submission.delete_all
SubmissionRevision.delete_all
SubmissionText.delete_all
SubmissionRevisionDecision.delete_all

JournalAppointment.delete_all

j1.appointments.create!({user: u1, role_name: 'chief_editor'})
j1.appointments.create!({user: u1, role_name: 'editor'})
j1.appointments.create!({user: u1, role_name: 'reviewer'})

j1.appointments.create!({user: u2, role_name: 'chief_editor'})
j1.appointments.create!({user: u2, role_name: 'editor'})
j1.appointments.create!({user: u2, role_name: 'reviewer'})

j1.appointments.create!({user: u3, role_name: 'reviewer'})
j1.appointments.create!({user: u4, role_name: 'reviewer'})



