# load to グローバル変数 for income(input,edit)
# edit.html.erbで使用する
      $inperson_sel_m = YAML.load(
        File.read("#{Rails.root}/config/initializers/my_config/inc2edit.yml"))
