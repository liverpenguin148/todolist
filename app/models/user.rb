class User < ApplicationRecord
  # マイクロポストのリレーション
  has_many :microposts, dependent: :destroy
  # Default: class_name: "Micropost"
  # Default: foreign_key: "user_id"

  # フォローしているユーザーをRelationshisテーブルから取得
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  # フォロワーをRelationshipsテーブルから取得
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy                                  
  # フォローしているユーザーをusersテーブルから取得                                
  has_many :following, through: :active_relationships, source: :followed
  # フォロワーをusersテーブルから取得
  has_many :followers, through: :passive_relationships, source: :follower
  
  # 仮属性の作成(対応するモデルがないため)
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
                    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true
  
  # クラスメソッドの定義
  class << self
    # 渡された文字列をハッシュ化
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
  
  # インスタンスメソッドの定義
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
  # 引数は属性と、token
  # 渡された属性をもとに、DBからdigestを取得し、tokenと一致したら、true
  def authenticate?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーを有効化する
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # 有効化メールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  # パスワード再設定用メールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の有効期限が切れている場合、trueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # 試作feedの定義(完全な実装は次章)
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end
  # ユーザーのフォロー解除をする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  # フォローしている場合、trueを返す。
  def following?(other_user)
    following.include?(other_user)
  end
  
  private
    def downcase_email
      self.email = email.downcase
    end
    
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
