require 'bundler'
require 'open-uri'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'app'
ActiveRecord::Base.logger = nil
