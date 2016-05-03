# load to グローバル変数 for saving(index,show)
# 表示の場合は、グループ化不要。ノベタンで値に対して文字列でいい。
      $saperson_disp_m = YAML.load(
        File.read("#{Rails.root}/config/initializers/my_config/sav2disp.yml"))
