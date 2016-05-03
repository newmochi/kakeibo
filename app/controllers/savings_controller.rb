class SavingsController < ApplicationController
  # exp_sandr_csv用にrequire
  require 'csv'
  before_action :set_saving, only: [:show, :edit, :update, :destroy]

  # GET /savings
  # GET /savings.json
  def index
    # @savings = Saving.all
    # @savings = Saving.page(params[:page]).order(:id)
    # indexであっても検索フォームを出すので、まずはnewメソッドでフォーム準備
    # そのあと、searchをコールして検索結果表示
    @saving = Search::Saving.new
  end

  def search
    @saving = Search::Saving.new(search_params)
    @savings = @saving.matches.order(sperson: :desc, skindx: :asc).page(params[:page]).per(50)
#   以下ができるか、がカギ
#    @savings = @saving.matches.includes(:saverecord)
#               .order(scheckdate: :desc).page(params[:page])
  end

  ## 集計CSV出力
  ## CSVにしたいのは、savingsにsaverecordsの最新額
  def exp_sandr_csv

    @savings = Saving.all.order(sperson: :desc, skindx: :asc)
    # CSV化-1 ヘッダー
    header = ['ID', '起点日', '額', '最新額', 
      '同日付', '対象', '所有者', '分類1',
      '分類2', '保管先', '重要事項', '日記',
      '日記詳細'
    ]

    # CSV化-2 データ start ================================
    generated_csv = CSV.generate(row_sep: "\r\n") do |csv|
      csv << header

      @savings.each do |sa|

        # saverecordsがある、つまり履歴があるときはその額と値、else、savingsの値
        if sa.saverecords.present?
          tmpsr = sa.saverecords.order( srnowdate: :desc )
          tmpsr_v = tmpsr[0].srnowvalue.to_s(:delimited, delimiter: ',') if tmpsr[0].srnowvalue != nil
          tmpsr_d = tmpsr[0].srnowdate.try(:strftime, "%Y/%m/%d ")
        else
          tmpsr_v = sa.svalue.to_s(:delimited) if sa.svalue != nil
          tmpsr_d = sa.scheckdate.try(:strftime, "%Y/%m/%d ")
        end

        # CSV用1行にsavingsとsaverecordsの額＆値をセット

        csv << [ sa.id, sa.scheckdate.try(:strftime, "%Y/%m/%d "),
          sa.svalue, tmpsr_v,
          tmpsr_d, sa.sobject, $saperson_disp_m[sa.sperson], sa.skindx,
          sa.skindy, sa.sfrom, sa.snotice, sa.sdiary,
          sa.sdetail
        ]

      end

    end
    # CSV化-2 データ 上でend ===============================
    # CSVをファイルに出力
    send_data generated_csv.encode(Encoding::CP932, invalid: :replace, undef: :replace),
      filename: 'exp_sandr.csv',
      type: 'text/csv; charset=shift_jis'
  end


  # GET /savings/1
  # GET /savings/1.json
  def show
  end

  # GET /savings/new
  def new
    @saving = Saving.new
  end

  # GET /savings/1/edit
  def edit
  end

  # POST /savings
  # POST /savings.json
  def create
    @saving = Saving.new(saving_params)

    respond_to do |format|
      if @saving.save
        format.html { redirect_to @saving, notice: '資産マスター1件登録しました。' }
        format.json { render :show, status: :created, location: @saving }
      else
        format.html { render :new }
        format.json { render json: @saving.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /savings/1
  # PATCH/PUT /savings/1.json
  def update
    respond_to do |format|
      if @saving.update(saving_params)
        format.html { redirect_to @saving, notice: '資産マスター1件更新しました。' }
        format.json { render :show, status: :ok, location: @saving }
      else
        format.html { render :edit }
        format.json { render json: @saving.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /savings/1
  # DELETE /savings/1.json
  def destroy
    @saving.destroy
    respond_to do |format|
      format.html { redirect_to savings_url, notice: '資産マスター1件削除しました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saving
      @saving = Saving.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def saving_params
      params.require(:saving).permit(:scheckdate, :svalue, :sperson, :skindx,
        :sobject, :skindy, :sfrom, :snotice, :sdiary, :sdetail)
    end

    def search_params
      params
        .require(:search_saving)
        .permit(Search::Saving::ATTRIBUTES)
    end

end
