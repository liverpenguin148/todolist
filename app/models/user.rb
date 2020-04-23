class User < ApplicationRecord
  # remember_tokenという仮属性の作成
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
                    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6}
  
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    # ランダムな文字列の記憶トークンを生成
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
    
  # 記憶トークンをハッシュ化(remember_digest)し、DBに保存
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # DBの記憶ダイジェストを破棄
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # 渡されたremember_tokenと、DB内のremember_digestと一致したら、trueを返す
  def authenticate?(remember_token)
    Bcrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
