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

call bundler#SetupBufCommands()

let &cpo = cpoOriginal
unlet cpoOriginal
