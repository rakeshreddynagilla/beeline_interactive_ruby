class FinancialSummary
  attr_accessor :user,:currency,:period

  def initialize(user,currency,period='all')
    @user = user
    @currency = currency
    @period = period
  end

  class << self
    def one_day(user:, currency:)
      new(user,currency,'one_day')
    end

    def seven_days(user:, currency:)
      new(user,currency,'seven_days')
    end

    def lifetime(user:, currency:)
      new(user,currency)
    end
  end

  def transactions(category)
    @transactions ||= @user.transactions.send(@period)
                                        .send(@currency)
                                        .send(category.pluralize)
  end

  def count(category)
    transactions(category.to_s).count
  end

  def amount(category)
    transactions(category.to_s).map(&:amount).sum
  end
end
