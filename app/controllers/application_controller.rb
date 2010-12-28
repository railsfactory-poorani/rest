class ApplicationController < ActionController::Base
  protect_from_forgery



def call_function
if current_user==""
@msg="Please login"
redirect_to :controller=> 'session', :action=> 'new'
else
return 1
end
end

end

