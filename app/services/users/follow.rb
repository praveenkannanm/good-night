# frozen_string_literal: true

module Users
  class Follow < ApplicationService
    def initialize(user, follow_id)
      @user = user
      @follow_id = follow_id
    end

    def call
      follow
    end

    private

    attr_reader :user, :follow_id

    def follow
      follow_user = User.where.not(id: user.id).find_by_id(follow_id)
      return { success: false, error: 'Could not find user.' } unless follow_user.present?

      follow = user.following_users.create(follower_id: follow_user.id)

      return { success: false, error: 'already following the user' } unless follow.valid?

      { success: true, data: follow }
    end
  end
end
