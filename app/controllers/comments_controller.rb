class CommentsController < ApplicationController
	before_action :set_post, only: [:new, :create, :destroy]
	def new
		@comment = @post.comments.new
	end

	def create
		@comment = @post.comments.new(comment_params)
		if @comment.save
			render turbo_stream: turbo_stream.update("post_#{@post.id}_comments", partial: 'posts/post_comments', locals: { post: @post })
		end
	end

	def destroy
		@comment = @post.comments.find_by(id: params[:id])
		@comment.destroy
		render turbo_stream: turbo_stream.update("post_#{@post.id}_comments", partial: 'posts/post_comments', locals: { post: @post })
	end

	private

	def comment_params
		params.require(:comment).permit(:text)
	end	

	def set_post
		@post = Post.find_by(id: params[:post_id])
	end
end
