class StaticPagesController < ApplicationController
  caches_action :about, :terms, :privacy

  def help
    @page_title = 'Help'
  end

  def about
   @page_title = 'About'
   @contact = Contact.new
  end

  def terms
   @page_title = 'Terms'
  end

  def privacy
   @page_title = 'Privacy'
  end
end
