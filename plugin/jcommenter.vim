" NOTE: Here begins the configuration script for the JCommenter. I Have merged
" it into the script because vim.sourceforge.net's download function seems 
" to rename the file allways to "jcommenter.vim", so using a .zip or .tar-file
" would cause unnecessary confusion. It is a good idea to copy-paste the
" configuration part to another file, as you might want to preserve it for
" the next version.
" See below for the real script description

" --- cut here (configuration) ---

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

" Change this to true, if you want to use "@exception" instead of "@throws".
let b:jcommenter_use_exception_tag = 1

" set to true if you don't like the automatically added "created"-time
let b:jcommenter_file_noautotime = 0 

" define whether jcommenter tries to parse and update the existing Doc-comments
" on the item it was executed on. If this feature is disabled, a completely new
" comment-template is written
let b:jcommenter_update_comments = 1

" define wheter jcommenter should remove old tags (eg. if the return value was
" changed from int to void). At this point, this works only on @return-tag as
" there can exist only on return-tag, and thus it was easy to implement. This
" feature (as the other new features) is not throughly tested, and might delete
" something it was not supposed to, so use with care. Only applicable if 
" b:jcommenter_update_comments is enabled.
let b:jcommenter_remove_tags_on_update = 0

" Uncomment and modify if you're not happy with the default file
" comment-template:
"function! JCommenter_OwnFileComments()
"  call append(0, '/* File name   : ' . bufname("%"))
"  call append(1, ' * authors     : ')
"  call append(2, ' * created     : ' . strftime("%c"))
"  call append(3, ' *')
"  call append(4, ' */')
"endfunction

" --- cut here (configuration) ---

" File: jcommenter.vim
" Summary: Functions for documenting java-code
" Author: Kalle Björklid <bjorklid@st.jyu.fi>
" Last Modified: 14.8.2001
" Version: 1.11
" Modifications:
"  1.11: Fixed a bug where the end part of the whole buffer was sometimes
"        deleted when updating w/ the b:jcommenter_remove_tags_on_update
"        enabled.
"  1.1 : Can now choose between '@throws' and '@exception' tags.
"        When executed on single-line comments ("/** blah blah */") expands
"            them into multiline comments preserving the text
"        Partial method documentation comment updating (see below for
"            description) At this point, there's a behavoiur fault where
"            single-line comments get expanded even if there's no tags to add.
"  1.0 : Did a complete rewrite of the script-code (this is the main reason
"            for the version-number leap)
"        A separate config-file, which should be modified to reflect the
"            user's preferences
"        More variables for better customization
"        Due to the rewrite, should now be more robust (allthough new bugs
"            may have been introduced during the process)
"        Cursor movement and auto-start insert mode
"        Better control over the look of the comment templates
"        See installation instructions below (has changed)
"  0.4 : Recognizes now methods that have whitespaces before the '('.
"        The file comments can now be completely redefined (see below for
"            instructions) without editing the script.
"        The comment-skeleton for fields is changed from '/**  */ to correspond
"            with the Sun's code conventions:
"            /**
"             *
"             */
"  0.3 : Added tag copying
"        Recognizes interfaces (same as classes)
"  0.21: Improved the java-method recognition.
"  0.2 : initial public release.
" 
" Tested on Vim 6.0ap on Win32
"
" Description: Functions for automatically generating JavaDoc compatible
" documentation for java source-files.
" The JCommentWriter() can produce four kinds of comments depending on the
" current line/range.
" - File comments. When the JCommentWriter()-function is called on the first
"   line of the file, a template for file comments is created. It looks like
"   this:
"
"       /*  Filename : <name of current buffer>
"        *  Author   : <author>
"        *  Summary  :
"        *  Version  :
"        *  Created  : <current system time>
"        */
"
"   The file name and 'Created'-date are automatically filled. The author-
"   field is filled with the contents of 'b:jcommenter_file_author'-variable.
"   The automated date insertion can be prevented by defining the
"   'b:jcommenter_file_noautotime'-variable.
"   You can redefine completely the file comments-writer-function. See the
"   configuration script for more info
"
" - Class comments. When the JCommentWriter()-function is called on the
"   header of a class, a template for class comments is created. It looks like
"   this:
"
" 	/**
"	 *
"	 * @author <author>
"	 * @version <version> 
"	 */
"	public class ClassName { ...
"
"   The @author-field is automatically filled with the contents of the
"   'b:jcommenter_class_author'-variable.
"   The @version-field is automatically filled with the contents of the
"   'b:jcommenter_class_def_version'-variable
" - Method comments. JCommentWriter()-function automatically generates
"   the template for method comments if it is called on a header of a
"   method. The JavaDoc-tags are automatically generated by detecting
"   the parameter names, return value and exceptions that are declared
"   in the header of the method. An example:
"
"	/**
"	 *
"	 * @param numbers
"	 * @param str
"	 * @return 
" 	 * @throws IOException
"	 * @throws NumberFormatException
"	 */
"	public String [] method(Integer[] numbers, String str) throws 
"				IOException, NumberFormatException { 
"
"   Note: since the method header is on two lines, you need to specify
"   the range (include everything before the '{', or ';' if the method is
"   abstract). This can be done simply with line-wise visual selection.
" - Updating method comments (since 1.1):
"   If executed on a method declaration that allready has Doc-comments,
"   you can let jcommenter to try to parse the existing comments and
"   add the tags that are new (for example, if you have declared another
"   exception to be thrown) to the comments. At this time (version 1.1) 
"   the removing of old tags is limited to the @return-tag.
"   See the config-script for variables concerning this feature.
" - Field comments. Appends this above the field declaration:
"        /**
"         *
"         */
"   Can also be changed to '/**  */', see the config-file.
" - Extending single-line comments into mulitline:
"   When executed on a line like '/** blah blah blah */, the result is:
"        /**
"         * blah balh blah
"         */
" - When executed on an existing JavaDoc tag, copy that tag under that line.
"   For example, when executed on the following line:
"      * @throws IOException If cannot read file
"   the result is:
"      * @throws IOException If cannot read file
"      * @throws
"   Not that life changing, but quite nice when you want to document those
"   RuntimeExceptions, or need to add another paramter.
"
" Installation:
" 
" 0. (optional) copy-paste the configuration-part above to another file
"    (save it somewhere)
" 1. Edit the config-section. It is commented, so I won't explain the
"    options here).
" 2. Put something like
"      autocmd FileType java source $VIM/macros/jcommenter_config.vim
"      aurocmd FileType java source $VIM/macros/jcommenter.vim
"    to your vimrc
"
" Usage:
" If you didn't change the mapping specified in the config-file, you can
" can trigger the comment-generation by pressing Alt-c (or "Meta-c"). As
" described above, the cursor must be on the first line or on the same line
" as the method/class/attribute declaration in order to achieve something 
" useful. If the declaration extends to several lines, the range must be 
" specified.  Range should include everything from the declaration that 
" comes before the '{' or ';'. Everything after either of those characters 
" is ignored, so linewise selection is a handy way to do this (<shift-v>)
"
" Notes: 
"  - If a method name starts with an uppercase letter, it is handled as a
"    constructor (no @return-tag is generated)
"
" TODO: better recognition for constructors
" TODO: support for the umlaut-chars etc. that can be also used in java
" TODO: Inner classes/interfaces...
" TODO: Recognise and update old method comments.
" TODO: sort exceptions alphabetically (see
"       http://java.sun.com/j2se/javadoc/writingdoccomments/index.html)
" TODO: comment the script
" TODO: unspaghettify the update-part of the script 
"
" Comments:
" Send any comments or bugreports to bjorklid@st.jyu.fi
" Happy coding!  ;-)
"=====================================================================


" THE SCRIPT
"
"
" varible that tells what is put before the written string when using
" the AppendStr-function.
let s:indent = ''

" The string that includes the text of the line on which the commenter
" was called, or the whole range. This is what is parsed.
let s:combinedString = ''

let s:rangeStart = 1 " line on which the range started
let s:rangeEnd = 1   " line on which the range ended

let s:defaultMethodDescriptionSpace = 1
let s:defaultFieldDescriptionSpace = 1
let s:defaultClassDescriptionSpace = 1

let s:linesAppended = 0 " this counter is increased when the AppendStr-method
                        " is called.

let s:docCommentStart = -1
let s:docCommentEnd   = -1

" ===================================================
" Public functions
" ===================================================

function! JCommentWriter() range
  let s:rangeStart = a:firstline
  let s:rangeEnd = a:lastline
  let s:combinedString = s:GetCombinedString(s:rangeStart, s:rangeEnd)

  if s:IsFileComments()
    call s:WriteFileComments()
  elseif s:IsMethod()
    call s:WriteMethodComments()
  elseif s:IsClass()
    call s:WriteClassComments()
  elseif s:IsSinglelineComment()
    call s:ExpandSinglelineComments(s:rangeStart)
  elseif s:IsCommentTag()
    call s:WriteCopyOfTag()
  elseif s:IsVariable()
    call s:WriteFieldComments()
  endif
endfunction

" ===================================================
" The update functions for method comments
" ===================================================

function! s:UpdateAllTags()
  "call s:ResolveMethodParams(s:combinedString)
  let s:indent = s:GetIndentation(s:combinedString)
  call s:UpdateParameters()
  call s:UpdateReturnValue()
  call s:UpdateExceptions()
endfunction

function! s:UpdateExceptions()
  let exceptionName = s:GetNextThrowName()
  let seeTagPos = s:FindTag(s:docCommentStart, s:docCommentEnd, 'see', '')
  if seeTagPos > -1
    let tagAppendPos = seeTagPos - 1
  else
    let tagAppendPos = s:docCommentEnd - 1
  endif 
  while exceptionName != ''
    let tagPos = s:FindTag(s:docCommentStart, s:docCommentEnd, 'throws', exceptionName)
    if tagPos < 0
      let tagPos = s:FindTag(s:docCommentStart, s:docCommentEnd, 'exception', exceptionName)
    endif
    if tagPos > -1
      let tagAppendPos = tagPos
      let exceptionName = s:GetNextThrowName()
      continue
    endif
    let s:appendPos = tagAppendPos
    call s:AppendStr(' * @throws ' . exceptionName . ' ')
    call s:MarkUpdateMade(tagAppendPos + 1)
    let s:docCommentEnd = s:docCommentEnd + 1
    let tagAppendPos = tagAppendPos + 1
    let tagName = s:GetNextParameterName()
  endwhile
endfunction

function! s:UpdateReturnValue()
  if s:method_returnValue == ''
    if exists("b:jcommenter_remove_tags_on_update") && b:jcommenter_remove_tags_on_update
      call s:RemoveTag(s:docCommentStart, s:docCommentEnd, 'return', '')
    endif
    return
  endif
  let returnTagPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'return')
  if returnTagPos > -1 && s:method_returnValue != ''
    return
  endif
  let tagAppendPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'throws') - 1
  if tagAppendPos < 0
    let tagAppendPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'exception') - 1
  endif
  if tagAppendPos < 0
    let tagAppendPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'see') - 1
  endif
  if tagAppendPos < 0
    let tagAppendPos = s:docCommentEnd - 1
  endif
  let s:appendPos = tagAppendPos
  call s:AppendStr(' * @return ')
  call s:MarkUpdateMade(tagAppendPos + 1)
  let s:docCommentEnd = s:docCommentEnd + 1
endfunction

function! s:UpdateParameters()
  let tagName = s:GetNextParameterName()
  let tagAppendPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'param') - 1
  if tagAppendPos < 0
    let tagAppendPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'return') - 1
  endif
  if tagAppendPos < 0
    let tagAppendPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'throws') - 1
  endif
  if tagAppendPos < 0
    let tagAppendPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'exception') - 1
  endif
  if tagAppendPos < 0
    let tagAppendPos = s:FindFirstTag(s:docCommentStart, s:docCommentEnd, 'see') - 1
  endif
  if tagAppendPos < 0 
    let tagAppendPos = s:docCommentEnd - 1
  endif
  while tagName != ''
    let tagPos = s:FindTag(s:docCommentStart, s:docCommentEnd, 'param', tagName)
    if tagPos > -1
      let tagAppendPos = tagPos
      let tagName = s:GetNextParameterName()
      continue
    endif
    let s:appendPos = tagAppendPos
    call s:AppendStr(' * @param ' . tagName . ' ')
    call s:MarkUpdateMade(tagAppendPos + 1)
    let s:docCommentEnd = s:docCommentEnd + 1
    let tagAppendPos = tagAppendPos + 1
    let tagName = s:GetNextParameterName()
  endwhile
endfunction

function! s:FindTag(rangeStart, rangeEnd, tagName, tagParam)
  let i = a:rangeStart
  while i <= a:rangeEnd
    if getline(i) =~ '^\s*\(\*\s*\)\=@' . a:tagName . '\s\+' . a:tagParam
      return i
    endif
    let i = i + 1
  endwhile
  return -1
endfunction

function! s:FindFirstTag(rangeStart, rangeEnd, tagName)
  let i = a:rangeStart
  while i <= a:rangeEnd
    if getline(i) =~ '^\s*\(\*\s*\)\=@' . a:tagName . '\(\s\|$\)'
      return i
    endif
    let i = i + 1
  endwhile
  return -1
endfunction

function! s:FindAnyTag(rangeStart, rangeEnd)
  let i = a:rangeStart
  while i <= a:rangeEnd
    if getline(i) =~ '^\s*\(\*\s*\)\=@'
      return i
    endif
    let i = i + 1
  endwhile
  return -1
endfunction

function! s:RemoveTag(rangeStart, rangeEnd, tagName, tagParam)
  let tagStartPos = s:FindTag(a:rangeStart, a:rangeEnd, a:tagName, a:tagParam)
  if tagStartPos == -1
    return 0
  endif
  let tagEndPos = s:FindAnyTag(tagStartPos + 1, a:rangeEnd)
  if tagEndPos == -1
    let tagEndPos = s:docCommentEnd - 1
  endif
  let linesToDelete = tagEndPos - tagStartPos
  exe "normal " . tagStartPos . "G" . linesToDelete . "dd"
  let s:docCommentEnd = s:docCommentEnd - linesToDelete
endfunction

function! s:MarkUpdateMade(linenum)
  if s:firstUpdatedTagLine == -1 || a:linenum < s:firstUpdatedTagLine
    let s:firstUpdatedTagLine = a:linenum
  endif
endfunction

" ===================================================
" From single line to multi line
" ===================================================

function! s:ExpandSinglelineCommentsEx(line, space)
  let str = getline(a:line)
  let singleLinePattern = '^\s*/\*\*\s*\(.*\)\*/\s*$'
  if str !~ singleLinePattern
    return
  endif
  let s:indent = s:GetIndentation(str)
  let str = substitute(str, singleLinePattern, '\1', '')
  exe "normal " . a:line . "Gdd"
  let s:appendPos = a:line - 1
  call s:AppendStr('/**')
  call s:AppendStr(' * ' . str)
  let i = 0
  while a:space > i
    call s:AppendStr(' * ')
    let i = i + 1
  endwhile
  call s:AppendStr(' */')
  let s:docCommentStart = a:line
  let s:docCommentEnd   = a:line + 2 + a:space
endfunction

function! s:ExpandSinglelineComments(line)
  call s:ExpandSinglelineCommentsEx(a:line, 0)
endfunction

" ===================================================
" Functions for writing the comments 
" ===================================================

function! s:WriteMethodComments()
  call s:ResolveMethodParams(s:combinedString)
  let s:appendPos = s:rangeStart - 1
  let s:indent = s:method_indent
  let s:linesAppended = 0

  let existingDocCommentType = s:HasDocComments()
  
  if existingDocCommentType && exists("b:jcommenter_update_comments") && b:jcommenter_update_comments
    if existingDocCommentType == 1 
      call s:ExpandSinglelineCommentsEx(s:singleLineCommentPos, 1)
    endif
    let s:firstUpdatedTagLine = -1
    call s:UpdateAllTags()
    if exists("b:jcommenter_move_cursor") && b:jcommenter_move_cursor && s:firstUpdatedTagLine != -1
      exe "normal " . s:firstUpdatedTagLine . "G$"
      if exists("b:jcommenter_autostart_insert_mode") && b:jcommenter_autostart_insert_mode
        startinsert!
      endif
    endif
    return
  endif

  if exists("b:jcommenter_method_description_space")
    let descriptionSpace = b:jcommenter_method_description_space
  else
    let descriptionSpace = s:defaultMethodDescriptionSpace
  endif
  
  call s:AppendStr('/** ')

  let param = s:GetNextParameterName()
  let exception = s:GetNextThrowName()

  if param == '' && s:method_returnValue == '' && exception == '' && exists("b:jcommenter_smart_method_description_spacing") && b:jcommenter_smart_method_description_spacing
    call s:AppendStars(1)
  else 
    call s:AppendStars(descriptionSpace)
  endif

  while param != ''
    call s:AppendStr(' * @param ' . param . ' ')
    let param = s:GetNextParameterName()
  endwhile

  if s:method_returnValue != ''
    call s:AppendStr(' * @return ')
  endif

  if exists("b:jcommenter_use_exception_tag") && b:jcommenter_use_exception_tag
    let exTag = '@exception '
  else
    let exTag = '@throws '
  endif

  while exception != ''
    call s:AppendStr(' * ' . exTag . exception . ' ')
    let exception = s:GetNextThrowName()
  endwhile

  call s:AppendStr(' */')

  call s:MoveCursor()

endfunction

function! s:WriteCopyOfTag()
  let tagName = substitute(s:combinedString, '.*\*\(\s*@\S\+\).*', '\1', '')
  let s:indent = s:GetIndentation(s:combinedString)
  let s:appendPos = s:rangeStart
  call s:AppendStr('*' . tagName . ' ')
  call s:MoveCursor()
endfunction

function! s:WriteFileComments()
  let author = ''
  if exists("*JCommenter_OwnFileComments")
    call JCommenter_OwnFileComments()
    return
  endif
  if exists("b:jcommenter_file_author")
    let author = b:jcommenter_file_author
  endif

  if exists("b:jcommenter_file_noautotime") && b:jcommenter_file_noautotime
    let created = ''
  else
    let created = strftime("%c")
  endif

  let s:appendPos = s:rangeStart - 1
  let s:indent    = ''
  call s:AppendStr('/* file name  : ' . bufname("%"))
  if exists("b:jcommenter_file_author")
    call s:AppendStr(' * authors    : ' . author)
  endif
  call s:AppendStr(' * created    : ' . created)
  if exists("b:jcommenter_file_copyright")
    call s:AppendStr(' * copyright  : ' . b:jcommenter_file_copyright)
  endif
  call s:AppendStr(' *')
  call s:AppendStr(' * modifications:')
  call s:AppendStr(' *')
  call s:AppendStr(' */')
endfunction  

function! s:WriteFieldComments()
  let s:appendPos = s:rangeStart - 1
  let s:indent = s:GetIndentation(s:combinedString)
  if exists("b:jcommenter_field_description_space")
    let descriptionSpace = b:jcommenter_field_description_space
  else
    let descriptionSpace = s:defaultFieldDescriptionSpace
  endif

  if descriptionSpace == -1
    call s:AppendStr('/**  */')
    if exists("b:jcommenter_move_cursor")
      normal k$hh
      if exists("b:jcommenter_autostart_insert_mode")
        startinsert
      endif
    endif
  else
    call s:AppendStr('/** ')
    call s:AppendStars(descriptionSpace)
    call s:AppendStr(' */')
    call s:MoveCursor()
  endif

endfunction

function! s:WriteClassComments()
  let s:indent = s:GetIndentation(s:combinedString)

  if exists("b:jcommenter_class_description_space")
    let descriptionSpace = b:jcommenter_class_description_space
  else
    let descriptionSpace = s:defaultFieldDescriptionSpace
  endif

  let s:appendPos = s:rangeStart - 1

  call s:AppendStr('/** ')

  call s:AppendStars(descriptionSpace)

  if exists('b:jcommenter_class_author')
    call s:AppendStr(' * @author ' . b:jcommenter_class_author)
  endif

  if exists('b:jcommenter_class_version')
    call s:AppendStr(' * @version ' . b:jcommenter_class_version)
  endif

  call s:AppendStr(' */')
  call s:MoveCursor()
endfunction

function! Test()
  call s:ResolveMethodParams('    public static int argh(String str, int i) throws Exception1, Exception2 {')
  let s:appendPos = 1
  let s:indent = s:method_indent
  call s:AppendStr(s:method_returnValue)
  call s:AppendStr(s:method_paramList)
  call s:AppendStr(s:method_throwsList)
  let param = s:GetNextParameterName()
  while param != '' 
    call s:AppendStr(param)
    let param = s:GetNextParameterName()
  endwhile

  let exc = s:GetNextThrowName()
  while exc != ''
    call s:AppendStr(exc)
    let exc = s:GetNextThrowName()
  endwhile
endfunction

" ===================================================
" Functions to parse things
" ===================================================


function! s:ResolveMethodParams(methodHeader)
  let methodHeader = a:methodHeader
  let methodHeader = substitute(methodHeader, '^\(.\{-}\)\s*[{;].*', '\1', '')

  let s:appendPos = s:rangeStart - 1
  let s:method_indent = substitute(methodHeader, '^\(\s*\)\S.*', '\1', '')

  let preNameString = substitute(methodHeader, '^\(\(.*\)\s\)' . s:javaname . '\s*(.*', '\1', '')
  let s:method_returnValue = substitute(preNameString, '\(.*\s\|^\)\(' . s:javaname . '\(\s*\[\s*\]\)*\)\s*$', '\2', '')

  if s:method_returnValue == 'void' || s:IsConstructor(methodHeader)
    let s:method_returnValue = ''
  endif

  let s:method_paramList = substitute(methodHeader, '.*(\(.*\)).*', '\1', '')
  let s:method_paramList = s:Trim(s:method_paramList)

  let s:method_throwsList = ''
  if methodHeader =~ ')\s*throws\s'
    let s:method_throwsList = substitute(methodHeader, '.*)\s*throws\s\+\(.\{-}\)\s*$', '\1', '')
  endif
endfunction

function! s:IsConstructor(methodHeader)
  return a:methodHeader =~ '\(^\|\s\)[A-Z][a-zA-Z0-9]*\s*('
endfunction

function! s:GetNextParameterName()
  let result = substitute(s:method_paramList, '.\{-}\s\+\(' . s:javaname . '\)\s*\(,.*\|$\)', '\1', '')
  if s:method_paramList !~ ','
    let s:method_paramList = ''
  else 
     let endIndex = matchend(s:method_paramList, ',\s*')
     let s:method_paramList = strpart(s:method_paramList, endIndex)
  endif
  return result
endfunction!

function! s:GetNextThrowName()
  let result = substitute(s:method_throwsList, '\s*\(' . s:javaname . '\)\s*\(,.*\|$\)', '\1', '')
  if match(s:method_throwsList, ',') == -1
    let s:method_throwsList = ''
  else
    let s:method_throwsList = substitute(s:method_throwsList, '.\{-},\s*\(.*\)', '\1', '')
  endif
  return result
endfunction

" ===================================================
" Functions to determine what is meant to be commented
" ===================================================

" pattern for java-names (like methods, classes, variablenames etc)
let s:javaname = '[a-zA-Z_][a-zA-Z0-9_]*'

let s:brackets = '\(s*\([\s*]\s\+\)\=\)'

let s:javaMethodPattern     = '\(^\|\s\+\)' . s:javaname . '\s*(.*)\s*\(throws\|{\|;\|$\)'
let s:javaMethodAntiPattern = '='

let s:commentTagPattern     = '^\s*\*\=\s*@[a-zA-Z]\+\(\s\|$\)'

let s:javaClassPattern	    = '\(^\|\s\)\(class\|interface\)\s\+' . s:javaname . '\({\|\s\|$\)'

" FIXME: this might not be valid:
let s:javaVariablePattern   = '\(\s\|^\)' . s:javaname . s:brackets . '.*\(;\|=.*;\)'

" Should file comments be written?
function! s:IsFileComments() 
  return s:rangeStart <= 1 && s:rangeStart == s:rangeEnd
endfunction

function! s:IsSinglelineComment()
  return s:combinedString =~ '^\s*/\*\*\(.*\)\*/\s*$'
endfunction

" Executed on a comment-tag?
function! s:IsCommentTag()
  return s:combinedString =~ s:commentTagPattern 
endfunction

" Executed on a method declaration?
function! s:IsMethod()
  let str = s:combinedString

  return str =~ s:javaMethodPattern && str !~ s:javaMethodAntiPattern
endfunction

" Executed on a class declaration?
function! s:IsClass()
  return s:combinedString =~ s:javaClassPattern
endfunction

" Executed on variable declaration?
function! s:IsVariable()
  return s:combinedString =~ s:javaVariablePattern
endfunction

" Does the declaration allready have comments?
function! s:HasMultilineDocComments()
  let linenum = s:rangeStart - 1
  let str = getline(linenum)
  while str =~ '^\s*$' && linenum > 1
    let linenum = linenum - 1
    let str = getline(linenum)
  endwhile
  if str !~ '\*/\s*$' || str =~ '/\*\*.*\*/'
    return 0
  endif
  let s:docCommentEnd = linenum
  let linenum = linenum - 1
  let str = getline(linenum)
  while str !~ '\(/\*\|\*/\)' && linenum >= 1
    let linenum = linenum - 1
    let str = getline(linenum)
  endwhile
  if str =~ '^\s*/\*\*'
    let s:docCommentStart = linenum
    return 1
  else
    let s:docCommentStart = -1
    let s:docCommentEnd   = -1
    return 0
  endif
endfunction

function! s:HasSingleLineDocComments()
  let linenum = s:rangeStart - 1
  let str = getline(linenum)
  while str =~ '^\s*$' && linenum > 1
    let linenum = linenum - 1
    let str = getline(linenum)
  endwhile
  if str =~ '^\s*/\*\*.*\*/\s*$'
    let s:singleLineCommentPos = linenum
    let s:docCommentStart = linenum
    let s:docCommentEnd   = linenum
    return 1
  endif
  return 0
endfunction

function! s:HasDocComments()
  if s:HasSingleLineDocComments()
    return 1 
  elseif s:HasMultilineDocComments()
    return 2
  endif
endfunction

" ===================================================
" Utility functions
" ===================================================

function! s:GetIndentation(string)
  return substitute(a:string, '^\(\s*\).*', '\1', '')
endfunction

" returns one string combined from the strings on the given range.
function! s:GetCombinedString(rangeStart, rangeEnd)
  let line 	     = a:rangeStart
  let combinedString = getline(line)

  while line < a:rangeEnd
    let line = line + 1
    let combinedString = combinedString . ' ' . getline(line)
  endwhile

  return combinedString
endfunction

function! s:AppendStars(amount)
  let i = a:amount
  while i > 0
    call s:AppendStr(' * ')
    let i = i - 1
  endwhile
endfunction


function! s:MoveCursorToEOL(line)
  exe "normal " . a:line . "G$"
endfunction

function! s:MoveCursor() 
  if !exists("b:jcommenter_move_cursor")
    return
  endif
  if !b:jcommenter_move_cursor
    return
  endif
  let startInsert = exists("b:jcommenter_autostart_insert_mode") && b:jcommenter_autostart_insert_mode
  if exists("b:jcommenter_description_starts_from_first_line") && b:jcommenter_description_starts_from_first_line
    call s:MoveCursorToEOL(s:rangeStart)
  else
    call s:MoveCursorToEOL(s:rangeStart + 1)
  endif
  if startInsert
    startinsert
  endif
endfunction

let s:appendPos = 1

" A function for appending strings to the buffer.
" First set the 's:appendPos', then call this function repeatedly to append
" strings after that position.
function! s:AppendStr(string)
  call append(s:appendPos, s:indent . a:string)
  let s:appendPos = s:appendPos + 1
  let s:linesAppended = s:linesAppended + 1
endfunction

function! s:Trim(string)
  return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction


