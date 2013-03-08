# Billcom

A gem for connecting to the bill.com API.

## Installation

Add this line to your application's Gemfile:

    gem 'billcom'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install billcom

## Usage

    require 'billcom'

    Create an options hash with account details:
    opt = {:user => "your_email@example.com", :password => "your_password", :org_id => "org id of your company", :api_key => "api key for your account" }
    Set the options on the module:
    Billcom.options opt
    Billcom.login
    Billcom.create_vendor(name, email, external_id)
    Billcom.send_vendor_invite(vendor_id, email)
    Billcom.create_bill(invoice_number, vendor_id, amount, chart_of_account_id, external_id, invoice_date, due_date)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
