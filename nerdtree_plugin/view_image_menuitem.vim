"guard against sourcing the script twice
if exists("g:loaded_nerdtree_view_image_menuitem")
    finish
endif
let g:loaded_nerdtree_view_image_menuitem = 1

"if eog isnt installed, bail
if !executable("eog")
    finish
endif

"add a menu separator (a row of dashes) before our new menu item
call NERDTreeAddMenuSeparator({
    \ 'isActiveCallback': 'NERDTreeViewImageMenuitemEnabled'})

"add the main menu item
call NERDTreeAddMenuItem({
    \ 'text': '(v)iew image',
    \ 'shortcut': 'v',
    \ 'isActiveCallback': 'NERDTreeViewImageMenuitemEnabled',
    \ 'callback': 'NERDTreeViewImageMenuItem' })

"we only want the menu item to be displayed if the current
"node is an image file
function! NERDTreeViewImageMenuitemEnabled()
    let p = g:NERDTreeFileNode.GetSelected().path
    return !p.isDirectory &&
         \ p.str() =~ '\c\.\(jpeg\|jpg\|gif\|png\|bmp\|tiff\)$'
endfunction

"open the file the cursor is on in eog
function! NERDTreeViewImageMenuItem()
    let n = g:NERDTreeFileNode.GetSelected()
    let p = n.path.str({'escape': 1})
    call system("eog " . p . "&")
endfunction
