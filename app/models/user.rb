class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Associations
  has_one :profile, dependent: :destroy

  # Callbacks
  after_create :create_profile

  # Use custom mailer for sending emails
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def devise_mailer
    Users::UserMailer
  end

  def create_profile
    # Extract username from email (before @)
    username = email.split('@').first.downcase
    # Ensure uniqueness by appending random suffix if needed
    username = "#{username}#{rand(1000..9999)}" if Profile.exists?(username: username)
    Profile.create!(user: self, username: username)
  end

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :password_confirmation, presence: true, on: :create
end
