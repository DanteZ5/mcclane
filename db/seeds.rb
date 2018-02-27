# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "cleaning dB"
Event.destroy_all
Collaborator.destroy_all
User.destroy_all

puts "creating users"

users_attributes = [
{ email: 'rh@lewagon.org', password: 'Clane12', company: 'Le Wagon',
  photo: "https://i.pinimg.com/236x/a5/2c/5a/a52c5a6ff5bbc2b165e805ff30c424ad.jpg"},
{ email: 'rh@total.com', password: 'Clane12', company: 'Total',
photo: "http://www.creads.fr/blog/wp-content/uploads/2017/02/logo-total-2003.png"}]

users = User.create!(users_attributes)

puts "creating collaborators"

collaborators_attributes = [
{ email: 'nassim@gmail.com', phone_pro: '0610257263', first_name: "Nassim",
last_name: "Mezouar", country: "France", user_id: User.first.id},
{ email: 'dante@gmail.com', phone_pro: '0634264547', first_name: "Dante",
last_name: "Planterose", country: "Italie", user_id: User.first.id},
{ email: 'thibaud@gmail.com', phone_pro: '0786091509', first_name: "Thibaud",
last_name: "Vuitton", country: "France", user_id: User.first.id},
{ email: 'maximilien@gmail.com', phone_pro: '0681256797', first_name: "Maxmilien",
last_name: "Rufin", country: "France", user_id: User.first.id},
{ email: 'thomas@gmail.com', phone_pro: '0681257797', first_name: "Thomas",
last_name: "Sertorio", country: "France", user_id: User.last.id}
]

collaborators = Collaborator.create!(collaborators_attributes)

puts "creating events"

events_attributes = [
{ name: "Tsunami", user_id: User.first.id },
{ name: "Attaque HQ", end_date: "12/12/2017", user_id: User.first.id } ]

events = Event.create!(events_attributes)

puts "OK done!"

# colevents_attributes = [
# {

#   }]

# collabs = Collaborator.all
# collab.each do



