class UsersController < ApplicationController
  before_action :require_admin, only: [:new, :create, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def require_admin
    if !current_user.is_admin?
      render :prohibited, status: :forbidden
      return false
    end
    true
  end
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    require_admin if current_user.id != @user.id
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    require_admin if current_user.id != @user.id
  end

  def login
  end

  def authenticate
    user = User.find_by_name(params[:name].downcase)
    if (user and user.authenticate(params[:password]))
      session[:user_id] = user.id
      redirect_to root_url, notice: "Successfully logged in as #{user.name}"
    else
      flash[:notice] = "Login unsuccessful"
      render :login
    end
  end

  def logout
    session.delete(:user_id)
  end
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if current_user.id != @user.id
      require_admin or return
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.id == SUPER_ADMIN_ID
      redirect_to users_url, notice: 'Can\'t delete that user'
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      user = params.require(:user)
      if user and user[:name]
        user[:name].downcase!
      end
      if current_user.is_admin?
        return user.permit(:name, :password, :password_confirmation, :admin)
      else
        return user.permit(:password, :password_confirmation)
      end
    end
end
