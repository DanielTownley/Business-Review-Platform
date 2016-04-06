class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  
  def profile
    if (session[:user] == nil)
      flash[:notice] = "You are not logged in!"
      redirect_to(user_login_path)
    else
      p "profile"
      p session[:user]
      redirect_to(user_path(session[:user]["id"]))
    end
  end
  
  def show
    if(session[:user] != nil)
      #p params[:id]
      #p session[:user].inspect
      #p session[:user]["id"]
      if (params[:id].to_i == session[:user]["id"]) 
        @reviews = User.find(params[:id]).reviews
      else
        flash[:notice] = "You do not have access to #{User.find(params[:id]).name}'s page"
        redirect_to root_path
      end
    else
      flash[:notice] = "You are not logged in!"
      redirect_to user_login_path
    end
  end

  # GET /users/new
  def new
    #@user = User.new
  end

  # GET /users/1/edit
  def edit
  end
  
  def login
  end  


 def validate
   redirect_to users_path
 end   

  # POST /users
  # POST /users.json
  def create
    
    
    #p params
    #p params["user"]["email"] =~ /^.+$/
    #p params["user"]["confirm"].eql? params["user"]["password"]
    if params["user"]["email"] =~ /^.+$/ and 
      params["user"]["password"] =~ /^.+$/ and 
      params["user"]["confirm"].eql? params["user"]["password"]
      
      p "happy."
      @user = User.create! :email => params["user"]["email"],
        :password_hash => params["user"]["password"]
        
      #p ">>>user id #{@user.id}"
      session[:user] = @user
      redirect_to user_path(@user.id)
    else
      p "sad."
      flash[:warning] = "Please fill in all required fields."
      redirect_to new_user_path
    end
    
    
    #@user.update_attributes!(user_params)
    p @user
    #flash[:notice] = "#{@user.title} was successfully updated."
    #redirect_to movie_path(@user)
    #@user = User.create!(user_params)
    
    #p user_params
    #p @user
    #params[:id] = @user.id
    

    #respond_to do |format|
    #  if @user.save
    #    format.html { redirect_to @user, notice: 'User was successfully created.' }
    #    format.json { render :show, status: :created, location: @user }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @user.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
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
      params.require(:user).permit(:email, :password_hash, :password_salt)
    end
end
