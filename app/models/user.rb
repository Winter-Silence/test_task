# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  has_many :news

  devise :database_authenticatable, :registerable, :validatable
  include DeviseTokenAuth::Concerns::User
end
