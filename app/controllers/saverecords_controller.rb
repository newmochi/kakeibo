class SaverecordsController < ApplicationController
  before_action :set_saverecord, only: [:show, :edit, :update, :destroy]
  before_action :set_sv, only: [:new, :show, :edit, :update, :destroy]
  # GET /saverecords
  # GET /saverecords.json
  def index
#    @saverecords = Saverecord.all
#    @saverecords = Saverecord.all
#    @saverecords.group!(:saving_id) # 確かにsaving_idごとに1行となった。しかも
                                    # idが最後のものが残るので、偶然にもその貯蓄
                                    # の中で最新のものがリストアップされ、実はOK
    @saverecord = Search::Saverecord.new
  end

  def search
    @saverecord = Search::Saverecord.new(search_params)
    @saverecords = @saverecord.matches.order(srnowdate: :desc).page(params[:page])
#      .decorate
  end

  def export_csv
    @saverecords =Saverecord.all.order(srnowdate: :asc, saving_id: :asc)
    send_data @saverecords.to_csv(header: 
    ['確認日', '貯蓄ID', '額',
     '重要事項', '日記', '日記詳細'],
    columns:
    ['srnowdate', 'saving_id', 'srnowvalue',
     'srnownotice', 'srnowdiary', 'srnowdetail' ]),
    filename: "#{Time.current.strftime('%Y%m%d')}.csv"
  end

  # GET /saverecords/1
  # GET /saverecords/1.json
  def show
  end

  # GET /saverecords/new
  def new
    @saverecord = Saverecord.new
  end

  # GET /saverecords/1/edit
  def edit
  end

  # POST /saverecords
  # POST /saverecords.json
  def create
    @saverecord = Saverecord.new(saverecord_params)

    respond_to do |format|
      if @saverecord.save
        format.html { redirect_to @saverecord, notice: '資産（貯蓄）履歴1件登録しました。' }
        format.json { render :show, status: :created, location: @saverecord }
      else
        format.html { render :new }
        format.json { render json: @saverecord.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /saverecords/1
  # PATCH/PUT /saverecords/1.json
  def update
    respond_to do |format|
      if @saverecord.update(saverecord_params)
        format.html { redirect_to @saverecord, notice: '資産（貯蓄）履歴1件更新しました。' }
        format.json { render :show, status: :ok, location: @saverecord }
      else
        format.html { render :edit }
        format.json { render json: @saverecord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /saverecords/1
  # DELETE /saverecords/1.json
  def destroy
    @saverecord.destroy
    respond_to do |format|
      format.html { redirect_to saverecords_url, notice: '資産（貯蓄）履歴1件削除しました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saverecord
      @saverecord = Saverecord.find(params[:id])
    end

    # savingの複数フィールドをある１つの特定フィールドで参照できるよう
    # saverecord生成時どのsavingを選択するかのため
    # select sfrom || id || sdiary as sa3 from savings ;
    def set_sv
      @sv =  Saving.find_by_sql(
       [" select 'ID=' || id || ':  対象=' ||  sobject || ':  保管先=' || sfrom as sa3,id from savings "])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def saverecord_params
      params.require(:saverecord).permit(:saving_id, :srnowdate, :srnowvalue, :srnownotice, :srnowdiary, :srnowdetail, :srnextdate)
    end
    def search_params
      params
        .require(:search_saverecord)
        .permit(Search::Saverecord::ATTRIBUTES)
    end


end
