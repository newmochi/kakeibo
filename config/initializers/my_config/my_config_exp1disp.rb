# load to グローバル変数 for expense(show,index)
# 表示の場合は、グループ化不要。ノベタンで値に対して文字列でいい。
      $exkindx_disp_m = YAML.load(
        File.read("#{Rails.root}/config/initializers/my_config/exp1disp.yml"))
