if exists("b:current_syntax")
  finish
endif

" Define matches
syn keyword	confTodo	contained TODO FIXME XXX
syn match	confComment	"^#.*$" contains=confTodo,@Spell
syn match commandLine "^[^#].*##.*$" contains=@Label,@Command
syn match Label "^[^#].* #"he=e-1
syn match Command " .*"hs=s+1

" Set colors
hi def link confComment	Comment
hi def link Label Identifier
hi def link Command String

let b:current_syntax = "conf"

" vim: ts=8 sw=2
