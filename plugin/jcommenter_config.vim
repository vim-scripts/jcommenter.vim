" Configuration file for jcommenter
"
" Copy the necessary contents from this file to your .vimrc, or modify this
" file and add a source command to vimrc to read this file.

" map the commenter:
map <M-c> :call JCommentWriter()<CR>

" Move cursor to the place where inserting comments supposedly should start
let b:jcommenter_move_cursor = 1

" Defines whether to move the cursor to the line which has "/**", or the line
" after that (effective only if b:jcommenter_move_cursor is enabled)
let b:jcommenter_description_starts_from_first_line = 0

" Start insert mode after calling the commenter. Effective only if 
" b:jcommenter_move_cursor is enabled.
let b:jcommenter_autostart_insert_mode = 1

" The number of empty rows (containing only the star) to be added for the 
" description of the method
let b:jcommenter_method_description_space = 2

" The number of empty rows (containing only the star) to be added for the´
" description of the field. Can be also -1, which means that "/**  */" is added
" above the field declaration 
let b:jcommenter_field_description_space = 1

" The number of empty rows (containing only the star) to be added for the 
" description of the class
let b:jcommenter_class_description_space = 2

" If this option is enabled, and a method has no exceptions, parameters or
" return value, the space for the description of that method is allways one
" row. This is handy if you want to keep an empty line between the description
" and the tags (as is defined in Sun's java code conventions)
let b:jcommenter_smart_method_description_spacing = 1

" the default content for the author-tag of class-comments. Leave empty to add
" just the empty tag, or outcomment to prevent author tag generation
let b:jcommenter_class_author = ''

" the default content for the version-tag of class-comments. Leave empty to add
" just the empty tag, or outcomment to prevent version tag generation
let b:jcommenter_class_version = ''

" The default author added to the file comments. leave empty to add just the
" field where the autor can be added, or outcomment to remove it.
let b:jcommenter_file_author = ''

" The default copyright holder added to the file comments. leave empty to
" add just the field where the copyright info can be added, or outcomment
" to remove it.
let b:jcommenter_file_copyright = ''

" set to true if you don't like the automatically added "created"-time
let b:jcommenter_file_noautotime = 0 

" Uncomment and modify if you're not happy with the default file
" comment-template:
"function! JCommenter_OwnFileComments()
"  call append(0, '/* File name   : ' . bufname("%"))
"  call append(1, ' * authors     : ')
"  call append(2, ' * created     : ' . strftime("%c"))
"  call append(3, ' *')
"  call append(4, ' */')
"endfunction
  
