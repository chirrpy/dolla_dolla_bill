require 'sqlite3'
require 'active_record'
require 'dolla_dolla_bill'

Dir[File.expand_path('../support/**/*.rb',   __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.before(:all) do
    SQLite3::Database.new 'tmp/test.db'

    ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'tmp/test.db'
    )

    class SetupTests < ActiveRecord::Migration
      def up
        create_table :exotic_dancers do |t|
          t.integer :price_in_cents
          t.string  :price_currency
        end
      end
    end

    SetupTests.new.migrate(:up)
  end

  config.before(:each) do
    ActiveRecord::Base.connection.execute 'DELETE FROM exotic_dancers'
  end

  config.after(:all) do
    `rm -f ./tmp/test.db`
  end
end
