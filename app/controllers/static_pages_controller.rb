class StaticPagesController < ApplicationController
  def home
    @page_title = 'Home'
  end

  def help
    @page_title = 'Help'
  end

  def about
   @page_title = 'About'
  end

  def terms
   @page_title = 'Terms'
  end

  def privacy
   @page_title = 'Privacy'
  end
end
