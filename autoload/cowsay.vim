scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:sub_map = {
      \ 'thoughts': 'o',
      \ 'eyes': 'oo',
      \ 'tongue': 'uu'
      \ }

if !exists('g:cowsay_file_glob_patterns')
  let g:cowsay_file_glob_patterns = [
        \ expand('<sfile>:p:h:h').'/cowsay/cows/*.cow',
        \ ]
endif

fu! cowsay#cowsay(lines, animal)
  let cow = s:cow(a:animal)
  let box = s:box(a:lines)
  let boxcol = max(map(copy(box), 'len(v:val)'))
  let cowcol = max(map(copy(cow), 'len(v:val)'))
  if boxcol > cowcol
    let padding = (boxcol - cowcol) / 2
    let cow = map(cow, 'repeat(" ", padding).v:val')
  endif
  return box + cow
endfu

fu! s:box(lines)
  let col = max(map(copy(a:lines), 'len(v:val)')) + 2
  let topline = repeat('_', col)
  let bottomline = repeat('-', col)
  let lines = [topline] + a:lines + [bottomline]
  return lines
endfu

fu! s:cow(animal)
  let animal2fpath = s:animal2fpath()
  if empty(animal2fpath)
    throw 'no source file found in g:cowsay_file_glob_patterns'
  endif

  if empty(a:animal)
    let animals = keys(animal2fpath)
    return s:cow(animals[s:random(len(animals))])
  endif

  if has_key(animal2fpath, a:animal)
    let file = animal2fpath[a:animal]
    let lines = readfile(file)
    let start = 1
    let end = 0
    for i in range(len(lines))
      let line = lines[i]
      if line =~ '\v<<["]?EOC["]?;'
        let start = i
      elseif line =~ 'EOC'
        let end = i
        break
      endif
    endfor
    let lines = lines[start + 1:end - 1]
    let spaces = filter(map(copy(lines), 'match(v:val, "\\S")'), 'v:val != -1')
    let minspace = min(spaces)
    let lines = map(lines, 'v:val['.minspace.':-1]')
    for [key, value] in items(s:sub_map)
      let lines = map(lines, 'substitute(v:val, "\\v\\$[\\{]?'.key.'[\\}]?", "'.value.'", "g")')
    endfor
    return lines
  endif

  throw printf('unknown animal: %s', a:animal)
endfu

fu! s:animal2fpath()
  let animal2fpath = {}
  for src in g:cowsay_file_glob_patterns
    for fpath in split(glob(src), '\n')
      let animal = fnamemodify(fpath, ":t:r")
      if !has_key(animal2fpath, animal)
        let animal2fpath[animal] = fpath
      endif
    endfor
  endfor
  return animal2fpath
endfu

fu! s:random(n)
  return float2nr(fmod(localtime(), a:n))
endfu

let &cpo = s:save_cpo
unlet s:save_cpo
