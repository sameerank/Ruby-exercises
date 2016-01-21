# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


10.times do
  User.create(user_name: Faker::Name.name)
end

10.times do
  rando_user = User.all.select(:id).sample
  Poll.create(user_id: rando_user.id, title: Faker::Hipster.word)
end

10.times do
  rando_poll = Poll.all.select(:id).sample
  Question.create(poll_id: rando_poll.id, question_text: Faker::Hipster.sentence[0..-2] + "?")
end

Question.all.select(:id).each do |question_id|
  4.times do
    AnswerChoice.create(question_id: question_id.id, answer_choice: Faker::Hipster.word)
  end
end

User.all.select(:id).each do |user|
  Question.all.select(:id).each do |question|
    answer = AnswerChoice.where(question_id: question.id).select(:id).sample
    Response.create(user_id: user.id, answer_choice_id: answer.id)
  end
end
