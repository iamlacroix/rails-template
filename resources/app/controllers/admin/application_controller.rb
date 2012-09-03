class Admin::ApplicationController < InheritedResources::Base
	protect_from_forgery

	helper :application
end
