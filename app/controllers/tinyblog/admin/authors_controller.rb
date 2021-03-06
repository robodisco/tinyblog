require_dependency "tinyblog/application_controller"

module Tinyblog
  module Admin
    class AuthorsController < BaseController
      
      respond_to :html
      
      def index
        @authors = Author.all
        respond_with @authors
      end

      def new
        @author = Author.new
      end

      def create
        @author = Author.new(author_params)
        if @author.save
          flash[:success] = t('tinyblog.authors.created')
        else
          flash[:warning] = t('tinyblog.authors.not_created')
        end

        respond_with @author, :location => admin_authors_path
      end

      def edit
        @author = Author.find(params[:id])
      end

      def update
        @author = Author.find(params[:id])
        if @author.update_attributes(author_params)
          flash[:notice] = t('tinyblog.authors.updated')
        else
          flash[:warning] = t('tinyblog.authors.not_updated')
        end

        respond_with @author, :location => admin_authors_path
      end

      def destroy
      end

      protected

        def author_params
          params.require(:author).permit(:first_name, :last_name, :bio, :twitter, :facebook, :gplus)
        end
    end
  end
end
