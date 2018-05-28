class Transaction < ApplicationRecord
  monetize :amount_cents

  validate :must_be_greater_than_zero
  validates :category, inclusion: %w[deposit refund withdraw]

  belongs_to :user

  scope :deposits,  -> { where(category: 'deposit') }
  scope :refunds,  -> { where(category: 'refund') }
  scope :withdrawls,  -> { where(category: 'withdrawl') }

  #If too many currencies, add a loop to generate scopes?
  scope :usd, -> {where(amount_currency: 'USD')}
  scope :cad, -> {where(amount_currency: 'CAD')}

  scope :one_day, -> {where("created_at >= ?", 1.day.ago)}
  scope :seven_days, -> {where("created_at >= ?", 7.day.ago)}

  after_save :make_immutable
  after_find :make_immutable

  private

  def must_be_greater_than_zero
    errors.add(:amount, 'Must be greater than 0') if amount <= Money.from_amount(0, amount_currency)
  end

  def make_immutable
    self.readonly!
  end
end
