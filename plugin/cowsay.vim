scriptencoding utf-8

if &compatible || (exists('g:loaded_cowsay') && g:loaded_cowsay)
  finish
endif
let g:loaded_cowsay = 1

let s:root = expand('<sfile>:p:h:h')
let s:sub_map = {
      \ 'thoughts': 'o',
      \ 'eyes': 'oo',
      \ 'tongue': 'uu'
      \ }

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
  let file = expand(s:root.'/cowsay/cows/'.a:animal.'.cow')
  if empty(a:animal)
    let animals = s:animals()
    return s:cow(animals[s:random(len(animals))])
  elseif filereadable(file)
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
  else
    return []
  endif
endfu

fu! s:animals()
  let files = split(globpath(expand(s:root.'/cowsay/cows'), '*.cow'), '\n')
  return map(files, 'fnamemodify(v:val, ":t:r")')
endfu

fu! s:random(n)
  return float2nr(fmod(localtime(), a:n))
endfu
