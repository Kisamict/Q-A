class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  # has_many :access_grants,
  #          class_name: 'Doorkeeper::AccessGrant',
  #          foreign_key: :resource_owner_id,
  #          dependent: :delete_all # or :destroy if you need callbacks
  # has_many :access_tokens,
  #          class_name: 'Doorkeeper::AccessToken',
  #          foreign_key: :resource_owner_id,
  #          dependent: :delete_all # or :destroy if you need callbacks

  def author_of?(resource)
    id == resource.user_id
  end

  def self.find_for_auth(auth)
    provider = auth['provider']
    uid = auth['uid']
    email = auth['info']['email']

    authorization = Authorization.find_by(uid: uid, provider: provider)
    return authorization.user if authorization

    if email
      user = User.find_or_create_by(email: email) do |user|
        user.email = email
        user.password = SecureRandom.hex(8)
      end

      user.send_confirmation_instructions unless user.confirmed? 

      user.authorizations.create(uid: uid, provider: provider)
      
      user
    end
  end
end
