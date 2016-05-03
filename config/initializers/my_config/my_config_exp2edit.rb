# load to グローバル変数 for expense(input,edit)
# new.html.erbとedit.html.erbで使用する
      $experson_sel_m = YAML.load(
        File.read("#{Rails.root}/config/initializers/my_config/exp2edit.yml"))
