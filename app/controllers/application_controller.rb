class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :scope_current_tenant

  def scope_current_tenant(&block)
  	current_tenant.scope_schema("public", &block)
  end

  helper_method :current_tenant

  def current_tenant
  	@current_tenant ||= Tenant.find_by_domain(params['domain'])
  	if @current_tenant.nil? and params['domain'].nil?
  		@current_tenant = Tenant.first_or_create({domain: Tenant.connection.current_database})
  	end
  	@current_tenant
  end
end
