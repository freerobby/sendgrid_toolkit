SendgridToolkit
===============

[![Build Status](https://secure.travis-ci.org/freerobby/sendgrid_toolkit.svg)](http://travis-ci.org/freerobby/sendgrid_toolkit)

SendgridToolkit is a Ruby wrapper for the SendGrid Web API

Supported Modules
-----------------

SendgridToolkit provides a class for interacting with each of the following SendGrid API modules:

  - Bounces
  - InvalidEmails
  - Lists
  - ListEmails
  - Mail
  - SpamReports
  - Statistics
  - Unsubscribes

Consuming the SendGrid API is as simple as instantiating a class and making the call:
```ruby
unsubscribes = SendgridToolkit::Unsubscribes.new("username", "api_key")
unsubscribes.add :email => "email@to.unsubscribe"
```
Two lines, and voila!

Common actions are documented below under each module. For more details, visit the [SendGrid Web API Documentation][2]

Contributing
------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Big thanks to [James Brennan][1] for refactoring old code and writing the Bounces, InvalidEmails and SpamReports modules.

Install
-----------------

Via rubygems.org:
```bash
$ gem install sendgrid_toolkit
```
Or add it to your `Gemfile`
```ruby
gem 'sendgrid_toolkit', '>= 1.1.1'
```
Setting your API credentials globally
-------------------------------------

Setting your API user and key once globally for all API access:
```ruby
SendgridToolkit.api_user = "bob"
SendgridToolkit.api_key = "x123y"
```
If you do this when you create individual API objects you will not need to pass the `api_user` or `api_key`
```ruby
bounces = SendgridToolkit::Bounces.new
```
Bounces Module
--------------
The bounces module provides access to all of your bounces.

- - -

Instantiate the Bounces object:
```ruby
bounces = SendgridToolkit::Bounces.new(api_user, api_key)
```
- - -

Retrieve bounces:
```ruby
all_bounces = bounces.retrieve
```
`all_bounces` will be an array of hashes, each of which contains the following keys:

  - `email`: the recipient's email address
  - `status`: the status of email
  - `reason`: the reason for the bounce, as specified by the recipient's email server

- - -

Get the timestamp of each bounce:
```ruby
all_bounces = bounces.retrieve_with_timestamps
```
Each hash in `all_bounces` will now contain a `created` key, which holds a Ruby Time object.

- - -

If you believe an email address will no longer bounce and would like SendGrid to deliver future emails to that address, you may delete the Bounce entry:
```ruby
bounces.delete :email => "email@address.of.bounce.to.delete"
```
InvalidEmails Module
--------------------

The InvalidEmails module provides access to all of your email addresses.

- - -

Instantiate the InvalidEmails object:
```ruby
invalid_emails_obj = SendgridToolkit::InvalidEmails.new(api_user, api_key)
```
- - -

Retrieve invalid emails:
```ruby
invalid_emails = invalid_emails_obj.retrieve
```
`invalid_emails` will be an array of hashes, each of which contains the following keys:

  - `email`: the recipient's email address
  - `reason`: the reason the email address is believed to be invalid

- - -

Get the timestamp that each email was determined to be invalid:
```ruby
invalid_emails = invalid_emails_obj.retrieve_with_timestamps
```
Each hash in `invalid_emails` will now contain a `created` key, which holds a Ruby Time object.

- - -

If you believe a once-invalid email address is now valid and would like SendGrid to deliver future emails to that address, you may delete the InvalidEmail entry:
```ruby
invalid_emails.delete :email => "email@address.of.invalid.to.delete"
```
Lists Module
------------

The Lists module lets you manage your recipient lists associated with the marketing email feature via the marketing emails API.

- - -

Instantiate the Lists object:
```ruby
lists_obj = SendgridToolkit::Lists.new(api_user, api_key)
```
- - -

Retrieve lists:
```ruby
lists = lists_obj.get
```
`lists` will be an array of hashes, each of which contains a `list` key, which contain the name of the lists.

- - -

Create list:
```ruby
response = lists_obj.add :list => 'new_list_name'
```
`response` will be a hash containing a `message` key, which contains either `success` or `error`. If it is error, it will additionally contain the `errors` key, which contains an array of error messages.

When creating a list you can also specify a custom column name for the `name` associated with email addresses.

Example:
```ruby
response = lists_obj.add :list => 'new_list_name', :name => 'customer_name'
```

- - -

Edit list:
```ruby
response = lists_obj.edit :list => 'some_old_name', :new_list => 'some_new_name'
```
`response` will be a hash containing a `message` key, which contains either `success` or `error`. If it is error, it will additionally contain the `errors` key, which contains an array of error messages.

- - -

Delete list:
```ruby
response = lists_obj.delete :list => 'some_list_name'
```
`response` will be a hash containing a `message` key, which contains either `success` or `error`. If it is error, it will additionally contain the `errors` key, which contains an array of error messages.


ListEmails Module
-----------------

The ListEmails module lets you manage your emails in your recipient lists associated with the marketing email feature via the marketing emails API.

- - -

Instantiate the ListEmails object:
```ruby
list_emails_obj = SendgridToolkit::ListEmails.new(api_user, api_key)
```
- - -

Get emails:
```ruby
list_emails = list_emails_obj.get :list => 'some_list_name'
```
`list_emails` will be an array of hashes, each of which contains the following keys:

  - `email`: The email address of the recipient
  - `name`: The name of the recipient. This key may be different if you changed the column name

- - -

Add email:
```ruby
response = list_emails_obj.add :list => 'some_list_name', :data => { :email => 'some_new_email@example.com', :name => 'some_new_person'}
```

Add multiple emails:

This is limited to 1,000 entries by the API

```ruby
response = list_emails_obj.add :list => 'some_list_name', :data => [
  { :email => 'some_new_email1@example.com', :name => 'some_new_person1'},
  { :email => 'some_new_email2@example.com', :name => 'some_new_person2'},
  { :email => 'some_new_email3@example.com', :name => 'some_new_person3'}
]
```

`response` will be a hash containing a `inserted` key, which contains the number of emails inserted into the list.

- - -

Remove email:
```ruby
response = list_emails_obj.delete :list => 'some_list_name', :email => 'some_email@example.com'
```
`response` will be a hash containing a `removed` key, which contains the number of emails removed from the list.


Mail Module
-----------

The Mail module lets you send email via the web API.

- - -

Call `:send_mail` (chosen to avoid conflicts with Object:send) with the standard parameters:
```ruby
SendgridToolkit::Mail.new(api_user, api_key).send_mail :to => "user@domain.com", :from => "recipient@domain.com", :subject => "Some Subject", :text => "Some text"
```
The complete set of "x-smtpapi" options are also supported. You can use them like:
```ruby
SendgridToolkit::Mail.new(api_user, api_key).send_mail :to => "user@domain.com", :from => "recipient@domain.com", :subject => "Some Subject", :text => "Some text", "x-smtpapi" => {:category => "Retention"}
```
SpamReports Module
------------------

The SpamReports module provides access to all email addresses that have reported you for spam.

- - -

Instantiate the SpamReports object:
```ruby
spam_reports_obj = SendgridToolkit::SpamReports.new(api_user, api_key)
```
- - -

Retrieve spam reports:
```ruby
spam_reports = spam_reports_obj.retrieve
```
`spam_reports` will be an array of hashes, each of which contains an `email` key, indicating the email address that reported you for spam.

- - -

Get the timestamp of each spam report:
```ruby
spam_reports = spam_reports_obj.retrieve_with_timestamps
```
Each hash in `spam_reports` will now contain a `created` key, which holds a Ruby Time object.

- - -

If you believe a user will no longer consider your content to be spam, you may delete the SpamReport entry:
```ruby
spam_reports.delete :email => "email@address.that.called.you.a.spammer"
```
Statistics Module
-----------------
The statistics module provides access to all of your email statistics.

- - -

Instantiate the Statistics object:
```ruby
statistics = SendgridToolkit::Statistics.new(api_user, api_key)
```
- - -

Retrieve statistics:
```ruby
stats = statistics.retrieve
```
`stats` will be an array of hashes, each of which contains the following keys:

  - `date`: The date to which the statistics in this hash refer to
  - `requests`: The number of emails you requested be sent
  - `delivered`: The number of emails delivered to email servers
  - `bounces`: The number of emails which were rejected by email servers
  - `repeat_bounces`: The number of emails which bounced repeatedly
  - `blocked`: The number of emails which were [suppressed][4] by SendGrid
  - `spam_drop`: The number of emails which SendGrid dropped as spam
  - `clicks`: The number of clicks on links in your emails
  - `unique_clicks`: The number of users who clicked on a link in your email
  - `opens`: The number of users who opened your email
  -  `unique_opens`: The number of users who opened your email
  - `spamreports`: The number of users who have reported your emails as spam
  - `unsubscribes`: The number of unsubscribes your messages have received (if you are using the [subscription tracking app][3]
  - `repeat_unsubscribes`: The number of repeat unsubscribes (if a user unsubscribed, resubscribed and then unsubscribed again)
  - `bounces`: The number of emails that bounced

- - -

To narrow your retrieval to the past 5 days:
```ruby
stats = statistics.retrieve :days => 5
```
To narrow your retrieval to emails within the last month but before one week ago:
```ruby
stats = statistics.retrieve :start_date => 1.month.ago, :end_date => 1.week.ago
```
To narrow your search to a particular category (applicable only if you use this SendGrid feature):
```ruby
stats = statistics.retrieve :category => "NameOfYourCategory"
```
Note: You may combine a category query with other options, i.e.:
```ruby
stats = statistics.retrieve :category => "NameOfYourCategory", :days => 5
```
- - -

Receive your all-time statistics:
```ruby
stats = statistics.retrieve_aggregate
```
`stats` will be a single hash containing all of the aforementioned keys except `date`.

- - -

If you use SendGrid's category feature, you can list your categories:
```ruby
cats = statistics.list_categories
```
`cats` is an array of hashes, each of which has a `category` key that holds the name of a category.

Unsubscribes Module
-------------------
The unsubscribes module manages your list of unsubscribed email addresses.

- - -

Instantiate the Unsubscribes object:
```ruby
unsubscribes = SendgridToolkit::Unsubscribes.new(api_user, api_key)
```
- - -

List everybody who has unsubscribed from your emails with:
```ruby
listing = unsubscribes.retrieve
```
`listing` will be an array of hashes, each of which has an `email` key.

- - -

Get the timestamp when each user unsubscribed:
```ruby
listing = unsubscribes.retrieve_with_timestamps
```
Each hash in `listing` will now contain a `created` key, which holds a Ruby Time object.

- - -

Unsubscribe a user from your SendGrid email:
```ruby
unsubscribes.add :email => "email@to.unsubscribe"
```
SendgridToolkit will throw `UnsubscribeEmailAlreadyExists` if the email you specified is already on the list

- - -

Remove a user from your unsubscribe list:
```ruby
unsubscribes.delete :email => "email@that_is.unsubscribed"
```
SendgridToolkit will throw `UnsubscribeEmailDoesNotExist` if the email you specified is not on the list


A note about authentication
---------------------------

Each class is initialized with `api_user` and `api_key` parameters. `api_user` is your SendGrid account email address, and `api_key` is your SendGrid password.

If you don't supply `api_user` or `api_key`, SendgridToolkit will look for the `SMTP_USERNAME` or `SMTP_PASSWORD` environment variables. If they are not found, SendgridToolkit will throw `NoAPIKeySpecified` or `NoAPIUserSpecified`, depending on what you omitted.

If authentication fails during an API request, SendgridToolkit throws `AuthenticationFailed`.


In Case You're Curious...
-------------------------

API requests are made and responses are received in JSON. All requests are made as POSTs unless noted otherwise (some of SendGrid's examples are via GET, but they support POST)

Each class takes a final options parameter in the form of a hash. You may use this parameter to pass additional options to the SendGrid API. For example, let's say you are using the unsubscribes function:
```ruby
unsubscribes = SendgridToolkit::Unsubscribes.new(api_user, api_key)
listing = unsubscribes.retrieve
```
If SendGrid were to add a `only_verified` option to this API call, you could call:
```ruby
listing = unsubscribes.retrieve :only_verified => true
```
to make use of it.

Testing
-------

In addition to unit tests, SendgridToolkit comes with a limited suite of "webconnect" tests that will actually hit SendGrid's servers and perform various actions for purposes of real-world testing. In order to use these tests, you must:

  1. Create a test account with SendGrid and store the credentials in `TEST_SMTP_USERNAME` and `TEST_SMTP_PASSWORD` environment variables. This is so that actions are performed on a test account and not your real SendGrid account. If you forget, don't worry -- the tests will fail but they will **not** fall back on the account that uses `SMTP_USERNAME` and `SMTP_PASSWORD`.
  2. Change "xit" it "it" on the tests you wish to run.

Running "spec spec" out of the box will run the standard suite of tests (all network access is stubbed out).

[1]: http://github.com/jamesBrennan
[2]: http://sendgrid.com/docs/API_Reference/Web_API/
[3]: http://sendgrid.com/docs/Apps/subscription_tracking.html
[4]: https://sendgrid.zendesk.com/hc/en-us/articles/200181728-My-emails-are-being-dropped-
