class ApiKey < ApplicationRecord
  belongs_to :tenant
  has_many :audit_logs

  validates :name, presence: true
  validates :key_digest, presence: true, uniqueness: true
  validates :prefix, presence: true

  scope :active, -> { where(active: true) }
  scope :not_expired, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }
  scope :valid, -> { active.not_expired }

  before_validation :generate_key, on: :create

  attr_accessor :raw_key

  def self.authenticate(raw_key)
    return nil if raw_key.blank?

    prefix = raw_key[0..7]
    key = find_by(prefix: prefix)
    return nil unless key&.active?
    return nil if key.expired?

    if key.key_matches?(raw_key)
      key.touch(:last_used_at)
      key.increment!(:request_count)
      key
    end
  end

  def key_matches?(raw_key)
    BCrypt::Password.new(key_digest).is_password?(raw_key)
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def rate_limited?
    return false if rate_limit.nil? || rate_limit.zero?

    # Simple hourly rate limit check
    recent_requests = audit_logs.where("created_at > ?", 1.hour.ago).count
    recent_requests >= rate_limit
  end

  def has_scope?(scope)
    scopes.include?(scope.to_s) || scopes.include?('*')
  end

  private

  def generate_key
    self.raw_key = SecureRandom.urlsafe_base64(32)
    self.prefix = raw_key[0..7]
    self.key_digest = BCrypt::Password.create(raw_key)
  end
end
