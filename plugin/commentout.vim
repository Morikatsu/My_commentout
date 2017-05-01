" vim:set filetype=vim  ts=4 sts=4 sw=4 tw=0:
"-----------------------------------------------------------------------------
"	commentout.vim	Last Change:2017/05/01 18:22:16.
"		 拡張子を判別してコメントの記号を自動でいれる。
"
"	このファイルはneobundleを使って実装してあるので、$vim\_bundle\My_commentout.vin\plugin
"	に格納してある	堀野 守克
"
"	このコマンドは、ビジュアルモード(選択領域がハイライトされた状態)で有効となる。
"
" +++++ 使い方 +++++++++++++
" <s-f1> - encomment [lhs(left-hand-side)] または [wrapping] のコメント
"			ファイルの拡張子にて[lhs]と[wrapping]を使い分けている
"			[lhs] : shell pl py(python) cpp java js mail vim bas latex prolog asm pic_asm scm sql
"			[wrapping] : c css html xml xhtml
" <s-f2> - encomment with copy	「すなわちその行をcopyして、コメントをつける」
" <s-f3> - encomment block		「コメントブロックを形成する」
" ,c - decomment lhs
" ,d - decomment wrapping
"		blockに対してはdecommentはない
"
"	注) _vimrc, _gvimrc にも使えるようにした。			2017/05/01
"
" 参考:
"	名無しの vim 使い
"		http://nanasi.jp/articles/vim/commentout_source.html
"	はてな
"		d.Hatena.ne.jp/h1mesuke/20090304/p1
"
"　-----------------------------------------------------------------------------
"  autocmdのイベント
"		WinEnter : 別のウィンドウに入った後、Vimの開始直後、一つ目のウィンドウに入ったときは発生しない。
"		BUfWinEnter : バッファがウィンドウ内に表示された後。バッファが読み込まれたときか、隠れ(hidden)バッファが
"			ウインドウ内に表示された時。ただし、すでにウィンドウが表示されているバッファを指定して、":split"を
"			したときにはこのイベントは発生しない。
"================================================================================
"
" 1度スクリプトを読み込んだら、2度目は読み込まない
:if &cp || exists("loaded_commentout")
    :finish
:endif
:let loaded_commentout = 1

" ユーザの初期設定を退避する
:let s:save_cpo = &cpo
:set cpo&vim
"================================================================================
" Encomment
"================================================================================
" lhs(left-hand-sideの略) comments  {ohne Kopy}		[ <s-f1> ]
" 選択範囲の行の先頭にcomment charを入れる。
autocmd WinEnter *.sh,*.pl,*.py vnoremap <silent><s-f1> :s/^/#/<CR>:nohlsearch<CR>			"#	shell pl py(python)
autocmd BufWinEnter *.sh,*.pl,*.py vnoremap <silent><s-f1> :s/^/#/<CR>:nohlsearch<CR>		"#	shell pl py(python)
autocmd WinEnter *.cpp,*.java,*.js vnoremap <silent><s-f1> :s/^/\/\//<CR>:nohlsearch<CR>	"//	cpp java js
autocmd BufWinEnter *.cpp,*.java,*.js vnoremap <silent><s-f1> :s/^/\/\//<CR>:nohlsearch<CR>	"//	cpp java js
autocmd WinEnter *.mail vnoremap <silent><s-f1> :s/^/> /<CR>:nohlsearch<CR>					">	mail
autocmd BufWinEnter *.mail vnoremap <silent><s-f1> :s/^/> /<CR>:nohlsearch<CR>				">	mail
"	============ 追加 2017/05/01 ==========
autocmd FileType vim vnoremap <silent><s-f1> :s/^/\"/<CR>:nohlsearch<CR>					""	vim
autocmd WinEnter *.vim vnoremap <silent><s-f1> :s/^/\"/<CR>:nohlsearch<CR>					""	vim
autocmd BufWinEnter *.vim vnoremap <silent><s-f1> :s/^/\"/<CR>:nohlsearch<CR>				""	vim

autocmd WinEnter *.bas vnoremap <silent><s-f1> :s/^/\'/<CR>:nohlsearch<CR>					"'	bas
autocmd BufWinEnter *.bas vnoremap <silent><s-f1> :s/^/\'/<CR>:nohlsearch<CR>				"'	bas
autocmd WinEnter *.latex vnoremap <silent><s-f1> :s/^/%/<CR>:nohlsearch<CR>					"%	latex prolog
autocmd BufWinEnter *.latex vnoremap <silent><s-f1> :s/^/%/<CR>:nohlsearch<CR>				"%	latex prolog
"autocmd WinEnter *.asm vnoremap <silent><s-f1> :s/^/!/<CR>:nohlsearch<CR>					"!	asm
"autocmd BufWinEnter *.asm vnoremap <silent><s-f1> :s/^/!/<CR>:nohlsearch<CR>				"!	asm
autocmd WinEnter *.asm,*.scm vnoremap <silent><s-f1> :s/^/;/<CR>:nohlsearch<CR>				";	pic_asm	scm(scheme)
autocmd BufWinEnter *.asm,*.scm vnoremap <silent><s-f1> :s/^/;/<CR>:nohlsearch<CR>			";	pic_asm	scm(scheme)
autocmd WinEnter *.sql vnoremap <silent><s-f1> :s/^/--/<CR>:nohlsearch<CR>					"-	sql
autocmd BufWinEnter *.sql vnoremap <silent><s-f1> :s/^/--/<CR>:nohlsearch<CR>				"-	sql
" lhs commentsを削除するコマンド	[ <,c> ]
vnoremap ,c :s/^\/\/\\|^--\\|^> \\|^[#"'%!;]//<CR>:nohlsearch<CR>"

"================================================================================
" wrapping comments		{ohne Kopy}	[ <s-f1> ]
" 選択範囲に一行ずつ、行頭、行尾にcomment charを入れる。
" originalのこの二行は動かず、他のブログから導入した。

autocmd WinEnter *.c,*.css vnoremap <silent><s-f1> :s/^\(.*\)$/\/\* \1 \*\//<CR>:nohlsearch<CR>				"/*..*/ c css
autocmd BufWinEnter *.c,*.css vnoremap <silent><s-f1> :s/^\(.*\)$/\/\* \1 \*\//<CR>:nohlsearch<CR>			"/*..*/ c css
autocmd WinEnter *.html,*.xml,*.xhtml vnoremap <silent><s-f1> :s/^\(.*\)$/<!-- \1 -->/<CR>:nohlsearch<CR>	"<!--..--> html xml xhtml
autocmd BufWinEnter *.html,*.xml,*.xhtml vnoremap <silent><s-f1> :s/^\(.*\)$/<!-- \1 -->/<CR>:nohlsearch<CR> "<!--..--> html xml xhtml
" wrapping commentsを削除するコマンド	[ <,d> ]
vnoremap ,d :s/^\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$/\2/<CR>:nohlsearch<CR>
"
"================================================================================
"" block comments		[ <s-f3> ]
" 選択範囲をブロックで囲んで、comment markを入れる。
autocmd WinEnter *.c,*.css,*.java,*.js vnoremap <silent><s-f3> d:set paste<CR>0i/*<CR>*/<CR><ESC>kkp:set nopaste<CR>	"/*..*/ c css java js
autocmd BufWinEnter *.c,*.css,*.java,*.js vnoremap <silent><s-f3> d:set paste<CR>0i/*<CR>*/<CR><ESC>kkp:set nopaste<CR>	"/*..*/ c css java js
autocmd WinEnter *.html,*.xml,*.xhtml vnoremap <silent><s-f3> d:set paste<CR>0i<!--<CR>--><CR><ESC>kkp:set nopaste<CR>	"<!-- --> html xml xhtml
autocmd BufWinEnter *.html,*.xml,*.xhtml vnoremap <silent><s-f3> d:set paste<CR>0i<!--<CR>--><CR><ESC>kkp:set nopaste<CR> "<!-- --> html xml xhtml
"autocmd WinEnter *.fxml vnoremap <silent><s-f3> d:set paste<CR>0i<!--<CR>--><CR><ESC>kkp:set nopaste<CR>	"<!-- --> html xml xhtml
"autocmd BufWinEnter *.fxml vnoremap <silent><s-f3> d:set paste<CR>0i<!--<CR>--><CR><ESC>kkp:set nopaste<CR> "<!-- --> html xml xhtml
"	block commentに対する削除コマンドは必要ない。
"
"================================================================================
" Encomment with copy		[ <s-f2> ]
"	以下はcomment out した部分をコピーして残す
"	この部分の削除コマンドはない。
"	堀野 守克	2014/01/27
"================================================================================
"" lhs comments		copy 付き　xレジスタを使っている
autocmd WinEnter *.sh,*.pl,*py vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/#/<CR>:nohlsearch<CR>		"#	shell pl py
autocmd BUfWinEnter *.sh,*.pl,*py vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/#/<CR>:nohlsearch<CR>	"#	shell pl py
autocmd WinEnter *.mail vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/>/<CR>:nohlsearch<CR>			">	mail
autocmd BufWinEnter *.mail vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/>/<CR>:nohlsearch<CR>		">	mail
autocmd WinEnter *.latex vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/%/<CR>:nohlsearch<CR>		"%	latex prolog
autocmd BufWinEnter *.latex vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/%/<CR>:nohlsearch<CR>		"%	latex prolog
"autocmd WinEnter *.asm vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/!/<CR>:nohlsearch<CR>		"!	asm
"autocmd Bufwinenter *.asm vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/!/<CR>:nohlsearch<CR>		"!	asm
autocmd WinEnter *.asm,*.scm vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/;/<CR>:nohlsearch<CR>	";	pic_asm scm(scheme)
autocmd BufWinEnter *.asm,*.scm vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/;/<CR>:nohlsearch<CR>	";	pic_asm scm(scheme)
autocmd WinEnter *.sql vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/-/<CR>:nohlsearch<CR>			"-	sql
autocmd BufWinEnter *.sql vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^/-/<CR>:nohlsearch<CR>		"-	sql

autocmd WinEnter *.c,*.cpp,*.java,*.js vnoremap <silent><s-f2>  "xy'<"xP:'<,'>s/^/\/\//<CR>:nohlsearch<CR>		"//	c cpp java js
autocmd BufWinEnter *.c,*.cpp,*.java,*.js vnoremap <silent><s-f2>  "xy'<"xP:'<,'>s/^/\/\//<CR>:nohlsearch<CR>	"//	c cpp java js
"	============ 追加 2017/05/01 ==========
autocmd FileType vim vnoremap <silent><s-f2>  "xy'<"xP:'<,'>s/^/"/<CR>:nohlsearch<CR>						"" vim
autocmd WinEnter *.vim vnoremap <silent><s-f2>  "xy'<"xP:'<,'>s/^/"/<CR>:nohlsearch<CR>						"" vim
autocmd BufWinEnter *.vim vnoremap <silent><s-f2>  "xy'<"xP:'<,'>s/^/"/<CR>:nohlsearch<CR>					"" vim

autocmd WinEnter *.bas vnoremap <silent><s-f2>  "xy'<"xP:'<,'>s/^/'/<CR>:nohlsearch<CR>						"' bas
autocmd BufWinEnter *.bas vnoremap <silent><s-f2>  "xy'<"xP:'<,'>s/^/'/<CR>:nohlsearch<CR>					"' bas
"================================================================================
"" wrapping comments	copy 付き　xレジスタを使っている
autocmd WinEnter *.css vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^\(.*\)$/\/\* \1 \*\//<CR>:nohlsearch<CR>	"/*..*/ css
autocmd BufWinEnter *.css vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^\(.*\)$/\/\* \1 \*\//<CR>:nohlsearch<CR>	"/*..*/ css
autocmd WinEnter *.html,*.xml,*xhtml vnoremap <silent><s-f2> "xy'<"xP:'<,'>s/^\(.*\)$/<!-- \1 -->/<CR>:nohlsearch<CR>		"<!--..--> html xml xhtml
autocmd BufWinEnter *.html,*.xml,*xhtml vnoremap <silent><s-f2> "xy'<"XP:'<,'>s/^\(.*\)$/<!-- \1 -->/<CR>:nohlsearch<CR>	"<!--..--> html xml xhtml
"================================================================================
" block comment の with_copyはない。
"=========================================================================
"　逃がしていたユーザーの設定を修復
let &cpo = s:save_cpo
"================================================================================
