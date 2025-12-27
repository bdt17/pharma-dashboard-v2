# frozen_string_literal: true

# Phase 13: Tenant model with Stripe integration
# Auto-creates Stripe customer on tenant creation

class Tenant < ApplicationRecord
  # ═══════════════════════════════════════════════════════════════════════════
  # ASSOCIATIONS
  # ═══════════════════════════════════════════════════════════════════════════
  has_many :users, dependent: :destroy
  has_many :api_keys, dependent: :destroy
  has_many :shipments, dependent: :destroy
  has_many :temperature_events, dependent: :destroy
  has_many :geofence_events, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :audit_logs, dependent: :destroy

  # ═══════════════════════════════════════════════════════════════════════════
  # CALLBACKS
  # ═══════════════════════════════════════════════════════════════════════════
  before_create :create_stripe_customer

  # ═══════════════════════════════════════════════════════════════════════════
  # VALIDATIONS
  # ═══════════════════════════════════════════════════════════════════════════
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9-]+\z/, message: "only lowercase letters, numbers, and hyphens" }
  validates :stripe_customer_id, uniqueness: true, allow_nil: true
  validates :stripe_subscription_id, uniqueness: true, allow_nil: true

  # ═══════════════════════════════════════════════════════════════════════════
  # SCOPES
  # ═══════════════════════════════════════════════════════════════════════════
  scope :active, -> { where(status: "active") }
  scope :trialing, -> { where(status: "trialing") }
  scope :canceled, -> { where(status: "canceled") }

  # ═══════════════════════════════════════════════════════════════════════════
  # PLANS
  # ═══════════════════════════════════════════════════════════════════════════
  PLANS = {
    "free" => { trucks: 5, api_calls: 1_000, price_id: nil },
    "smb" => { trucks: 25, api_calls: 50_000, price_id: "price_smb" },
    "enterprise" => { trucks: 200, api_calls: 500_000, price_id: "price_enterprise" },
    "pfizer" => { trucks: Float::INFINITY, api_calls: Float::INFINITY, price_id: "price_pfizer" }
  }.freeze

  # ═══════════════════════════════════════════════════════════════════════════
  # STATUS METHODS
  # ═══════════════════════════════════════════════════════════════════════════
  def active?
    status == "active"
  end

  def trialing?
    status == "trialing"
  end

  def canceled?
    status == "canceled"
  end

  # ═══════════════════════════════════════════════════════════════════════════
  # STRIPE: AUTO-CREATE CUSTOMER
  # ═══════════════════════════════════════════════════════════════════════════
  def create_stripe_customer
    return if stripe_customer_id.present?

    customer = Stripe::Customer.create(
      name: name,
      email: billing_email,
      metadata: {
        tenant_id: id || "pending",
        subdomain: subdomain
      }
    )

    self.stripe_customer_id = customer.id
    Rails.logger.info "[Stripe] Created customer #{customer.id} for tenant #{subdomain}"
  rescue Stripe::StripeError => e
    Rails.logger.error "[Stripe] Failed to create customer: #{e.message}"
    # Don't block tenant creation if Stripe fails
    nil
  end

  # ═══════════════════════════════════════════════════════════════════════════
  # STRIPE: SET PLAN (UPDATE SUBSCRIPTION)
  # ═══════════════════════════════════════════════════════════════════════════
  def set_plan(plan_name)
    plan_config = PLANS[plan_name]
    raise ArgumentError, "Invalid plan: #{plan_name}" unless plan_config

    # If downgrading to free, cancel subscription
    if plan_name == "free"
      cancel_subscription!
      update!(plan: "free", status: "active")
      return true
    end

    price_id = plan_config[:price_id]
    raise ArgumentError, "No price_id for plan: #{plan_name}" unless price_id

    if stripe_subscription_id.present?
      # Update existing subscription
      subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
      Stripe::Subscription.update(
        stripe_subscription_id,
        items: [{
          id: subscription.items.data.first.id,
          price: price_id
        }],
        proration_behavior: "create_prorations"
      )
    else
      # Create new subscription
      ensure_stripe_customer!
      subscription = Stripe::Subscription.create(
        customer: stripe_customer_id,
        items: [{ price: price_id }],
        metadata: { tenant_id: id }
      )
      self.stripe_subscription_id = subscription.id
    end

    update!(plan: plan_name, status: "active")
    Rails.logger.info "[Stripe] Set plan to #{plan_name} for tenant #{id}"
    true
  rescue Stripe::StripeError => e
    Rails.logger.error "[Stripe] Failed to set plan: #{e.message}"
    errors.add(:base, "Failed to update subscription: #{e.message}")
    false
  end

  # ═══════════════════════════════════════════════════════════════════════════
  # STRIPE HELPERS
  # ═══════════════════════════════════════════════════════════════════════════
  def ensure_stripe_customer!
    return stripe_customer_id if stripe_customer_id.present?

    customer = Stripe::Customer.create(
      name: name,
      email: billing_email,
      metadata: { tenant_id: id, subdomain: subdomain }
    )

    update!(stripe_customer_id: customer.id)
    customer.id
  end

  def cancel_subscription!
    return unless stripe_subscription_id.present?

    Stripe::Subscription.cancel(stripe_subscription_id)
    update!(stripe_subscription_id: nil)
    Rails.logger.info "[Stripe] Canceled subscription for tenant #{id}"
  rescue Stripe::StripeError => e
    Rails.logger.error "[Stripe] Failed to cancel subscription: #{e.message}"
  end

  def create_checkout_session(plan_name:, success_url:, cancel_url:)
    plan_config = PLANS[plan_name]
    raise ArgumentError, "Invalid plan: #{plan_name}" unless plan_config
    raise ArgumentError, "No price_id for plan: #{plan_name}" unless plan_config[:price_id]

    ensure_stripe_customer!

    Stripe::Checkout::Session.create(
      customer: stripe_customer_id,
      mode: "subscription",
      line_items: [{ price: plan_config[:price_id], quantity: 1 }],
      success_url: success_url,
      cancel_url: cancel_url,
      metadata: { tenant_id: id },
      client_reference_id: id.to_s
    )
  end

  def billing_portal_url(return_url:)
    return nil unless stripe_customer_id.present?

    session = Stripe::BillingPortal::Session.create(
      customer: stripe_customer_id,
      return_url: return_url
    )
    session.url
  end

  # ═══════════════════════════════════════════════════════════════════════════
  # PLAN LIMITS
  # ═══════════════════════════════════════════════════════════════════════════
  def plan_config
    PLANS[plan] || PLANS["free"]
  end

  def truck_limit
    plan_config[:trucks]
  end

  def api_call_limit
    plan_config[:api_calls]
  end

  def within_truck_limit?
    return true if truck_limit == Float::INFINITY
    shipments.where(status: "in_transit").count < truck_limit
  end

  def usage_stats
    {
      plan: plan,
      status: status,
      trucks_active: shipments.where(status: "in_transit").count,
      trucks_limit: truck_limit == Float::INFINITY ? "unlimited" : truck_limit,
      stripe_customer_id: stripe_customer_id,
      stripe_subscription_id: stripe_subscription_id
    }
  end
end
