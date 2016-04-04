function! CreateTaglist()
	if &l:filetype != "cpp"
		return
	endif
	let l:sdir = expand('%:p:h')
	pyfile parse_includes.py
	let sfile = $HOME . "/.cache/tagvim/settags" . expand('%:p')
	let tgs = &l:tags
	call writefile([tgs], sfile)
endfunc

function! UpdateTags()
	if &l:filetype != "cpp"
		return
	endif
	let cache = $HOME . "/.cache/tagvim/"
	let plugloc = expand('%:p:h')
	call system('echo "' . expand('%:p') . '" >> ' . cache . 'filelist')
	call system(plugloc . '/gentags.sh ' . expand('%:p'))
endfunc

function! SetTags()
	let cache = $HOME . "/.cache/tagvim/settags"
	execute 'silent !mkdir -p ' . cache . expand('%:p:h')
	if filereadable(cache . expand('%:p'))
		 let temp = readfile(cache . expand('%:p'))
		 let &l:tags = temp[0]
	else
		echo "Taglist file for this file does not exist!"
	endif
endfunc


augroup tagvim
	autocmd!
	autocmd Filetype cpp call UpdateTags()
	autocmd Filetype cpp call SetTags()
augroup END
