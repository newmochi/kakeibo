# kakeibo
kakeibo Ruby on Rails application.

kakeibo means Household account book.

The message of this application is written by Japanese.
(a part of Japanese messages are contained in source script code.)

## Ruby version
ruby 2.2.0p0 (2014-12-25 revision 49005) [x86_64-linux]
Rails 4.2.0

## System dependencies
not run on Windows,because of a part of library gem files.

## Configuration
bundle install

## Database creation
rake db:migrate

## Database initialization

## How to run the test suite
sorry.no test code.

## Services (job queues, cache servers, search engines, etc.)
only Ruby on Rails application used.
in development mode,please type this.
`rails s -b 0.0.0.0`
(used port number 3003)

## Deployment instructions
If you want to modify Kind(in Japanese called shubetu),please add and delete items.

### expense

`kakeibo/config/initializers/my_config/exp1disp.yml`

### income

`kakeibo/config/initializers/my_config/inc1disp.yml`

### saving

`kakeibo/config/initializers/my_config/sav1disp.yml`
