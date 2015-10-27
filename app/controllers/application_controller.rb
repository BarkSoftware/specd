class ApplicationController < ActionController::Base
  layout false

  def index
    @title = "Spec'd"
  end
end
