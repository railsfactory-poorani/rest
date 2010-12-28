# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
 require 'authenticated_system.rb'
 include AuthenticatedSystem

layout 'index'
before_filter :call_function, :except => [:new, :create]

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
 #   puts "*************************"
 #   puts user.inspect
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      $current=self.current_user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      @log=params[:login]
      @des=User.find_by_login(@log)
      @des=@des.designation
   
		if @log=='admin'
			render  :layout => "admin", :notice=> "Logged in successfully"
			#redirect_back_or_default('/signup', :notice => "Logged in successfully")
			#render  :layout => "pm"
			
		else if @des=='Project Manager'
			
			render  :layout => "pm", :notice=> "Logged in successfully"
			#redirect_back_or_default('/',  :notice => "Logged in successfully")
		else if 
			render  :layout => "user", :notice=> "Logged in successfully"
			#redirect_back_or_default('/users', :notice => "Logged in successfully")
		end
		end
		end
    else 
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/', :notice => "You have been logged out.")
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
