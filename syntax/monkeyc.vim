" Vim syntax file
" Language:     Monkey C
" Maintainer:   Josa Gesell
" URL:          https://github.com/josa42/vim-monkey-c

" TODO
"   Containers: https://developer.garmin.com/connect-iq/monkey-c/containers/
"   Annotations: https://developer.garmin.com/connect-iq/monkey-c/annotations/
"   Keywords: const, enum, has, module, self, hidden, private, static, default, protected, public, me
"

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'monkeyc'
endif

syntax sync fromstart
syntax case match

syntax match   mcNoise          /[:,;]/
syntax match   mcDot            /\./ skipwhite skipempty nextgroup=mcObjectProp,mcFuncCall
syntax match   mcObjectProp     contained /\<\K\k*/
" syntax match   mcFuncCall       /\<\K\k*\ze\s*(
" syntax match   mcParensError    /[)}\]]/

" variables
syntax keyword mcVariableVar      var skipwhite skipempty nextgroup=mcVariableDef
syntax match   mcVariableDef      contained /\<\K\k*/ skipwhite skipempty nextgroup=mcVariableOperator
syntax keyword mcVariableOperator = skipwhite skipempty nextgroup=@mcVariableValue
syntax cluster mcVariableValue    contains=mcString,mcChar,mcNumber,mcFloat,mcBooleanTrue,mcBooleanFalse
syntax cluster mcVariable   contains=mcVariableVar,mcVariableDef,mcVariableOperator,@mcVariableValue

syntax keyword mcOperatorKeyword new instanceof skipwhite skipempty nextgroup=@mcExpression
syntax match   mcOperator       "[-!|&+<>=%/*~^]" skipwhite skipempty nextgroup=@mcExpression
"
" Imports
syntax keyword mcUsing                       using skipwhite skipempty nextgroup=mcUsingModule
syntax keyword mcUsingModule                 contained /\<\K\k*/ skipwhite skipempty nextgroup=mcUsingAs
syntax keyword mcUsingAs                     as skipwhite skipempty nextgroup=mcUsingAs,mcUsingModuleAlias
syntax keyword mcUsingModuleAlias            contained /\<\K\k*/ skipwhite skipempty
"
" Strings, Numbers, Boolean
syntax region  mcString           start=+\z(["]\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+  contains=mcSpecial extend
syntax match   mcChar             "L\='[^\\]'"
syntax match   mcNumber           /\c\<\%(\d\+\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\%(\x\|_\)\+\)n\=\>/
syntax match   mcFloat            /\c\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%(e[+-]\=\d\+\)\=\>/
syntax keyword mcBooleanTrue    true
syntax keyword mcBooleanFalse   false

" Objects
" syntax match   mcObjectShorthandProp contained /\<\k*\ze\s*/ skipwhite skipempty nextgroup=mcObjectSeparator
" syntax match   mcObjectKey         contained /\<\k*\ze\s*:/ contains=mcFunctionKey skipwhite skipempty nextgroup=mcObjectValue
" syntax region  mcObjectKeyString   contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=mcSpecial skipwhite skipempty nextgroup=mcObjectValue
" syntax region  mcObjectKeyComputed contained matchgroup=mcBrackets start=/\[/ end=/]/ contains=@mcExpression skipwhite skipempty nextgroup=mcObjectValue,mcFuncArgs extend
" syntax match   mcObjectSeparator   contained /,/
" syntax region  mcObjectValue       contained matchgroup=mcObjectColon start=/:/ end=/[,}]\@=/ contains=@mcExpression extend
" syntax match   mcObjectFuncName    contained /\<\K\k*\ze\_s*(/ skipwhite skipempty nextgroup=mcFuncArgs
" syntax match   mcFunctionKey       contained /\<\K\k*\ze\s*:\s*function\>/
" syntax match   mcObjectMethodType  contained /\<[gs]et\ze\s\+\K\k*/ skipwhite skipempty nextgroup=mcObjectFuncName
" syntax region  mcObjectStringKey   contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=mcSpecial extend skipwhite skipempty nextgroup=mcFuncArgs,mcObjectValue
"
syntax keyword mcNull      null
syntax keyword mcReturn    return contained skipwhite nextgroup=@mcExpression
"
" Statement Keywords
syntax keyword mcStatement     contained break continue skipwhite skipempty nextgroup=mcBlockLabelKey
syntax keyword mcConditional            if              skipwhite skipempty nextgroup=mcParenIfElse
syntax keyword mcConditional            else            skipwhite skipempty nextgroup=mcCommentIfElse,mcIfElseBlock
syntax keyword mcConditional            switch          skipwhite skipempty nextgroup=mcParenSwitch
syntax keyword mcRepeat                 while for       skipwhite skipempty nextgroup=mcParenRepeat,mcForAwait
syntax keyword mcDo                     do              skipwhite skipempty nextgroup=mcRepeatBlock
syntax region  mcSwitchCase   contained matchgroup=mcLabel start=/\<\%(case\|default\)\>/ end=/:\@=/ contains=@mcExpression,mcLabel skipwhite skipempty nextgroup=mcSwitchColon keepend
syntax keyword mcTry                    try             skipwhite skipempty nextgroup=mcTryCatchBlock
syntax keyword mcFinally      contained finally         skipwhite skipempty nextgroup=mcFinallyBlock
syntax keyword mcCatch        contained catch           skipwhite skipempty nextgroup=mcParenCatch,mcTryCatchBlock
syntax keyword mcException              throw
syntax match   mcSwitchColon   contained /::\@!/        skipwhite skipempty nextgroup=mcSwitchBlock

" Code blocks
syntax region  mcBracket                      matchgroup=mcBrackets            start=/\[/ end=/\]/ contains=@mcExpression,mcSpreadExpression extend fold
syntax region  mcParen                        matchgroup=mcParens              start=/(/  end=/)/  contains=@mcExpression extend fold nextgroup=mcFlowDefinition
syntax region  mcParenDecorator     contained matchgroup=mcParensDecorator     start=/(/  end=/)/  contains=@mcAll extend fold
syntax region  mcParenIfElse        contained matchgroup=mcParensIfElse        start=/(/  end=/)/  contains=@mcAll skipwhite skipempty nextgroup=mcCommentIfElse,mcIfElseBlock,mcReturn extend fold
syntax region  mcParenRepeat        contained matchgroup=mcParensRepeat        start=/(/  end=/)/  contains=@mcAll skipwhite skipempty nextgroup=mcCommentRepeat,mcRepeatBlock,mcReturn extend fold
syntax region  mcParenSwitch        contained matchgroup=mcParensSwitch        start=/(/  end=/)/  contains=@mcAll skipwhite skipempty nextgroup=mcSwitchBlock extend fold
syntax region  mcParenCatch         contained matchgroup=mcParensCatch         start=/(/  end=/)/  skipwhite skipempty nextgroup=mcTryCatchBlock extend fold
" syntax region  mcFuncArgs           contained matchgroup=mcFuncParens          start=/(/  end=/)/  contains=mcFuncArgCommas,mcComment,mcFuncArgExpression,mcDestructuringBlock,mcDestructuringArray,mcRestExpression,mcFlowArgumentDef skipwhite skipempty nextgroup=mcCommentFunction,mcFuncBlock,mcFlowReturn extend fold
syntax region  mcClassBlock         contained matchgroup=mcClassBraces         start=/{/  end=/}/  contains=mcFunction,mcClassMethodType,mcArrowFunction,mcArrowFuncArgs,mcComment,mcGenerator,mcDecorator,mcClassProperty,mcClassPropertyComputed,mcClassStringKey,@mcVariable,mcVariableDef,mcNoise extend fold
syntax region  mcFuncBlock          contained matchgroup=mcFuncBraces          start=/{/  end=/}/  contains=@mcAll,mcBlock extend fold
syntax region  mcIfElseBlock        contained matchgroup=mcIfElseBraces        start=/{/  end=/}/  contains=@mcAll,mcBlock extend fold
syntax region  mcTryCatchBlock      contained matchgroup=mcTryCatchBraces      start=/{/  end=/}/  contains=@mcAll,mcBlock skipwhite skipempty nextgroup=mcCatch,mcFinally extend fold
syntax region  mcFinallyBlock       contained matchgroup=mcFinallyBraces       start=/{/  end=/}/  contains=@mcAll,mcBlock extend fold
syntax region  mcSwitchBlock        contained matchgroup=mcSwitchBraces        start=/{/  end=/}/  contains=@mcAll,mcBlock,mcSwitchCase extend fold
syntax region  mcRepeatBlock        contained matchgroup=mcRepeatBraces        start=/{/  end=/}/  contains=@mcAll,mcBlock extend fold
" syntax region  mcObject             contained matchgroup=mcObjectBraces        start=/{/  end=/}/  contains=mcObjectKey,mcObjectKeyString,mcObjectKeyComputed,mcObjectShorthandProp,mcObjectSeparator,mcObjectFuncName,mcObjectMethodType,mcGenerator,mcComment,mcObjectStringKey,mcSpreadExpression,mcDecorator,mcTemplateString extend fold
syntax region  mcBlock                        matchgroup=mcBraces              start=/{/  end=/}/  contains=@mcAll,mcSpreadExpression extend fold

syntax match   mcFuncName             contained /\<\K\k*/ skipwhite skipempty nextgroup=mcFuncArgs,mcFlowFunctionGroup
" syntax region  mcFuncArgExpression    contained matchgroup=mcFuncArgOperator start=/=/ end=/[,)]\@=/ contains=@mcExpression extend
" syntax match   mcFuncArgCommas        contained ','
" syntax keyword mcArguments            contained arguments

syntax match mcFunction /\<function\>/      skipwhite skipempty nextgroup=mcGenerator,mcFuncName,mcFuncArgs,mcFlowFunctionGroup skipwhite

" Classes
syntax keyword mcClassKeyword           contained class
syntax keyword mcExtendsKeyword         contained extends skipwhite skipempty nextgroup=@mcExpression
syntax match   mcClassNoise             contained /\./
syntax region  mcClassDefinition        start=/\<class\>/ end=/\(\<extends\>\s\+\)\@<!{\@=/ contains=mcClassKeyword,mcExtendsKeyword,mcClassNoise,@mcExpression skipwhite skipempty nextgroup=mcCommentClass,mcClassBlock,mcFlowClassGroup

" Comments
syntax keyword mcCommentTodo    contained TODO FIXME XXX TBD NOTE
syntax region  mcComment        start=+//+ end=/$/ contains=mcCommentTodo,@Spell extend keepend
syntax region  mcComment        start=+/\*+  end=+\*/+ contains=mcCommentTodo,@Spell fold extend keepend
"
" Specialized Comments - These are special comment regexes that are used in
" odd places that maintain the proper nextgroup functionality. It sucks we
" can't make mcComment a skippable type of group for nextgroup
" syntax region  mcCommentFunction    contained start=+//+ end=/$/    contains=mcCommentTodo,@Spell skipwhite skipempty nextgroup=mcFuncBlock,mcFlowReturn extend keepend
" syntax region  mcCommentFunction    contained start=+/\*+ end=+\*/+ contains=mcCommentTodo,@Spell skipwhite skipempty nextgroup=mcFuncBlock,mcFlowReturn fold extend keepend
" syntax region  mcCommentClass       contained start=+//+ end=/$/    contains=mcCommentTodo,@Spell skipwhite skipempty nextgroup=mcClassBlock,mcFlowClassGroup extend keepend
" syntax region  mcCommentClass       contained start=+/\*+ end=+\*/+ contains=mcCommentTodo,@Spell skipwhite skipempty nextgroup=mcClassBlock,mcFlowClassGroup fold extend keepend
" syntax region  mcCommentIfElse      contained start=+//+ end=/$/    contains=mcCommentTodo,@Spell skipwhite skipempty nextgroup=mcIfElseBlock extend keepend
" syntax region  mcCommentIfElse      contained start=+/\*+ end=+\*/+ contains=mcCommentTodo,@Spell skipwhite skipempty nextgroup=mcIfElseBlock fold extend keepend
" syntax region  mcCommentRepeat      contained start=+//+ end=/$/    contains=mcCommentTodo,@Spell skipwhite skipempty nextgroup=mcRepeatBlock extend keepend
" syntax region  mcCommentRepeat      contained start=+/\*+ end=+\*/+ contains=mcCommentTodo,@Spell skipwhite skipempty nextgroup=mcRepeatBlock fold extend keepend

syntax cluster mcExpression  contains=mcBracket,mcParen,mcObject,mcTernaryIf,mcTaggedTemplate,mcTemplateString,mcString,mcChar,mmcRegexpString,mcNumber,mcFloat,mcOperator,mcOperatorKeyword,mcBooleanTrue,mcBooleanFalse,mcNull,mcFunction,mcArrowFunction,mcGlobalObjects,mcExceptions,mcFutureKeys,mcDomErrNo,mcDomNodeConsts,mcHtmlEvents,mcFuncCall,mcUndefined,mcNan,mcPrototype,mcBuiltins,mcNoise,mcClassDefinition,mcArrowFunction,mcArrowFuncArgs,mcParensError,mcComment,mcArguments,mcThis,mcSuper,mcDo,mcForAwait,mcAsyncKeyword,mcStatement,mcDot
syntax cluster mcAll         contains=@mcExpression,mcVariable,mcConditional,mcRepeat,mcReturn,mcException,mcTry,mcNoise,@mcVariable

hi def link mcComment              Comment
hi def link mcParensIfElse         mcParens
hi def link mcParensRepeat         mcParens
hi def link mcParensSwitch         mcParens
hi def link mcParensCatch          mcParens
hi def link mcCommentTodo          Todo
hi def link mcString               String
hi def link mcChar                 Character
" hi def link mcObjectKeyString      String
" hi def link mcTemplateString       String
" hi def link mcObjectStringKey      String
" hi def link mcClassStringKey       String
hi def link mcConditional          Conditional
hi def link mcLabel                Label
hi def link mcReturn               Statement
hi def link mcRepeat               Repeat
hi def link mcDo                   Repeat
hi def link mcStatement            Statement
hi def link mcException            Exception
hi def link mcTry                  Exception
hi def link mcFinally              Exception
hi def link mcCatch                Exception
hi def link mcFunction             Type
hi def link mcFuncName             Function
" hi def link mcFuncCall             Function
" hi def link mcClassFuncName        mcFuncName
" hi def link mcObjectFuncName       Function
" hi def link mcArguments            Special
hi def link mcOperatorKeyword      mcOperator
hi def link mcOperator             Operator
hi def link mcVariableVar         StorageClass
hi def link mcClassKeyword         Keyword
hi def link mcExtendsKeyword       Keyword
hi def link mcNull                 Type
hi def link mcNumber               Number
hi def link mcFloat                Float
hi def link mcBooleanTrue          Boolean
hi def link mcBooleanFalse         Boolean
" hi def link mcObjectColon          mcNoise
hi def link mcNoise                Noise
" hi def link mcDot                  Noise
hi def link mcBrackets             Noise
hi def link mcParens               Noise
hi def link mcBraces               Noise
" hi def link mcFuncBraces           Noise
" hi def link mcFuncParens           Noise
hi def link mcClassBraces          Noise
hi def link mcClassNoise           Noise
hi def link mcIfElseBraces         Noise
hi def link mcTryCatchBraces       Noise
" hi def link mcModuleBraces         Noise
" hi def link mcObjectBraces         Noise
" hi def link mcObjectSeparator      Noise
hi def link mcFinallyBraces        Noise
hi def link mcRepeatBraces         Noise
hi def link mcSwitchBraces         Noise
" hi def link mcSpecial              Special
hi def link mcUsing               Include
hi def link mcUsingModule         StorageClass
hi def link mcUsingAs             Include
hi def link mcUsingModuleAlias    StorageClass


" hi def link mcFuncArgOperator      mcFuncArgs
hi def link mcSwitchColon          Noise
hi def link mcClassDefinition      mcFuncName
"
" hi def link mcCommentFunction      mcComment
" hi def link mcCommentClass         mcComment
" hi def link mcCommentIfElse        mcComment
" hi def link mcCommentRepeat        mcComment

let b:current_syntax = "monkeyc"
if main_syntax == 'monkeyc'
  unlet main_syntax
endif

map <f12> :echo synIDattr(synID(line("."),col("."),1),"name")<cr>
