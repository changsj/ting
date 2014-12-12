  class SongsController < ApplicationController
  before_action :require_login, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :find_song, only: [ :edit, :update, :destroy ]

  def index
    @songs = Song.includes(:user).all.order("created_at desc")
  end

  def new
    @song = current_user.songs.build
  end

  def show
    @song = Song.find(params[:id])
  end
  
  def create
   @song = current_user.songs.build(song_params)
    if @song.save
      flash[:success] = "发布成功"
      redirect_to root_path
    else
      flash.now[:error] = "发布失败"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @song.update_attributes params.require(:song).permit(:content)
      flash[:success] = "更新成功"
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.js
      end
    end
  end

  def destroy
    current_user.songs.find(params[:id]).destroy
    flash[:success] = "删除成功"
    redirect_to root_path
  end

  private

  def song_params
    params.require(:song).permit(:s_id, :content)
  end

  def find_song
    @song = current_user.songs.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash[:warning] = "拒绝访问"
    redirect_to root_path
  end

end