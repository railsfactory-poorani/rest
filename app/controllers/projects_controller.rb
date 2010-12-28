
class ProjectsController < ApplicationController
	layout 'index'
	#@t= ApplicationController.new
	#before_filter :call_function, :except => [:new, :create,:home,:contact,:about,:photo]
  def new
	  # @q=params[:id]
	#@logname=@q
	   #@q=params[:id]
	  @empid=User.all
	 @eid=[]
	 for i in 0...@empid.length
		@eid<<@empid[i].id
	 end
	 @proemp=ProjectUser.all
	 @a=[]
	 @proemp.each {|t| @a<<t.id}
	  
	  #for i in 0...l do
	#	@a<<@proemp[i].user_id
	#end
	#puts @a
	#puts @eid
  @b=[]
	  for i in 0...@eid.length
		  c=0
		  for j in 0...@a.length
			if @eid[i]==@a[j]
				c=c+1;
			end		
		   end
		  if c< 2
			 @b<<@eid[i]
		 end
		
		 
	  end
	@b
	@a=[]
	for o in 0...@b.length
		@a<<User.find(@b[o])
	end

render :layout => "pm"
	  
  end

  def create
	  
	  @p=params[:data]
	@pro=Project.new
	@l=Project.last
	@lid=@l.id
	@lid=@lid+1
	@pro.id=@lid
	@pro.project_name=@p["project_name"]
	@pro.client=@p["client"]
	#@current=self.current_user
	#@name=current_user
	@name=$current.name
	@pro.project_manager_name=@name
	@logname=@p["project_manager_name"]
	unless @pro.save
	@msg="failed to create new project"
	end
	@em=@p["resource"]
	@empname=@em.split(",")
	@lp=ProjectUser.last
	@lp=@lp.id+1
	
	for j in 0...@empname.length
		@proemp=ProjectUser.new
		@proemp.id=@lp
		@proemp.project_id=@lid
		@id=User.find_by_name(@empname[j])
		@id=@id.id
		@proemp.user_id=@id
		@proemp.save
		@lp=@lp+1
	end  
	#@msg="Successfully new project is created"
	 redirect_to :id=> @logname, :action => "show"
	  
  end
  
  def show
  @pro=Project.all
	#@proemp=ProjectEmployee.all
	render :layout => "pm"
  end
  def Resource
@name=params[:id1]
@logname=@name	
#@pid=params[:data]
@pid=params[:id]
@pro=Project.find(@pid)
@proemployee=@pro.Users
render :layout => "pm"
#~ redirect_to :action=>"show"
end
def show1
	#@name=params[:id]
	#@logname=@name
	@emp=User.all
	render :layout => "pm"
end
  def contact
	  
  end
  def about
	  
  end
  def photo
	  
  end
  def home
	  
  end
end
