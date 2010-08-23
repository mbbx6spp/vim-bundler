" File:         bundler.vim
" Description:  A NERDTree plugin to execute the Bundler project files inside Vim
" Maintainer:   Susan Potter <meNOSPAM@susanpotter.net>
" Last Change:  2010-08-19
" Name:         bundler
" Version:      0.1
" License:      Charityware license


" Adds a submenu to the NERD tree menu if a Bundler Gemfile exists in the root.
if exists("g:loaded_nerdtree_bundler_menu")
  finish
endif
let g:loaded_nerdtree_bundler_menu = 1

call NERDTreeAddMenuItem({
  \ 'text': 'Bundler (C)heck', 
  \ 'shortcut': 'C',
  \ 'isActiveCallback': 'NERDTreeBundlerMenuEnabled',
  \ 'callback': 'NERDTreeBundlerCheck' })
call NERDTreeAddMenuItem({
  \ 'text': 'Bundler (I)nstall', 
  \ 'shortcut': 'I',
  \ 'isActiveCallback': 'NERDTreeBundlerMenuEnabled',
  \ 'callback': 'NERDTreeBundlerInstall' })

function NERDTreeBundlerMenuEnabled()
  return filereadable(s:GemfilePath())
endfunction

function s:GemfilePath()
  let gemfilePath = fnamemodify(b:NERDTreeRoot.path.str(), ":p") . "/Gemfile"
  return gemfilePath
endfunction

function NERDTreeBundlerCheck()
  call bundler#Execute('check')
endfunction

function NERDTreeBundlerInstall()
  call bundler#Execute('install')
endfunction

