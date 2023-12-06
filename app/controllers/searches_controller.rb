class SearchesController < ApplicationController
  def show
    scope = params[:scope].constantize unless params[:scope] == 'All'

    @result = ThinkingSphinx.search(params[:search], classes: [scope])
  end
end
