class AuditLog < ApplicationRecord
  belongs_to :tenant
  belongs_to :api_key, optional: true
  belongs_to :user, optional: true

  validates :action, presence: true
  validates :resource_type, presence: true
  validates :record_hash, presence: true
  validates :sequence_number, presence: true, uniqueness: true

  before_validation :set_sequence_and_hash, on: :create

  scope :recent, -> { order(created_at: :desc) }
  scope :for_resource, ->(type, id) { where(resource_type: type, resource_id: id) }
  scope :by_actor, ->(type, id) { where(actor_type: type, actor_id: id) }

  # Immutable - prevent updates and deletes
  before_update { raise ActiveRecord::ReadOnlyRecord, "Audit logs are immutable" }
  before_destroy { raise ActiveRecord::ReadOnlyRecord, "Audit logs cannot be deleted" }

  class << self
    def log(tenant:, action:, resource:, actor: nil, api_key: nil, user: nil, changes: {}, metadata: {}, request: nil)
      create!(
        tenant: tenant,
        action: action,
        resource_type: resource.class.name,
        resource_id: resource.id,
        actor_type: determine_actor_type(actor, api_key, user),
        actor_id: determine_actor_id(actor, api_key, user),
        api_key: api_key,
        user: user,
        record_changes: changes,
        metadata: metadata,
        ip_address: request&.remote_ip,
        user_agent: request&.user_agent,
        request_id: request&.request_id
      )
    end

    def verify_chain(tenant_id: nil, start_seq: nil, end_seq: nil)
      scope = all
      scope = scope.where(tenant_id: tenant_id) if tenant_id
      scope = scope.where("sequence_number >= ?", start_seq) if start_seq
      scope = scope.where("sequence_number <= ?", end_seq) if end_seq

      logs = scope.order(:sequence_number).to_a
      return { valid: true, checked: 0 } if logs.empty?

      errors = []
      logs.each_with_index do |log, index|
        # Verify record hash
        expected_hash = log.compute_hash
        unless log.record_hash == expected_hash
          errors << { sequence: log.sequence_number, error: "Hash mismatch" }
        end

        # Verify chain link (skip first record)
        if index > 0
          prev_log = logs[index - 1]
          unless log.previous_hash == prev_log.record_hash
            errors << { sequence: log.sequence_number, error: "Chain broken" }
          end
        end
      end

      { valid: errors.empty?, checked: logs.size, errors: errors }
    end

    private

    def determine_actor_type(actor, api_key, user)
      return 'api_key' if api_key
      return 'user' if user
      return actor.class.name if actor
      'system'
    end

    def determine_actor_id(actor, api_key, user)
      return api_key&.id&.to_s if api_key
      return user&.id&.to_s if user
      actor&.id&.to_s
    end
  end

  def compute_hash
    # Core immutable data for chain integrity
    # Note: record_changes excluded as it may contain variable timestamps
    parts = [
      tenant_id.to_s,
      action.to_s,
      resource_type.to_s,
      resource_id.to_s,
      actor_type.to_s,
      actor_id.to_s,
      ip_address.to_s,
      previous_hash.to_s,
      sequence_number.to_s
    ]
    Digest::SHA256.hexdigest(parts.join('|'))
  end

  private

  def set_sequence_and_hash
    self.sequence_number = next_sequence_number
    self.previous_hash = last_hash
    self.created_at ||= Time.current  # Set before hash so it's included
    self.record_hash = compute_hash
  end

  def next_sequence_number
    (AuditLog.maximum(:sequence_number) || 0) + 1
  end

  def last_hash
    AuditLog.order(sequence_number: :desc).first&.record_hash
  end
end
