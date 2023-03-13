# frozen_string_literal: true

class FollowsController < ApplicationController
  def create
    result = Users::Follow.call(current_user, params[:follow_id])
    render_response(result, :created)
  end

  def destroy
    result = Users::Unfollow.call(current_user, params[:id])
    render_response(result, :no_content)
  end
end
