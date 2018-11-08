class ContactsController < ApplicationController
    before_action :require_admin, only: [:index]

    def new
      @contact = Contact.new
      @page_title = 'New Message'
    end

    def create
        @contact = Contact.create(contact_params)
        if user_signed_in?
            @contact.user_id = current_user.id
            if @contact.name.blank?
                @contact.name = current_user.name
            end
            if @contact.email.blank?
                @contact.email = current_user.email
            end
        end
        # Save the contact
        if @contact.save
            flash[:notice] = "Email Sent"
            # Not yet
            # MessageMailer.new_message(@contact).deliver_now
        else
            flash[:alert] = "Email not sent"
        end
        if user_signed_in?
            redirect_to user_path(current_user.id)
        else
            redirect_to unauthenticated_root_path
        end
    end
    def index
       @page_title = 'Comments'
        @contacts = Contact.all.order(created_at: :desc)
    end
    private

    def contact_params
        params.require(:contact).permit(:name, :email, :message)
    end
end
