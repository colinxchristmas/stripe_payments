# stripe_payments

stripe_payments is a demo application written with a bit of help from [Pete Keen - Mastering Modern Payments](https://www.masteringmodernpayments.com/).
If you're new to Stripe and Ruby, do yourself a favor and spend the $59 for the basic text. I learned quite a bit and expanded what was missing from the core of the text to fit a few more options that I needed. I didn't implement all of the course but the basics to get going and learning. I plan on adding more from the course as time permits.

I've also looked through so many tutorials I can't keep track of where I learned what. So if you've ever written a tutorial on Stripe, JS, Rails Tests many thanks... seriously THANKS! Also a big thanks to a good friend who got me into Ruby and still answers the phone when I have questions.  

I had to teach myself enough JavaScript to setup the payment forms, so this is my first shot at writing JS for the 4 JS files. I'll be migrating many of the JS functions over to a separate file soon to DRY it up a bit on shared/duplicated functions.

## Dependencies/Versions

* Ruby version 2.3.1
* Rails version 5.0.3
* PostgreSQL 9.5.3
* Stripe Testing Account (https://stripe.com) [API Reference](https://stripe.com/docs/api)
* Recaptcha Account (https://www.google.com/recaptcha/intro/)
* gem 'bootstrap-sass', '~> 3.3.6'

#### Setup Locally
Clone Repo
```
git clone https://github.com/colinxchristmas/stripe_payments.git
```
Change dir into `stripe_payments`
```
cd stripe_payments
```
Install Gems
```
bundle install
```
Setup Database
```
rake db:create
rake db:migrate
```
Setup a `.env` file
`gem 'dotenv-rails', :require => 'dotenv/rails-now'` is currently in the `Gemfile` to manage your `.env` file but you may use whatever you prefer.
```
STRIPE_PRIVATE_KEY=''
STRIPE_PUBLIC_KEY=''
RECAPTCHA_SITE_KEY=''
RECAPTCHA_SECRET_KEY=''
```
**Recaptcha requires a domain input to authorize keys/local site*

Set domain when you setup Recaptcha to `localhost` and/or `127.0.0.1` and if you use `lvh.me` set that in there if needed. Sometimes you'll need to play around with them to get it working correctly but once they're working they're solid.

#### Testing
##### To Run Tests
###### Rails Tests

```
rails test
```
Should see a similar printout of what's covered. (controllers)
```
....................................
Finished in 6.172501s, 5.8323 runs/s, 5.1843 assertions/s.
36 runs, 32 assertions, 0 failures, 0 errors, 0 skips
```
###### RSpec Tests

```
rspec
```
Should see a similar printout of what's covered. (models)
```
...........................................

Finished in 2.58 seconds (files took 6.67 seconds to load)
43 examples, 0 failures
```
Testing coverage isn't 100% yet but I'm steadily adding to them. `Controllers` are in progress currently. Subscriptions is the next phase and I'll be adding to Transactions and Cards as well. Transactions is in `/test/functional/*` folder as it isn't in the normal flow of controllers. There is one passing test in there at the moment as I try to decide how to handle the rest of that controller. I will be periodically adding new testing branches and merging them in as they reach levels of completion.

Most of my projects in the past used `Rspec` and `Capybara` for front end testing. This project I tried my hand at **rails tests**. I dug into learning more `Factory Girl` and `after(:create)` callbacks which had tripped me up on projects in the past dealing with `has_many` and `belongs_to` relations. I never learned these types of tests in school, so I had to learn from online documentation, other people's projects and trial and error. There are probably plenty of faster, easier and more thorough methods that I need to learn and get more experience with.

I added `RSpec` in for Model validations and Model method validations. It seemed easier for me to validate the methods pertaining to each model with RSpec as opposed to assertion tests in Rails.

**Additional Items/Thoughts**

This project isn't all inclusive or complete yet. It has the `gem 'mailgun-ruby', '~>1.1.4'` but it isn't moved over from the other repo yet. I'm still on the fence on using that or another mail provider.

I haven't setup any background workers yet. I plan on adding that in the coming weeks as well.

This is not a full site as the roles are not configured, and there are not any front end back end differences. This is a simple payment app to illustrate what I've been working on.

**Gems**

Some additional Gems I can't live without are included as well. You may need to do some extra research to get them setup but they're priceless when it comes to working in `console`.
```
gem 'awesome_print'
gem 'hirb'
gem 'interactive_editor'
```
I use Devise quite a bit for user registration and management. I recommend if you're relatively new to check it out, as it can save a bit of time on integration. It helped me a lot having to read through everything to implement it.

`gem 'devise'`

## Now on to the nitty gritty
*Not really, it's just a basic walk through of the user flow*

**How it works:**
- Admin (roles are not setup yet) registers a new account and sets up `products`(single payment) and `plans` (recurring subscriptions).
- Regular User (can be same) registers and is assigned a `stripe_customer_id` after creation. This creates the customer id on Stripe and saves it to the `Users` model.
- User decides to purchase a product, adds card details, address and submits payment form. If user is not logged in it will require login then redirect back to product or plan.
- If first time purchasing through app, new card is set as `default` with Stripe and saved as default in the `cards` model.
- If user has 2 cards on file the `default` card can be switched by updating the `non-default` card in the `/users/cards` view. Or by adding a `new` card and selecting *default* at checkout.
- New cards added for Transactions are allowed to be single payment cards, saved for single future payments, or set to default for subscription payments.
- Subscriptions are handled in a similar manner however, whatever card is used, either a new card or an old card will be set to `default` regardless. Stripe requires one card always as default for recurring billing so I set the priority on Transactions and Subscriptions to default to Subscriptions.
**I added this feature after using a company's app and it creates a new customer on every Stripe charge. I noticed I waste too much time trying to track down purchases because I may have as many as 5 or 6 customers in my Stripe account for a single customer, with 1 card but rarely 2 cards. Being able to manage a single customer in the Stripe account with multiple cards is a huge time saver for me.*
- Recurring billing is setup on another private repository and I'll migrate it over here when I setup `stripe-events`.
