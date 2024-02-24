class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	def index
		@posts = Post.all
		@comment = Comment.new
	end

	def new
		@post = Post.new()
	end

	def show; end

	def create
		@post = Post.new(post_params)
		if @post.save
			flash[:notice] = 'Post created successfully!!'
		else
			flash[:alert] = @post.errors.full_messages.join(', ')
		end
		redirect_to root_path
	end

	def edit
		respond_to do |format|
			format.html
			format.turbo_stream { render turbo_stream: turbo_stream.update("post_#{@post.id}_edit", partial: 'edit_post_form') }
		end
	end

	def update
		if @post.update(post_params)
			respond_to do |format|
				format.html
				format.turbo_stream { render turbo_stream: turbo_stream.replace("post_#{@post.id}_edit", partial: 'post_detail', locals: { post: @post }) }
			end
		else
			render turbo_stream: turbo_stream.update("post_#{@post.id}_edit", partial: 'edit_post_form')
		end
	end
	
	def destroy
		@post.destroy
		render turbo_stream: turbo_stream.remove("post_#{@post.id}_edit")
	end

	private

	def set_post
		@post = Post.find(params[:id])
	end

	def post_params
		params.require(:post).permit(:title, :description)
	end
end
