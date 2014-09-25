class PagesController < ApplicationController
  def show
    page = Page.find_by(slug: params[:slug])
    if page
      render :show, locals: { page: page }
    else
      render nothing: true, status: 404
    end
  end
end
