require "dolla_dolla_bill/version"
require 'money'

module DollaDollaBill
  module ClassMethods
    def money(name, options = {})
      cents_field_reader     = options[:cents]    || :"#{name}_in_cents"
      currency_field_reader  = options[:currency] || :"#{name}_currency"
      cents_field_writer     = :"#{cents_field_reader}="
      currency_field_writer  = :"#{currency_field_reader}="

      define_method(name) do
        return nil if send(cents_field_reader).nil? || send(currency_field_reader).nil?

        ::Money.new(send(cents_field_reader), send(currency_field_reader))
      end

      define_method("#{name}=") do |value|
        if value.nil?
          cents_value    = nil
          currency_value = nil
        else
          value          = value.to_money
          cents_value    = value.cents
          currency_value = value.currency_as_string
        end

        send(cents_field_writer,    cents_value)
        send(currency_field_writer, currency_value)
      end

      self.class.send(:define_method, "lowest_#{name}") do
        select("#{cents_field_reader}, #{currency_field_reader}").
        order("#{cents_field_reader} ASC").
        first.
        price
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
