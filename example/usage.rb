class UsersController < ApplicationRecord
  def index
    @users = User.cursor(since: params[:since],
                         till: params[:till],
                         sort_at: :recorded_at,
                         sort_order: :desc)
  end
end
