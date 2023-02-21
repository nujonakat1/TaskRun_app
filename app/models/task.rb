class Task < ApplicationRecord
    validates :name, presence: true
    validates :name, length: { maximum: 30 }

    belongs_to :user

    scope :recent, -> { order(created_at: :desc)}

    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "description", "id", "name", "updated_at", "user_id"]
    end
end