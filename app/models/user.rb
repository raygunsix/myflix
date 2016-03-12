class User < ActiveRecord::Base
  validates :email, :password, :full_name, presence: true
  validates :email, uniqueness: true

  has_secure_password

  has_many :queue_items, -> { order 'position' }

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

end
