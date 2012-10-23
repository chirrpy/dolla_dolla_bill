require 'spec_helper'

class ExoticDancer < ActiveRecord::Base
  include DollaDollaBill

  money :price
end

describe DollaDollaBill do
  describe '#price' do
    let(:money) do
      ExoticDancer.new(
        price_in_cents: cents,
        price_currency: currency)
    end

    context 'when the money components are set' do
      let(:cents)     { 1234  }
      let(:currency)  { 'USD' }

      it 'creates the proper Money object' do
        money.price.cents.should              eql 1234
        money.price.currency_as_string.should eql 'USD'
      end
    end

    context 'when only the currency is set' do
      let(:cents)     { nil   }
      let(:currency)  { 'USD' }

      it 'creates the proper Money object' do
        money.price.should be_nil
      end
    end

    context 'when only the cents are set' do
      let(:cents)     { 1234 }
      let(:currency)  { nil  }

      it 'creates the proper Money object' do
        money.price.should be_nil
      end
    end
  end

  describe '#price=' do
    let(:money) { ExoticDancer.new }

    context 'when set to a Money object' do
      before { money.price = Money.new(5432, 'USD') }

      it 'sets the attributes to the correct values' do
        money.price_in_cents.should eql 5432
        money.price_currency.should eql 'USD'
      end
    end

    context 'when set to a string' do
      before { money.price = '54.32' }

      it 'sets the attributes to the correct values' do
        money.price_in_cents.should eql 5432
        money.price_currency.should eql 'USD'
      end
    end

    context 'when set to a decimal' do
      before { money.price = 54.32 }

      it 'sets the attributes to the correct values' do
        money.price_in_cents.should eql 5432
        money.price_currency.should eql 'USD'
      end
    end

    context 'when set to nil' do
      before { money.price = nil }

      it 'sets the attributes to nil' do
        money.price_in_cents.should be_nil
        money.price_currency.should be_nil
      end
    end
  end

  describe '.lowest_money' do
    context 'when there are no items' do
      before { ExoticDancer.count.should be_zero }

      it 'is nil' do
        ExoticDancer.lowest_price.should be_nil
      end
    end

    context 'when there are two items with different amounts' do
      let!(:higher_money) { ExoticDancer.create( price_in_cents: 5433,
                                                 price_currency: 'GBP') }

      let!(:lower_money)  { ExoticDancer.create( price_in_cents: 5432,
                                                 price_currency: 'GBP') }

      it 'is the lower amount' do
        ExoticDancer.lowest_price.should eql Money.new(5432, 'GBP')
      end
    end

    context 'when there are two items with the same amounts' do
      let!(:money_1) { ExoticDancer.create( price_in_cents: 5432,
                                            price_currency: 'GBP') }

      let!(:money_2) { ExoticDancer.create( price_in_cents: 5432,
                                            price_currency: 'GBP') }

      it 'is the correct amount' do
        ExoticDancer.lowest_price.should eql Money.new(5432, 'GBP')
      end
    end
  end
end
