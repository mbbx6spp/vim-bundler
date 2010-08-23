" Vim Bundler autoload
" Name:		      Bundler
" Maintainer:   Susan Potter <me [at] susanpotter [dot] net>
" Last Change:  02 Aug 2010

" Public functions

" Retrieve error format for a specific subcommand
function bundler#ErrorFormatFor(subCmd)
  let subCmd = a:subCmd
  let errorFormats = {}
  let errorFormats['check'] = "  * %m (%s)"
  let errorFormats['install'] = "Could not find gem '%m (%t, %s)' in any of the gem sources."
  let errorFormats['help'] = ""
  return errorFormats[subCmd]
endfunction

" Execute the bundle command
function bundler#Execute(subCmd)
  let subCmd = a:subCmd
  let makeprgOriginal = &l:makeprg
  let errorformatOriginal = &l:errorformat
  try
    let &l:makeprg = 'bundle'
    let &l:errorformat = bundler#ErrorFormatFor(subCmd)
    exec 'make '.subCmd
    copen
  finally
    let &l:errorformat = errorformatOriginal
    let &l:makeprg = makeprgOriginal
  endtry
endfunction

" Converts error message format to something more readable
function bundler#ConvertErrorMessages()
  if &l:makeprg =~ 'bundle'
    let quickfixList = getqflist()
    let gemfile = findfile("Gemfile", getcwd())
    let bufferNumber = bufnr(gemfile, 1)
    " Only show valid quickfix lines in output
    call filter(quickfixList, 'v:val.valid')
    for line in quickfixList
      let line.bufnr = bufferNumber
      let line.type = matchstr(line.pattern, '(.*?, [a-zA-Z0-9-_]*?)')
      let line.gem = line.text
      let line.pattern = "gem[( ][\"']".line.gem
    endfor
    " filter to remove unnecessary quickfix line output
    call filter(quickfixList, 'v:val.text !~ "Warning:"')
    call setqflist(quickfixList)
  endif
endfunction


" Auto-complete all available subcommands for bundle
function bundler#AutoCompleteSubcommands(ArgLead, CmdLine, CursorPos)
  if !exists('g:bundlerSubcommands')
    try
      let lines = split(system("bundle -h"), "\n")
    endtry
    if v:shell_error != 0
      return []
    endif
    call map(lines, 'matchstr(v:val, "  bundle\\s\\+\\zs\\S*")')
    call filter(lines, 'v:val != ""')
    let g:bundlerSubcommands = lines
  endif
  let matches = copy(g:bundlerSubcommands)
  let condition = 'v:val =~ "^' . a:ArgLead . '"'
  call filter(matches, condition)
  return matches
endfunction

" Setup buffer commands
function bundler#SetupBufCommands()
  command! -buffer -nargs=1 -complete=customlist,bundler#AutoCompleteSubcommands Bundle call bundler#Execute(<q-args>)
endfunction

"vim: ft=vim
