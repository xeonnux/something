class CommentsController < ApplicationController
  before_action :set_comment, only: %i[like dislike]

  def create
    @article = Article.find(params[:article_id])
    @new_comment = Comment.new(comment_params)
    @new_comment.article = @article
    @new_comment.user = current_user
    respond_to do |format|
      if @new_comment.save
        format.html { redirect_to article_path(@article) }
        format.json # Follows the classic Rails flow and look for a create.json view
      else
        format.html { render "comments/new", status: :unprocessable_entity }
        format.json # Follows the classic Rails flow and look for a create.json view
      end
    end
    # if @new_comment.save
    #   redirect_to article_path(@article)
    # else
    #   render 'new'
    # end
  end

  # def update
  #   @comment = Comment.find(params[:comment_id])
  #   # if @comment.update(comment_params)
  #     # redirect_back(fallback_location: root_path, notice: 'Listing was successfully updated.')
  #   # else
  #     # render :edit
  #   # end
  # end

  def like
    @comment.add_like
    redirect_to article_path(@comment.article), notice: "Comment liked"
  end

  def dislike
    @comment.add_dislike
    redirect_to article_path(@comment.article), notice: "Comment disliked"
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
