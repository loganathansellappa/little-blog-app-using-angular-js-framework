class CommentsController < ApplicationController
  before_filter :authorize,except: [:index,:show]
  before_filter :owner?,only: [:edit,:update]
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    
    respond_to do |format|
      if @comment
        format.html 
        format.json  { render nothing: true, status: :forbidden }
        format.js {render "create" }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render js: "alert('Comment not saved');" }
      end
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json #create.json.rabl
        format.js  #create.js.erb
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render js: "alert('Comment not saved');" }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
        format.js {render "create" }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
      format.js { render "create" }
    end
  end

  private
  def owner?
    @comment = Comment.find(params[:id])
    authorized = (current_user ? current_user.comments.include?(@comment) : false)
    unless authorized
      respond_to do |format|
        format.html { redirect_to root_url }
        format.any(:xml, :json) { render nothing: true, status: :forbidden }
      end
    end
  end
end
