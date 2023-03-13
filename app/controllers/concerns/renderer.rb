# frozen_string_literal: true

module Renderer
  def render_response(result, status)
    if result[:success]
      render(json: result, status:)
    else
      render json: result, status: :unprocessable_entity
    end
  end
end
