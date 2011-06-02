# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
def adduser(email, password)
  @user = User.invite!(:email => email) do |u|
    u.skip_invitation = true
  end
  User.accept_invitation!(:invitation_token => @user.invitation_token, :password => password, :password_confirmation => password)

  puts "Created User #{email} with password #{password}"
end

adduser("admin@example.com", "1qaz2wsx")
