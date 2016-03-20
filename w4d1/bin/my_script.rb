# bin/my_script.rb

require 'addressable/uri'
require 'rest-client'

#route parameters

# url = Addressable::URI.new(
#   scheme: 'http',
#   host: 'localhost',
#   port: 3000,
#   path: '/users/:id',
# ).to_s
#
# puts RestClient.get(url)

#query string

# url = Addressable::URI.new(
#   scheme: 'http',
#   host: 'localhost',
#   port: 3000,
#   path: '/users.html?key=value',
# ).to_s
#
# puts RestClient.get(url)
#
#post

# url = Addressable::URI.new(
#   scheme: 'http',
#   host: 'localhost',
#   port: 3000,
#   path: '/users',
# ).to_s
#
# puts RestClient.post(url, "body" => "the body text goes here")


#nesting parameters with 'get'

# url = Addressable::URI.new(
#   scheme: 'http',
#   host: 'localhost',
#   port: 3000,
#   path: '/users/5.json',
#   query_values: {
#     'some_category[a_key]' => 'another value',
#     'some_category[a_second_key]' => 'yet another value',
#     'some_category[inner_inner_hash][key]' => 'value',
#     'something_else' => 'aaahhhhh'
#   }
# ).to_s
#
# puts RestClient.get(url)

#nesting parameters with 'post'
# url = Addressable::URI.new(
#   scheme: 'http',
#   host: 'localhost',
#   port: 3000,
#   path: '/users'
# ).to_s
#
# puts RestClient.post(url, 'id'=> 5,
#      'some_category[a_key]' => 'another value',
#      'some_category[a_second_key]' => 'yet another value',
#      'some_category[inner_inner_hash][key]' => 'value',
#      'something_else' => 'aaahhhhh')
#

#pass user id through params

# url = Addressable::URI.new(
#   scheme: 'http',
#   host: 'localhost',
#   port: 3000,
#   path: '/users/1'
# ).to_s
#
# puts RestClient.get(url)

#
# def create_user
#   url = Addressable::URI.new(
#     scheme: 'http',
#     host: 'localhost',
#     port: 3000,
#     path: '/users.json'
#   ).to_s
#
#   begin
#     puts RestClient.post(
#       url,
#       { user: { name: "Gizmo"} }
#     )
#   rescue RestClient::UnprocessableEntity
#     puts "Error raised with RestClient"
#   end
# end
#
# create_user


#
# def update_user
#   url = Addressable::URI.new(
#     scheme: 'http',
#     host: 'localhost',
#     port: 3000,
#     path: '/users/4.json',
#     query_values: {name: "Fluffy", email: "fluffy@puffy.edu"}
#   ).to_s
#
#   begin
#     puts RestClient.patch(url)
#
#   rescue RestClient::UnprocessableEntity
#     puts "Error raised with RestClient"
#   end
# end
#
# update_user

def destroy_user
  url = Addressable::URI.new(
      scheme: 'http',
      host: 'localhost',
      port: 3000,
      path: '/users/4.json'
    ).to_s

  puts RestClient.destroy(url)

end

destroy_user
