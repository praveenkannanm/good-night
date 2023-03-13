# frozen_string_literal: true

module Users
  class Unfollow < ApplicationService
    def initialize(user, unfollow_id)
      @user = user
      @unfollow_id = unfollow_id
    end

    def call
      unfollow
    end

    private

    attr_reader :user, :unfollow_id

    def unfollow
      unfollow_user = user.followers.find_by_id(unfollow_id)
      return { success: false, error: 'Could not find user.' } unless unfollow_user.present?

      follow = user.following_users.find_by(follower_id: unfollow_user.id)
      unfollowed = follow.destroy

      return { success: false, error: 'error in unfollow the user' } unless unfollowed

      { success: true, data: follow }
    end
  end
end
