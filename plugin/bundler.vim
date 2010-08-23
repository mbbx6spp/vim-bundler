" Vim global plugin for Bundler
" Last Change:  2010 August 02
" Name:         Bundler
" Maintainer:   Susan Potter <meNOSPAM@susanpotter.net>
" License:      This plugin is licensed under the MIT license.

if exists("loaded_bundler")
  finish
endif
let loaded_bundler = 1

let cpoOriginal = &cpo
set cpo&vim

augroup bundlerPlugin
  autocmd!
  autocmd QuickfixCmdPost make* call bundler#ConvertErrorMessages()
  autocmd BufNewFile,BufRead Gemfile call bundler#SetupBufCommands()
  autocmd BufEnter * call <SID>EnableBundlerPlugin()
augroup END

function s:EnableBundlerPlugin()
  let gemfilePath = findfile("Gemfile", getcwd())
  if filereadable(gemfilePath)
    call bundler#SetupBufCommands()
    silent doautocmd bundlerPlugin
  endif
endfunction

call s:EnableBundlerPlugin()

" Default key map
if !hasmapto('<Plug>Bundle')
    map <unique> <Leader>B <Plug>Bundle
endif

let &cpo = cpoOriginal
unlet cpoOriginal
