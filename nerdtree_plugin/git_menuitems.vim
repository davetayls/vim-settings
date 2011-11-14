" ============================================================================
" File:        git_menuitems.vim
" Description: plugin for NERD Tree that provides basic git commands
" Maintainer:  Dave Taylor
" License:     MIT http://www.opensource.org/licenses/mit-license.php
" ============================================================================
if exists("g:loaded_nerdtree_git_menuitems")
    finish
endif
let g:loaded_nerdtree_git_menuitems = 1

" GIT PULL
call NERDTreeAddMenuItem({
            \ 'text': '(p) Git Pull',
            \ 'shortcut': 'p',
            \ 'callback': 'NERDTreeGitPull'})

function! NERDTreeGitPull()
    let treenode = g:NERDTreeFileNode.GetSelected()
    let cmd = "\"cd " . treenode.path.str() . " && git pull\""
    if cmd != ''
        exec ':!' . cmd
    else
        echo "Aborted"
    endif
endfunction

" GIT Commit
call NERDTreeAddMenuItem({
            \ 'text': '(C) Git Commit',
            \ 'shortcut': 'C',
            \ 'callback': 'NERDTreeGitCommit'})

function! NERDTreeGitCommit()
    let treenode = g:NERDTreeFileNode.GetSelected()
    echo "==========================================================\n"
    echo "Complete the command to execute (add arguments etc):\n"
    let cmd = "cd " . treenode.path.str() . " && git commit -am"
    let cmd = input(':!', cmd . ' ')
    
    if cmd != ''
        exec ':! "' . cmd . "\""
    else
        echo "Aborted"
    endif
endfunction

" GIT Push
call NERDTreeAddMenuItem({
            \ 'text': '(P) Git Push',
            \ 'shortcut': 'P',
            \ 'callback': 'NERDTreeGitPush'})

function! NERDTreeGitPush()
    let treenode = g:NERDTreeFileNode.GetSelected()
    echo "==========================================================\n"
    echo "Complete the command to execute (add arguments etc):\n"
    let cmd = "cd " . treenode.path.str() . " && git push"
    let cmd = input(':!', cmd . ' ')
    
    if cmd != ''
        exec ':! "' . cmd . "\""
    else
        echo "Aborted"
    endif
endfunction
