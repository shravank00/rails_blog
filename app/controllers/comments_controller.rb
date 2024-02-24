class CommentsController < ApplicationController
	before_action :set_post, only: [:create, :destroy]

	def create
		@comment = @post.comments.build(comment_params)
		if @comment.save
			redirect_to root_path
		end
	end

	def destroy
		@comment = @post.comments.find_by(id: params[:id])
		@comment.destroy
		render turbo_stream: turbo_stream.remove("comment_#{@comment.id}")
	end

	private

	def comment_params
		params.require(:comment).permit(:text)
	end	

	def set_post
		@post = Post.find_by(id: params[:post_id])
	end
end
