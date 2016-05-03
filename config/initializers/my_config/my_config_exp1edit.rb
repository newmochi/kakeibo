# load to グローバル変数 for expense(input,edit)
# new.html.erbとedit.html.erbで使用する
      $exkindx_sel_m = YAML.load(
        File.read("#{Rails.root}/config/initializers/my_config/exp1edit.yml"))
