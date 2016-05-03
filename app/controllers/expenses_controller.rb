class ExpensesController < ApplicationController
  # sumexcsv用にrequire
  require 'csv'
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    # @expenses = Expense.all
    # @expenses = Expense.page(params[:page]).order(:id)
    # indexであっても検索フォームを出すので、まずはnewメソッドでフォーム準備
    # そのあと、searchをコールして検索結果表示
    @expense = Search::Expense.new
  end

  def search
    @expense = Search::Expense.new(search_params)
    @expenses = @expense.matches.order(exdate: :asc, exkindx: :asc).page(params[:page])
  end

  def copy
    @org_expense = Expense.find(params[:id])
    @expense = Expense.new
    @expense.attributes = @org_expense.attributes 
    @expense.exdate = Time.now
  end

  def createone
    @expense = Expense.new(expense_params)

    respond_to do |format|
      if @expense.save
        # format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
        format.html { redirect_to @expense, notice: '支出1件登録しました。' }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  def export_csv
    @expenses =Expense.all.order(exdate: :asc, exkindx: :asc)
#    @expenses =Expense.all
# ok    send_data @expenses.to_csv, filename: "#{Time.current.strftime('%Y%m%d')}.csv"
    send_data @expenses.to_csv(header: 
    ['発生日', '対象', '額', '分類1',  '分類2', '誰向',
    '支払先', '贅沢額', '節約額', '重要事項', '日記', '日記詳細'],
    columns:
    ['exdate', 'exobject', 'exvalue', 'exkindx', 'exkindy', 'experson',
    'exfrom', 'exextrasoutou', 'execosoutou', 'exnotice', 'exdiary', 'exdetail' ]),
    filename: "#{Time.current.strftime('%Y%m%d')}.csv"
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end

#  def new
#  def create
#  一括登録用の1行を使って1レコード登録すればよいのでカットした。
#  必要なら他のテーブルのnew,createをもとに再生せよ。その場合、一括
#  登録のnew,createを削除。

  # 一括登録用
  def new
    @form = Form::ExpenseCollection.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json


  # 一括登録用
  def create
    @form = Form::ExpenseCollection.new(expense_collection_params)
    if @form.save
      redirect_to :expenses, notice: "#{@form.target_expenses.size}件の支出を登録しました。"
    else
      render :new
    end
  end


  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: '支出1件更新しました。' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_url, notice: '支出1件削除しました。' }
      format.json { head :no_content }
    end
  end

  # sumexshowsumexshowsumexshowsumexshowsumexshowsumexshowsumexshowsumexshowsumexshow
  # 必要な表示に対応して支出の種別別1か月集計
  # sumexshowsumexshowsumexshowsumexshowsumexshowsumexshowsumexshowsumexshowsumexshow

  def sumexshow

    # sumexshow-01 準備として種別数、種別のリストから配列化したものを用意
    # リストは、orderを入れないとexkindxがヒットした順になってしまうので注意
    # 更に月別の月を月リストに。1か月全て０円だとこのリストの月が飛ぶことに
    # なるので、SQLでとっておく。

    @exkindxcount = Expense.find_by_sql(
       ['select distinct exkindx  from expenses ']).count

    @exkindxlist = Expense.select(:exkindx).distinct.order(:exkindx)

    @exmonthlist = Expense.find_by_sql(
       ["select exdate from expenses group by strftime( '%%Y%%m', exdate )"])

    @exkindxmaster = @exkindxlist.map(&:exkindx)
    @exkindxmaster[@exkindxcount] = 99999 # これは使わない

    # 次のexmonthmaster系は、monとyear取り出すのでforループで
    j = 0
    @exmonthmaster = Array.new()
    @exmonthmaster_year = Array.new()
    @exmonthlist.each do |item2|
      @exmonthmaster[j] = item2.exdate.mon
      @exmonthmaster_year[j] = item2.exdate.year
      j = j + 1
    end

    @from_year = @exmonthmaster_year.min
    @to_year = @exmonthmaster_year.max

    ######デバッグ用ブレークポイント#######
    ### binding.pry
    ######デバッグ用ブレークポイント#######

    # sumexshow-02 種別毎月集計(SQL結果なので合計ゼロはデータそのものがない)
    # strftimeの%Y%mは、%が置換用文字と勘違いされるので、%%とするらしい。

    @exkindxmonth = Expense.find_by_sql(
      ["select exkindx,exdate,sum(exvalue) as sumexvalue from expenses group by strftime( '%%Y%%m', exdate ), exkindx"])

    # sumexshow-03 種別毎月集計 @exkindxmonthallxx[i=年月][j=exkindx]
    # 種別(exkindx)がその月ゼロのものはSQL結果にない。それを表示のために一次元配列上、
    # 当該配列上、値がゼロとしてセットする

     iii = jjj = 0
    # 100年分(1200)二次元タイプ
    @exkindxmonthallxx = Array.new(1200).map{ Array.new(@exkindxcount, 0) }

    # 月が替わるのをチェックするためのオブジェクト
    current_item_date = Time.local(2016, 3, 1)
    @exkindxmonth.each do |item|
      current_item_date = item.exdate
      break
    end
    current_item_yymm = current_item_date.year * 100 + current_item_date.month

    # 最終レコードのチェックをして月iiiを最後に間違って足さないように
    # @exkindxmonth.countを使う。＝＝＞kindxが合致したif文のところで。
    total_count_exkindxmonth = @exkindxmonth.count
    count_exkindxmonth = 0

    # 最後の種別まで行ったらitemのcurrent_item_yymmが変わっているのは当然。
    # しかもそのときは、sumishow-03-1aのゼロセットしちゃうと１か月分
    # ０が入ってしまう。
    # 以下のステータスが1のときはsumishow-03-1aをスキップ。
    kindx_end_status = 0

    #################################################LOOP start

    @exkindxmonth.each do |item| # メインループ@exkindxmonth.each

      if iii > 1199 then #100年以上はやらない。
        break
      end

      # sumexshow-03-1a SQL結果の種別と表示用マスター種別の比較の前に、
      # 現在配列にセットしている月と思いきや、item側が翌月以降の値に
      # なっていたら、以下に対応して０をセット。
      # ① 当該月はこのあとの表示用マスターに対応するデータ
      # ② 更に月を１つアップ、種別をゼロリセットして種別がマッチする
      #    まで０にセット

      if kindx_end_status == 1 then
        kindx_end_status = 0
      else if current_item_yymm != (item.exdate.year*100+item.exdate.month) then
          # その月の残りのexkindxに対応する配列に０セット

          while @exkindxmaster[jjj] != @exkindxmaster[@exkindxcount - 1] do
            @exkindxmonthallxx[ iii ][ jjj ] = 0
            jjj = jjj + 1
          end
          # 次の月のためにiiiを+1し、新たな月でもexkindxに対応するまで０セット
          jjj = 0
          iii = iii + 1
          # sumexshow-03-1bにて行う。
        end
      end

      # sumexshow-03-1b SQL結果の種別より、表示用マスター種別が大
      # これは、当該月は表示用マスターに対応するデータがないばかりか
      # SQLの種別が一巡して小さい値になっているため、次の月の集計結果
      # に遭遇したということ。よって、マスターを０からにして月を1月アップ

      if  item.exkindx < @exkindxmaster[jjj] then

        # 次の月の周回に入ったのだ
        # しかしそうなると次の月の周回までの間もゼロをセットすること
        # セットするのは、
        # @exkindxmaster[jjj]から@exkindxmaster[@exkindxcount - 1]に
        # 対応する@exkindxmonthall[]

        while @exkindxmaster[jjj] != @exkindxmaster[@exkindxcount - 1] do

          @exkindxmonthallxx[ iii ][ jjj ] = 0
          jjj = jjj + 1
        end
        # 最後の種別は!=でセットされていないのでゼロをセット
        @exkindxmonthallxx[ iii ][ jjj ] = 0

        # やっと周回が終わったので、次の月のためにjjjをリセット、iiiを翌月に
        jjj = 0
        iii = iii + 1
      end

      # sumexshow-03-2 SQL結果の種別と表示用マスター種別が違うだけ
      # これは、当該月の中で表示用マスターに対応するデータがないだけ
      # その場合、当該種別の値をゼロにセット。両社が一致しない間は
      # 全て表示用マスターに対応したデータがないということでゼロ

      while item.exkindx != @exkindxmaster[jjj] do

        @exkindxmonthallxx[ iii ][ jjj ] = 0
        jjj = jjj + 1
      end

      # sumexshow-03-3 SQL結果の種別と、表示用マスター種別が合致！！！
      # これは、そのまま一次元配列にセット。
      # 一次元配列は、表示用マスターの数単位で月がアップするようセット

      if item.exkindx ==  @exkindxmaster[jjj] then ## sumexshow-03-3 start
        @exkindxmonthallxx[ iii ][ jjj ] = item.sumexvalue
        # 重要、消すな
        count_exkindxmonth = count_exkindxmonth + 1
        # 重要、消すな
        current_item_yymm = item.exdate.year * 100 + item.exdate.month

        # 2016.4.6 add item.exkindx == @exkindxmaster == 91(LAST exkindx)
        # の時、jjj = jjj + 1すると、@exkindxmaster[jjj]はnilになる。
        # つまり@exkindxmasterがLASTのkindxの場合、jjjを0リセットする。
        # しかし、そうすると次の周回にうまくまわらない。
        # 但し本当にデータの最後の場合、ここで終わり。

        if jjj == ( @exkindxcount -1 ) then

          # if これが本当にデータの最後なら、ループから抜ける。
          if count_exkindxmonth == total_count_exkindxmonth then
            break ;
          end
          jjj = 0
          iii = iii + 1
          kindx_end_status = 1

        else
          jjj = jjj + 1

        end

      end ## sumexshow-03-3 end

    end # メインループ終了 @exkindxmonth.each

    #################################################LOOP end


    @total_count = iii * @exkindxcount + jjj #一次元配列なので1オリジンでOK
    @total_month = iii + 1 #0からなので+1が月数


    # sumexshow-04 # 全額毎月集計(100年分=12*100確保) @exmonthvalue[i=年月]

    @exmonthvalue = Array.new(1200,0)
    for ii in 0..(@total_month - 1)
      for jj in 0..(@exkindxcount - 1)
        @exmonthvalue[ii] = @exmonthvalue[ii] + @exkindxmonthallxx[ii][jj]
      end
    end


    # sumexshow-05 種別毎年集計 @exkindx_vper_year[y=年][j=種別]
    # (100年分=種別*100)

    @exkindx_vper_year = Array.new(100).map{ Array.new(@exkindxcount, 0) }

    i = 0
    for y in 0..(@to_year - @from_year)  # 年ごと
      check_year = @from_year + y
      while @exmonthmaster_year[i] == check_year do
          for jj in 0..(@exkindxcount - 1)
            @exkindx_vper_year[y][jj] = @exkindx_vper_year[y][jj] + @exkindxmonthallxx[i][jj]
          end
          i = i + 1
      end
    end


    # sumexshow-06 # 全額毎年集計(100年分=12*100確保) @exyearvalue[i=年]

    @exyearvalue = Array.new(100,0)
    for ii in 0..(@to_year - @from_year)
      for jj in 0..(@exkindxcount - 1)
        @exyearvalue[ii] = @exyearvalue[ii] + @exkindx_vper_year[ii][jj]
      end
    end


    ######デバッグ用ブレークポイント#######
    ###    binding.pry
    ######デバッグ用ブレークポイント#######

  end
  # end of sumexshow end of sumexshow end of sumexshow end of sumexshow
  # end of sumexshow end of sumexshow end of sumexshow end of sumexshow

  ## 集計CSV出力
  ##
  def sumexcsv
    # CSVにしたいのは、sumexshowの結果
    sumexshow
    # CSV化-1 ヘッダー
    header = ['年月']
    for jj in 0..(@exkindxcount - 1)
      header << @exkindxmaster[jj]
    end
    header << '月合計'

    # CSV化-2 データ start ================================
    generated_csv = CSV.generate(row_sep: "\r\n") do |csv|
      csv << header
      # 1レコード用配列(max102)に0をセット
      tmp1record = Array.new(102,'0')

      # 集計データがある月の数だけ行があるためループ
      for ii in 0..(@total_month - 1)
        # 最初の列は年月
        tmp1record[0] = @exmonthmaster_year[ii].to_s + '/' + @exmonthmaster[ii].to_s
        # 次の列から存在する分類ごとの集計データ
        for jj in 0..(@exkindxcount - 1)
          tmp1record[1 + jj] =
            @exkindxmonthallxx[ii][jj].to_s(:delimited) if @exkindxmonthallxx[ii][jj] !=nil
        end
        # 最後の列はその月の合計(実はExcelで集計しても良い)
        tmp1record[ @exkindxcount + 1 ] =
          @exmonthvalue[ii].to_s(:delimited) if @exmonthvalue[ii] !=nil
        # tmp1recordの部分配列(0から添え字が(*count+1)まで)をcsv配列にコピー
        csv << tmp1record[ 0..(@exkindxcount + 1) ]
      end
    end
    # CSV化-2 データ 上でend ===============================
    # CSVをファイルに出力
    send_data generated_csv.encode(Encoding::CP932, invalid: :replace, undef: :replace),
      filename: 'sumexshow.csv',
      type: 'text/csv; charset=shift_jis'
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.

  # new1レコード登録時のexpense_paramasはカット。

  # 一括登録用
  def expense_collection_params
    params
      .require(:form_expense_collection)
      .permit(expenses_attributes: Form::Expense::REGISTRABLE_ATTRIBUTES)
  end
  def expense_params
    params.require(:expense).permit(:exdate, :exvalue, :experson, :exkindx, :exkindy, :exfrom, :exnotice, :exdiary, :exdetail, :exextrasoutou, :execosoutou, :exobject)
  end

  def search_params
    params
      .require(:search_expense)
      .permit(Search::Expense::ATTRIBUTES)
  end

end
