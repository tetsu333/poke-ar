class User < ApplicationRecord
  has_secure_password

  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, format: { with: /\A[\w+-.]+@[a-z\d-]+(.[a-z\d-]+)*.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, format: { with: /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i, message: "は半角英数を両方含む必要があります" }

  private
    def downcase_email
      self.email = email.downcase
    end
end
