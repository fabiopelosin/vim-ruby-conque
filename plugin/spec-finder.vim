" Find the related spec for any file you open.
function! RelatedSpec()
  let l:fullpath = expand("%:p")
  let l:filepath = expand("%:h")
  let l:fname = expand("%:t")
  let l:filepath_without_lib = substitute(l:filepath, "lib/[^/]*", "", "")
  if  l:filepath_without_lib == 'lib'
    let l:filepath_without_lib = ''
  endif

  " We are already in a spec
  if l:fullpath =~ "_spec.rb$"
    return l:fullpath
  endif

  " Possible names for the spec/test for the file we're looking at
  let l:test_names = [substitute(l:fname, ".rb$", "_spec.rb", ""), substitute(l:fname, ".rb$", "_test.rb", "")]

  " Possible paths
  let l:test_paths = ["spec", "spec/unit", "spec/functional", "fast_spec", "test"]

  for test_name in l:test_names
    for path in l:test_paths
      let l:spec_path = path . "/" . l:filepath_without_lib . "/" . test_name
      let l:full_spec_path = substitute(l:fullpath, l:filepath . "/" . l:fname, l:spec_path, "")
      if filereadable(l:spec_path)
        return l:full_spec_path
      end
    endfor
  endfor
endfunction

function! RelatedSpecOpen()
  let l:spec_path = RelatedSpec()
  if filereadable(l:spec_path)
    execute ":e " . l:spec_path
  endif
endfunction

function! RelatedSpecVOpen()
  let l:spec_path = RelatedSpec()
  if filereadable(l:spec_path)
    execute ":botright vsp " . l:spec_path
  endif
endfunction

command! RelatedSpecVOpen call RelatedSpecVOpen()
command! RelatedSpecOpen call RelatedSpecOpen()

nnoremap <silent> <C-s> :RelatedSpecVOpen<CR>
nnoremap <silent> ,<C-s> :RelatedSpecOpen<CR>
