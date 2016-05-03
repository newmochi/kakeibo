class Form::Expense < Expense
  REGISTRABLE_ATTRIBUTES = %i(register exdate exvalue experson exkindx exkindy exfrom exnotice exdiary exdetail exextrasoutou execosoutou exobject)
  attr_accessor :register
end
