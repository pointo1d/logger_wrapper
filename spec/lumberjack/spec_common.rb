
METHODS = {
  'core'  => {
    'gen'  => %w(#debug #info #warn #error #fatal #unknown),
    'non_gen' => %w(
      ::new #<< #close #datetime_format #datetime_format= #level= #reopen
      #sev_threshold= #debug? #info? #warn? #error? #fatal?  #unknown?
    )
  },
  'extra' => {
    'gen'     => %w(#trace #entry #exit),
    'non_gen' => %w(
      #callret? #on #on? #off #off? #levels #trace? #entry? #exit?
    ),
  }
}

GEN_METHODS = [*(METHODS['core']['gen']), *(METHODS['extra']['gen'])]
NON_GEN_METHODS =
  [*(METHODS['core']['non_gen']), *(METHODS['extra']['non_gen'])]

#### END OF FILE
