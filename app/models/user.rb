class User < ApplicationRecord
  require 'zxcvbn'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable, :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.terms_of_service = '1'
      # 如果需要保存姓名：
      # user.full_name = auth.info.name
    end
  end

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  
  attr_accessor :terms_of_service
  validates :terms_of_service, acceptance: { allow_nil: false, on: :create }

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
