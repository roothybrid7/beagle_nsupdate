= BeagleNsupdate

Nsupdate Web console(DynamicDNS)

== Requirements

* Ruby v1.8.7
* Rails v3.x.x
* Mongodb v1.8.x

== Step

1. Set up:

    $ bundle install --path vendor/bundle
    $ cp db/seeds.rb.sample db/seeds.rb
    $ vim db/seeds.rb

    # db/seeds.rb
    def adduser(email, password)
      @user = User.invite!(:email => email) do |u|
        u.skip_invitation = true
      end
      User.accept_invitation!(:invitation_token => @user.invitation_token, :password => password, :password_confirmation => password)

      puts "Created User #{email} with password #{password}"
    end

    adduser("admin@example.com", "passwd")    # Add initial user

2. Add initial user
    $ rake db:seed

3. Modified environment settings

    # config/initializers/devise.rb
    [...]
    Devise.setup do |config|
      # ==> Mailer Configuration
      # Configure the e-mail address which will be shown in DeviseMailer.
      config.mailer_sender = "beagle-nsupdate@prod.example.com"         #<= modify the mail address

      # Configure the class responsible to send e-mails.
      # config.mailer = "Devise::Mailer"
    [...]

if development:

    # config/environments/development.rb
    [...]
    #config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default_url_options = {:host => 'dev-server:3000'}     #<= modify the app url
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true

if production:

    # config/environments/production.rb
    [...]
    #config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default_url_options = {:host => 'prod-server.prod.domain.com'}  #<= modify the app url
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true


4. Launch

    $ rails server
