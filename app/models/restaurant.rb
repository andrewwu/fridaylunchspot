# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address1   :string(255)
#  address2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Restaurant < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :name, :phone, :state, :zip,
                  :approved

  validates :name, presence: true, length: { maximum: 255 }
  validates :address1, presence: true, length: { maximum: 255 }
  validates :address2, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 255 }
  validates :state, presence: true, length: { maximum: 255 }
  validates :zip, presence: true, length: { maximum: 255 }
  validates :phone, presence: true, length: { maximum: 255 }
end
