class User < ApplicationRecord
  require 'zxcvbn'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable, :timeoutable

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy

  validate :password_complexity

  private

  def password_complexity
    return if password.blank?

    tester = ::Zxcvbn::Tester.new
    result = tester.test(password, [email, "sinowermarket"])
    if result.score < 3
      errors.add :password, "强度太弱。请尝试添加数字、符号或大写字母，并避免使用常见词汇。"
    end
  end
end
