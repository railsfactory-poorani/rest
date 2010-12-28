class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
 
require 'authenticated_system.rb'
include AuthenticatedSystem
  layout 'index'
before_filter :call_function, :except => [:new, :create]
#before_filter :authenticate, :except => [:index, :show]

  # render new.rhtml
  def new
    @user = User.new
    render :layout=> 'admin'
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.designation=params[:user][:designation]
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/users/show', :notice => "Thanks for signing up!  We're sending you an email with your activation code.")
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      redirect_to '/login', :notice => "Signup complete! Please sign in to continue."
    when params[:activation_code].blank?
      redirect_back_or_default('/', :flash => { :error => "The activation code was missing.  Please follow the URL from your email." })
    else 
      redirect_back_or_default('/', :flash => { :error  => "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in." })
    end
  end
  
  def show
	  # @current=self.current_user
	  @emp=User.all
	render :layout=>'admin'
  
  end
  
  def edit
	    @id=params[:id]
	    @emp=User.find(@id)
	    render :layout=>'admin'
	  
  end

  def update
	logout_keeping_session!
	@id=params[:user][:id]
    @user = User.find_by_id(@id)
    #puts "*********************************"
   # puts @user.inspect
      @user.name=params[:user][:name]
       @user.login=params[:user][:login]
          @user.email=params[:user][:email]
    @user.designation=params[:user][:designation]
    success = @user && @user.save
    if success 
	redirect_to :action => 'show'
   #else
    #  flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
    #  render :action => 'edit'
    end
	
end

 def delete
	  @id=params[:id]
	   @emp=User.new
	@emp=User.find(@id)
	
	@a=ProjectUser.find_all_by_user_id(@id)
	for i in 0...@a.count
		@a[i].delete
	end
	
	if @emp.delete
		@msg="Employee detail deleted"
		  redirect_to :action=>'show'
		#redirect_to :action => "destroy"
	else
		@msg="Employee detail not deleted"
		  render :layout=>'admin'
		#render :action => "destroy"
	end
  end
  def user_profile
	#@name=params[:id]
	#@logname=@name
	@name=current_user.name
		
	@empprofile=User.find_by_name(@name)
	
	 render :layout=> 'user'
end
def project_profile
	#@name=params[:id]
	#puts @name
	#@logname=@name
	@name=current_user.name
	@t=User.find_by_name(@name)
	
	
	#puts @t.inspect
       @projects=@t.Projects
       render :layout=> 'user'
    #   if @projects.nil? 
	#	@msg="Currently No Projects"
	#	render :action=>"project_profile"

	#end

  end
  def logout
	  current_user=""
	  redirect_to :controller=> 'projects', :action=>'home'
  end
  
  

end
