# load to グローバル変数 for saving(input,edit)
# edit.html.erbで使用する
      $sakindx_sel_m = YAML.load(
        File.read("#{Rails.root}/config/initializers/my_config/sav1edit.yml"))
