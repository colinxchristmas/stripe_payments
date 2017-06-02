class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, password_length: 8..128

  has_many :sales
  has_many :products, through: :sales
  has_paper_trail

  def username
    [first_name, last_name].join (' ')
  end
end
