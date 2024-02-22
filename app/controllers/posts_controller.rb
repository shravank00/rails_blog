class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	def index
		@posts = Post.all
	end

	def new
		@post = Post.new()
	end

	def show; end

	def create
		@post = Post.new(post_params)
		if @post.save
			redirect_to root_path
		else
			render :new, status: unprocessable_entity
		end
	end

	def edit
		respond_to do |format|
			format.html
			format.turbo_stream { render turbo_stream: turbo_stream.replace("post_#{@post.id}_edit", partial: 'edit_post_form') }
		end
	end

	def update
		if @post.update(post_params)
			redirect_to @post
		else
			render :edit, status: :unprocessable_entity
		end
	end
	
	def destroy
		@post.destroy
		redirect_to root_path
	end

	private

	def set_post
		@post = Post.find(params[:id])
	end

	def post_params
		params.require(:post).permit(:title, :description)
	end
end
