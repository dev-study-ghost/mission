class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]

  #POST /posts/:id/like
  def like
    if @post = Post.find(params[:id]) # 1. 먼저 Post모델을 가져옵니다.
      if (@like = LikePost.where(user_id: current_user.id, post_id: @post.id).first).blank? # 2. 그다음 지금 해당 request를 보낸 User이 좋아요가 되어있는지 검색.
        @like = LikePost.new(user_id: current_user.id, post_id: @post.id) # 이 행으로 진입했다는건 현재 User이 현재 Post를 좋아요 한적이 없기때문에 LikePost에 객체를 생성하므로써 좋아요! 추가

        if @like.save
          redirect_to @post
        else
          redirect_to @post
        end
      else
        @like.destroy # 2번에서 여기에 진입했다면 이미 좋아요가 되어있는 상태로 좋아요가 되어있는 상태에서 또 요청한거라면 사용자는 '좋아요취소'를 클릭한것이므로 destroy해줘서 LikePost에서 제거해줍니다.
        redirect_to @post
      end
    else
      redirect_to posts_url
    end
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = Comment.new # post/1에 접근할때 하단에 comments/form을 render해야하므로 추가해주었습니다.
    @comments = @post.comments
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        @post.update_attribute :user_id, current_user.id
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :contents)
    end
end
