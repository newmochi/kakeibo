class IncomesController < ApplicationController
  # sumicsv用にrequire
  require 'csv'
  before_action :set_income, only: [:show, :edit, :update, :destroy]

  # GET /incomes
  # GET /incomes.json
  def index
    # @incomes = Income.all
    # @incomes = Income.page(params[:page]).order(:id)
    # indexであっても検索フォームを出すので、まずはnewメソッドでフォーム準備
    # そのあと、searchをコールして検索結果表示
    @income = Search::Income.new



    ######デバッグ用ブレークポイント#######
     ###binding.pry
    ######デバッグ用ブレークポイント#######
  end

  def search
    @income = Search::Income.new(search_params)
    @incomes = @income.matches.order(idate: :asc, ikindx: :asc).page(params[:page])
#      .decorate
  end

  def copy
    @org_income = Income.find(params[:id])
    @income = Income.new
    @income.attributes = @org_income.attributes 
    @income.idate = Time.now
  end

  def export_csv
    @incomes =Income.all.order(idate: :asc, ikindx: :asc)
    send_data @incomes.to_csv(header: 
    ['発生日', '対象', '額', '分類1',  '分類2', '入手者',
    '収入源', '税引前額', '重要事項', '日記', '日記詳細'],
    columns:
    ['idate', 'iobject', 'ivalue', 'ikindx', 'ikindy', 'iperson',
    'ifrom', 'iorgvalue', 'inotice', 'idiary', 'idetail' ]),
    filename: "#{Time.current.strftime('%Y%m%d')}.csv"
  end

  # GET /incomes/1
  # GET /incomes/1.json
  def show
  end

  # GET /incomes/new
  def new
    @income = Income.new
  end

  # GET /incomes/1/edit
  def edit
  end

  # POST /incomes
  # POST /incomes.json
  def create
    @income = Income.new(income_params)

    respond_to do |format|
      if @income.save
        # format.html { redirect_to @income, notice: 'Income was successfully created.' }
        format.html { redirect_to @income, notice: '収入1件登録しました。' }
        format.json { render :show, status: :created, location: @income }
      else
        format.html { render :new }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incomes/1
  # PATCH/PUT /incomes/1.json
  def update
    respond_to do |format|
      if @income.update(income_params)
        format.html { redirect_to @income, notice: '収入1件更新しました。' }
        format.json { render :show, status: :ok, location: @income }
      else
        format.html { render :edit }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incomes/1
  # DELETE /incomes/1.json
  def destroy
    @income.destroy
    respond_to do |format|
      format.html { redirect_to incomes_url, notice: '収入1件削除しました。' }
      format.json { head :no_content }
    end
  end





  # expenses_controller.rbのsumexshowのexpense->income,ex->iとした。
  # sumishowsumishowsumishowsumishowsumishowsumishowsumishowsumishowsumishow
  # 必要な表示に対応して収入の種別別1か月集計
  # sumishowsumishowsumishowsumishowsumishowsumishowsumishowsumishowsumishow

  def sumishow

    # sumishow-01 準備として種別数、種別のリストから配列化したものを用意
    # リストは、orderを入れないとikindxがヒットした順になってしまうので注意
    # 更に月別の月を月リストに。1か月全て０円だとこのリストの月が飛ぶことに
    # なるので、SQLでとっておく。

    @ikindxcount = Income.find_by_sql(
       ['select distinct ikindx  from incomes ']).count

    @ikindxlist = Income.select(:ikindx).distinct.order(:ikindx)

    @imonthlist = Income.find_by_sql(
       ["select idate from incomes group by strftime( '%%Y%%m', idate )"])
    
    @ikindxmaster = @ikindxlist.map(&:ikindx)
    @ikindxmaster[@ikindxcount] = 99999 # これは使わない

    # 次のexmonthmaster系は、monとyear取り出すのでforループで
    j = 0
    @imonthmaster = Array.new()
    @imonthmaster_year = Array.new()
    @imonthlist.each do |item2|
      @imonthmaster[j] = item2.idate.mon
      @imonthmaster_year[j] = item2.idate.year
      j = j + 1
    end

    @from_year = @imonthmaster_year.min
    @to_year = @imonthmaster_year.max

    ######デバッグ用ブレークポイント#######
    ### binding.pry
    ######デバッグ用ブレークポイント#######

    # sumishow-02 種別毎月集計(SQL結果なので合計ゼロはデータそのものがない)
    # strftimeの%Y%mは、%が置換用文字と勘違いされるので、%%とするらしい。

    @ikindxmonth = Income.find_by_sql(
      ["select ikindx,idate,sum(ivalue) as sumivalue from incomes group by strftime( '%%Y%%m', idate ), ikindx"])

    # sumishow-03 種別毎月集計 @ikindxmonthallxx[i=年月][j=ikindx]
    # 種別(ikindx)がその月ゼロのものはSQL結果にない。それを表示のために一次元配列上、
    # 当該配列上、値がゼロとしてセットする

    iii = jjj = 0
    # 100年分(1200)二次元タイプ
    @ikindxmonthallxx = Array.new(1200).map{ Array.new(@ikindxcount, 0) }

    # 月が替わるのをチェックするためのオブジェクト
    current_item_date = Time.local(2016, 3, 1)
    @ikindxmonth.each do |item|
      current_item_date = item.idate
      break
    end
    current_item_yymm = current_item_date.year * 100 + current_item_date.month

    # 最終レコードのチェックをして月iiiを最後に間違って足さないように
    # @exkindxmonth.countを使う。＝＝＞kindxが合致したif文のところで。
    total_count_ikindxmonth = @ikindxmonth.count
    count_ikindxmonth = 0

    # 最後の種別まで行ったらitemのcurrent_item_yymmが変わっているのは当然。
    # しかもそのときは、sumishow-03-1aのゼロセットしちゃうと１か月分
    # ０が入ってしまう。
    # 以下のステータスが1のときはsumishow-03-1aをスキップ。
    kindx_end_status = 0

    #################################################LOOP start

    @ikindxmonth.each do |item| # メインループ@ikindxmonth.each

      if iii > 1199 then #100年以上はやらない。
        break
      end

      # sumishow-03-1a SQL結果の種別と表示用マスター種別の比較の前に、
      # 現在配列にセットしている月と思いきや、item側が翌月以降の値に
      # なっていたら、以下に対応して０をセット。
      # ① 当該月はこのあとの表示用マスターに対応するデータ
      # ② 更に月を１つアップ、種別をゼロリセットして種別がマッチする
      #    まで０にセット

      if kindx_end_status == 1 then
        kindx_end_status = 0
      else if current_item_yymm != (item.idate.year*100+item.idate.month) then
        # その月の残りのikindxに対応する配列に０セット

          while @ikindxmaster[jjj] != @ikindxmaster[@ikindxcount -1 +1 ] do
            @ikindxmonthallxx[ iii ][ jjj ] = 0
            jjj = jjj + 1
          end
          # 次の月のためにiiiを+1し、新たな月でもikindxに対応するまで０セット
          jjj = 0
          iii = iii + 1
          # sumishow-03-1bにて行う。
        end
      end

      # sumishow-03-1b SQL結果の種別より、表示用マスター種別が大
      # これは、当該月は表示用マスターに対応するデータがないばかりか
      # SQLの種別が一巡して小さい値になっているため、次の月の集計結果
      # に遭遇したということ。よって、マスターを０からにして月を1月アップ

      if  item.ikindx < @ikindxmaster[jjj] then

        # 次の月の周回に入ったのだ
        # しかしそうなると次の月の周回までの間もゼロをセットすること
        # セットするのは、
        # @ikindxmaster[jjj]から@ikindxmaster[@ikindxcount - 1]に
        # 対応する@ikindxmonthall[]

        while @ikindxmaster[jjj] != @ikindxmaster[@ikindxcount - 1] do

          @ikindxmonthallxx[ iii ][ jjj ] = 0
          jjj = jjj + 1
        end
        # 最後の種別は!=でセットされていないのでゼロをセット
        @ikindxmonthallxx[ iii ][ jjj ] = 0

        # やっと周回が終わったので、次の月のためにjjjをリセット、iiiを翌月に
        jjj = 0
        iii = iii + 1
      end

      # sumishow-03-2 SQL結果の種別と表示用マスター種別が違うだけ
      # これは、当該月の中で表示用マスターに対応するデータがないだけ
      # その場合、当該種別の値をゼロにセット。両社が一致しない間は
      # 全て表示用マスターに対応したデータがないということでゼロ

      while item.ikindx != @ikindxmaster[jjj] do

        @ikindxmonthallxx[ iii ][ jjj ] = 0
        jjj = jjj + 1
      end

      # sumishow-03-3 SQL結果の種別と、表示用マスター種別が合致！！！
      # これは、そのまま一次元配列にセット。
      # 一次元配列は、表示用マスターの数単位で月がアップするようセット

      if item.ikindx ==  @ikindxmaster[jjj] then ## sumishow-03-3 start
        @ikindxmonthallxx[ iii ][ jjj ] = item.sumivalue
        # 重要、消すな
        count_ikindxmonth = count_ikindxmonth + 1
        # 重要、消すな
        current_item_yymm = item.idate.year * 100 + item.idate.month

        # 2016.4.6 add item.ikindx == @ikindxmaster == 91(LAST ikindx)
        # の時、jjj = jjj + 1すると、@ikindxmaster[jjj]はnilになる。
        # つまり@ikindxmasterがLASTのkindxの場合、jjjを0リセットする。
        # しかし、そうすると次の周回にうまくまわらない。
        # 但し本当にデータの最後の場合、ここで終わり。

        if jjj == ( @ikindxcount -1 ) then

          # if これが本当にデータの最後なら、ループから抜ける。
          if count_ikindxmonth == total_count_ikindxmonth then
            break ;
          end
          jjj = 0
          iii = iii + 1
          kindx_end_status = 1

        else
          jjj = jjj + 1

        end

      end ## sumishow-03-3 end

    end # メインループ終了 @ikindxmonth.each

    #################################################LOOP end


    @total_count = iii * @ikindxcount + jjj #一次元配列なので1オリジンでOK
    @total_month = iii + 1 #0からなので+1が月数


    # sumishow-04 # 全額毎月集計(100年分=12*100確保) @imonthvalue[i=年月]

    @imonthvalue = Array.new(1200,0)
    for ii in 0..(@total_month - 1)
      for jj in 0..(@ikindxcount - 1)
        @imonthvalue[ii] = @imonthvalue[ii] + @ikindxmonthallxx[ii][jj]
      end
    end


    # sumishow-05 種別毎年集計 @ikindx_vper_year[y=年][j=種別]
    # (100年分=種別*100)

    @ikindx_vper_year = Array.new(100).map{ Array.new(@ikindxcount, 0) }

    i = 0
    for y in 0..(@to_year - @from_year)  # 年ごと
      check_year = @from_year + y
      while @imonthmaster_year[i] == check_year do
          for jj in 0..(@ikindxcount - 1)
            @ikindx_vper_year[y][jj] = @ikindx_vper_year[y][jj] + @ikindxmonthallxx[i][jj]
          end
          i = i + 1
      end
    end


    # sumishow-06 # 全額毎年集計(100年分=12*100確保) @iyearvalue[i=年]

    @iyearvalue = Array.new(100,0)
    for ii in 0..(@to_year - @from_year)
      for jj in 0..(@ikindxcount - 1)
        @iyearvalue[ii] = @iyearvalue[ii] + @ikindx_vper_year[ii][jj]
      end
    end


    ######デバッグ用ブレークポイント#######
    ###    binding.pry
    ######デバッグ用ブレークポイント#######

  end
  # end of sumishow end of sumishow end of sumishow end of sumishow
  # end of sumishow end of sumishow end of sumishow end of sumishow


  ## 集計CSV出力
  ##
  def sumicsv
    # CSVにしたいのは、sumishowの結果
    sumishow
    # CSV化-1 ヘッダー
    header = ['年月']
    for jj in 0..(@ikindxcount - 1)
      header << @ikindxmaster[jj]
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
        tmp1record[0] = @imonthmaster_year[ii].to_s + '/' + @imonthmaster[ii].to_s
        # 次の列から存在する分類ごとの集計データ
        for jj in 0..(@ikindxcount - 1)
          tmp1record[1 + jj] =
            @ikindxmonthallxx[ii][jj].to_s(:delimited) if @ikindxmonthallxx[ii][jj] !=nil
        end
        # 最後の列はその月の合計(実はExcelで集計しても良い)
        tmp1record[ @ikindxcount + 1 ] =
          @imonthvalue[ii].to_s(:delimited) if @imonthvalue[ii] !=nil
        # tmp1recordの部分配列(0から添え字が(*count+1)まで)をcsv配列にコピー
        csv << tmp1record[ 0..(@ikindxcount + 1) ]
      end
    end
    # CSV化-2 データ 上でend ===============================
    # CSVをファイルに出力
    send_data generated_csv.encode(Encoding::CP932, invalid: :replace, undef: :replace),
      filename: 'sumishow.csv',
      type: 'text/csv; charset=shift_jis'
  end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income
      @income = Income.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_params
      params.require(:income).permit(:idate, :ivalue, :iorgvalue, :iperson,
        :iobject, :ikindx, :ikindy, :ifrom, :inotice, :idiary, :idetail)
    end

    def search_params
      params
        .require(:search_income)
        .permit(Search::Income::ATTRIBUTES)
    end

end
