class User < ActiveRecord::Base
  has_secure_password

  SUPER_ADMIN_ID = 1

  def is_admin?
    admin or id == SUPER_ADMIN_ID
  end
end
