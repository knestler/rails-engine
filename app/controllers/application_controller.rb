class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

private
  def render_404
    render json: {"Error": "Record not found"}, status: 404
  end
end
