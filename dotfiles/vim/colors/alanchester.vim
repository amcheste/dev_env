" =============================================================================
" alanchester.vim — Vim/Neovim colorscheme
" Brand system: amcheste/alanchester-brand (v2026.04.0)
" Philosophy: ∀ ε > 0, ∃ δ > 0
"
" AuDHD design principles:
"   • Warm dark background — not pure black, easier on extended focus
"   • High contrast on active/current elements only
"   • Muted syntax hierarchy: not rainbow, not flat — just signal vs. noise
"   • Green (#1F6B3A) is reserved for findings: modified files, diffs, results
"   • Rust (#B45A3C) for warnings/errors — rare, intentional
"   • Cursor line always visible for position anchoring
"   • Minimal visual competition in passive chrome (line numbers, statusline)
" =============================================================================

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "alanchester"

" ── Palette ──────────────────────────────────────────────────────────────────
" From tokens/colors.css (brand v2026.04.0)
"
"  --ac-ink         #0B0B0C   primary text (inverted: editor bg)
"  --ac-graphite    #4A5870   body copy    (inverted: subtle surface)
"  --ac-muted       #8A8A8E   captions     (passive chrome, line numbers)
"  --ac-mist        #E6E4DE   dividers     (inverted: dimmed foreground)
"  --ac-paper       #F6F4EE   background   (inverted: primary foreground)
"  --ac-accent      #1F6B3A   δ green      (data, change, findings only)
"  --ac-accent-alt  #B45A3C   rust         (errors, warnings — rare)
"
" Editor-mode inversion + tonal expansion:
"  bg           #364252   slightly warmer than ink (reduces eye strain)
"  bg_subtle    #3F4D5E   graphite-adjacent surface
"  bg_active    #475566   cursor line, visual selection base
"  fg_dim       #606065   between graphite and muted (inactive elements)
"  fg_mid       #8A8A8E   muted (comments, line numbers)
"  fg_main      #C8C6C0   between mist and paper (body text)
"  fg_bright    #F6F4EE   paper (keywords, important tokens)
"  green        #1F6B3A   accent (diffs, modified, findings)
"  green_bright #2D9653   lighter green for actual text on dark bg
"  rust         #B45A3C   accent-alt (errors)
"  rust_bright  #D4714E   lighter rust for readable text
"  amber        #C49A3C   constructed: warnings (warm, not alarming)
"  blue         #3A6B9A   constructed: types, info (cool anchor)
"  blue_bright  #4E8EC2   readable blue for text
"  purple       #6B4A8A   constructed: special/macro (rare)

" ── Highlight function ───────────────────────────────────────────────────────
function! s:hi(group, fg, bg, attr)
  let l:cmd = "hi " . a:group
  if a:fg != ""
    let l:cmd .= " guifg=" . a:fg
  endif
  if a:bg != ""
    let l:cmd .= " guibg=" . a:bg
  endif
  if a:attr != ""
    let l:cmd .= " gui=" . a:attr . " cterm=" . a:attr
  else
    let l:cmd .= " gui=NONE cterm=NONE"
  endif
  exec l:cmd
endfunction

" ── Editor chrome ─────────────────────────────────────────────────────────────
call s:hi("Normal",       "#C8C6C0", "#364252", "")
call s:hi("NormalFloat",  "#C8C6C0", "#3F4D5E", "")
call s:hi("NormalNC",     "#8A8A8E", "#364252", "")

" Cursor & position anchoring — high priority for AuDHD
call s:hi("Cursor",       "#364252", "#F6F4EE", "")
call s:hi("CursorLine",   "",        "#3F4D5E", "")
call s:hi("CursorLineNr", "#C8C6C0", "#3F4D5E", "bold")
call s:hi("CursorColumn", "",        "#3F4D5E", "")

" Line numbers — passive chrome, should recede
call s:hi("LineNr",       "#5C6E84", "",        "")
call s:hi("SignColumn",   "#5C6E84", "#364252", "")

" Status line — clear separation without brightness
call s:hi("StatusLine",   "#C8C6C0", "#475566", "")
call s:hi("StatusLineNC", "#606065", "#3F4D5E", "")
call s:hi("WinSeparator", "#4A5870", "",        "")
call s:hi("VertSplit",    "#4A5870", "",        "")

" Tab bar
call s:hi("TabLine",      "#8A8A8E", "#3F4D5E", "")
call s:hi("TabLineSel",   "#F6F4EE", "#475566", "bold")
call s:hi("TabLineFill",  "",        "#364252", "")

" Visual selection — visible but not jarring
call s:hi("Visual",       "",        "#304A58", "")
call s:hi("VisualNOS",    "",        "#475566", "")

" Search — accent green for "found data"
call s:hi("Search",       "#364252", "#2D9653", "")
call s:hi("IncSearch",    "#364252", "#1F6B3A", "bold")
call s:hi("CurSearch",    "#364252", "#2D9653", "bold")

" Matching parens — warm, not alarming
call s:hi("MatchParen",   "#C49A3C", "",        "bold")

" Folds — very passive, just enough
call s:hi("Folded",       "#606065", "#3F4D5E", "italic")
call s:hi("FoldColumn",   "#5C6E84", "#364252", "")

" Popup menu
call s:hi("Pmenu",        "#C8C6C0", "#3F4D5E", "")
call s:hi("PmenuSel",     "#F6F4EE", "#475566", "bold")
call s:hi("PmenuSbar",    "",        "#475566", "")
call s:hi("PmenuThumb",   "",        "#606065", "")

" Messages and prompts
call s:hi("ModeMsg",      "#C8C6C0", "",        "bold")
call s:hi("MoreMsg",      "#2D9653", "",        "")
call s:hi("Question",     "#2D9653", "",        "bold")
call s:hi("WarningMsg",   "#C49A3C", "",        "")
call s:hi("ErrorMsg",     "#D4714E", "",        "bold")

" Spelling
call s:hi("SpellBad",     "#D4714E", "",        "undercurl")
call s:hi("SpellCap",     "#4E8EC2", "",        "undercurl")
call s:hi("SpellLocal",   "#C49A3C", "",        "undercurl")
call s:hi("SpellRare",    "#8A6B9A", "",        "undercurl")

" Diff — green = added (data arrived), rust = removed (data left)
call s:hi("DiffAdd",      "#2D9653", "#1A3040", "")
call s:hi("DiffChange",   "#4E8EC2", "#1A2A42", "")
call s:hi("DiffDelete",   "#D4714E", "#3A2820", "")
call s:hi("DiffText",     "#F6F4EE", "#2A4A6C", "bold")
call s:hi("diffAdded",    "#2D9653", "",        "")
call s:hi("diffRemoved",  "#D4714E", "",        "")
call s:hi("diffChanged",  "#4E8EC2", "",        "")

" Misc
call s:hi("NonText",      "#3A3A3E", "",        "")
call s:hi("SpecialKey",   "#5C6E84", "",        "")
call s:hi("Whitespace",   "#3A3A3E", "",        "")
call s:hi("EndOfBuffer",  "#475566", "",        "")
call s:hi("Directory",    "#4E8EC2", "",        "")
call s:hi("Title",        "#F6F4EE", "",        "bold")
call s:hi("Conceal",      "#606065", "",        "")

" ── Syntax ───────────────────────────────────────────────────────────────────
" Hierarchy: bright = structure/keywords, mid = literals, dim = comments
" Color = meaning, not decoration

" Comments — passive, must recede (IBM Plex Mono italic in spirit)
call s:hi("Comment",      "#5A5A5E", "",        "italic")
call s:hi("SpecialComment","#606065","",        "italic")

" Constants and literals
call s:hi("Constant",     "#C8C6C0", "",        "")
call s:hi("String",       "#9AC4A0", "",        "")      " soft green — string data
call s:hi("Character",    "#9AC4A0", "",        "")
call s:hi("Number",       "#C8B88A", "",        "")      " warm amber-lite
call s:hi("Boolean",      "#C49A3C", "",        "bold")  " amber — special value
call s:hi("Float",        "#C8B88A", "",        "")

" Identifiers
call s:hi("Identifier",   "#C8C6C0", "",        "")
call s:hi("Function",     "#F6F4EE", "",        "")      " bright — named entry points matter

" Statements / keywords — bright, structural
call s:hi("Statement",    "#F6F4EE", "",        "bold")
call s:hi("Conditional",  "#F6F4EE", "",        "bold")
call s:hi("Repeat",       "#F6F4EE", "",        "bold")
call s:hi("Label",        "#C8C6C0", "",        "")
call s:hi("Operator",     "#8A8A8E", "",        "")      " muted — punctuation recedes
call s:hi("Keyword",      "#F6F4EE", "",        "bold")
call s:hi("Exception",    "#D4714E", "",        "bold")  " rust — exceptional path

" Preprocessor / macros
call s:hi("PreProc",      "#C8C6C0", "",        "")
call s:hi("Include",      "#4E8EC2", "",        "")      " blue — imports/includes
call s:hi("Define",       "#C8C6C0", "",        "")
call s:hi("Macro",        "#8A6B9A", "",        "")      " purple — generated/meta
call s:hi("PreCondit",    "#C8C6C0", "",        "")

" Types
call s:hi("Type",         "#4E8EC2", "",        "")      " blue — structural types
call s:hi("StorageClass", "#F6F4EE", "",        "bold")
call s:hi("Structure",    "#4E8EC2", "",        "")
call s:hi("Typedef",      "#4E8EC2", "",        "")

" Special characters
call s:hi("Special",      "#8A8A8E", "",        "")
call s:hi("SpecialChar",  "#C49A3C", "",        "")
call s:hi("Tag",          "#4E8EC2", "",        "")
call s:hi("Delimiter",    "#8A8A8E", "",        "")      " very muted — just structure

" Underline / todo
call s:hi("Underlined",   "#4E8EC2", "",        "underline")
call s:hi("Ignore",       "#3A3A3E", "",        "")
call s:hi("Error",        "#D4714E", "",        "bold")
call s:hi("Todo",         "#364252", "#C49A3C", "bold")  " amber bg — action required

" ── Treesitter (Neovim) ──────────────────────────────────────────────────────
if has("nvim")
" Only override where treesitter groups diverge meaningfully from legacy
hi link @comment              Comment
hi link @comment.documentation Comment
hi link @string               String
hi link @string.escape        SpecialChar
hi link @number               Number
hi link @float                Float
hi link @boolean              Boolean
hi link @constant             Constant
hi link @constant.builtin     Boolean
hi link @variable             Identifier
hi link @variable.builtin     Keyword
hi link @parameter            Identifier
hi link @field                Identifier
hi link @property             Identifier
hi link @function             Function
hi link @function.builtin     Function
hi link @function.call        Function
hi link @method               Function
hi link @keyword              Keyword
hi link @keyword.operator     Operator
hi link @keyword.return       Keyword
hi link @conditional          Conditional
hi link @repeat               Repeat
hi link @operator             Operator
hi link @punctuation          Delimiter
hi link @punctuation.bracket  Delimiter
hi link @type                 Type
hi link @type.builtin         Type
hi link @namespace            Identifier
hi link @include              Include
hi link @tag                  Tag
hi link @tag.attribute        Identifier
hi link @error                Error

endif

" ── LSP diagnostics ──────────────────────────────────────────────────────────
call s:hi("DiagnosticError",       "#D4714E", "",        "")
call s:hi("DiagnosticWarn",        "#C49A3C", "",        "")
call s:hi("DiagnosticInfo",        "#4E8EC2", "",        "")
call s:hi("DiagnosticHint",        "#606065", "",        "")
call s:hi("DiagnosticUnderlineError",   "",   "",        "undercurl")
call s:hi("DiagnosticUnderlineWarn",    "",   "",        "undercurl")
call s:hi("DiagnosticUnderlineInfo",    "",   "",        "undercurl")
call s:hi("DiagnosticUnderlineHint",    "",   "",        "undercurl")
call s:hi("DiagnosticVirtualTextError", "#D4714E", "",   "italic")
call s:hi("DiagnosticVirtualTextWarn",  "#C49A3C", "",   "italic")
call s:hi("DiagnosticVirtualTextInfo",  "#4E8EC2", "",   "italic")
call s:hi("DiagnosticVirtualTextHint",  "#606065", "",   "italic")

" ── Git signs (gitsigns.nvim / vim-gitgutter) ─────────────────────────────────
call s:hi("GitSignsAdd",     "#2D9653", "#364252", "")   " green = data arrived
call s:hi("GitSignsChange",  "#4E8EC2", "#364252", "")
call s:hi("GitSignsDelete",  "#D4714E", "#364252", "")
call s:hi("GitGutterAdd",    "#2D9653", "#364252", "")
call s:hi("GitGutterChange", "#4E8EC2", "#364252", "")
call s:hi("GitGutterDelete", "#D4714E", "#364252", "")

" ── Telescope ────────────────────────────────────────────────────────────────
call s:hi("TelescopeNormal",          "#C8C6C0", "#364252", "")
call s:hi("TelescopeBorder",          "#4A5870", "",        "")
call s:hi("TelescopePromptBorder",    "#2D9653", "",        "")
call s:hi("TelescopeSelection",       "#F6F4EE", "#3F4D5E", "bold")
call s:hi("TelescopeSelectionCaret",  "#2D9653", "#3F4D5E", "")
call s:hi("TelescopeMatching",        "#2D9653", "",        "bold")

" ── nvim-tree / NERDTree ──────────────────────────────────────────────────────
call s:hi("NvimTreeNormal",       "#C8C6C0", "#2D3848", "")
call s:hi("NvimTreeRootFolder",   "#F6F4EE", "",        "bold")
call s:hi("NvimTreeFolderName",   "#4E8EC2", "",        "")
call s:hi("NvimTreeOpenedFolderName", "#F6F4EE", "",    "")
call s:hi("NvimTreeGitDirty",     "#4E8EC2", "",        "")
call s:hi("NvimTreeGitNew",       "#2D9653", "",        "")
call s:hi("NvimTreeGitDeleted",   "#D4714E", "",        "")

" ── WhichKey ─────────────────────────────────────────────────────────────────
call s:hi("WhichKey",         "#2D9653", "", "bold")
call s:hi("WhichKeyGroup",    "#4E8EC2", "", "")
call s:hi("WhichKeyDesc",     "#C8C6C0", "", "")
call s:hi("WhichKeySeparator","#5C6E84", "", "")
call s:hi("WhichKeyFloat",    "",        "#3F4D5E", "")

" ── Indent guides ────────────────────────────────────────────────────────────
call s:hi("IndentBlanklineChar",        "#475566", "", "")
call s:hi("IndentBlanklineContextChar", "#3A3A3E", "", "")

" =============================================================================
" Installation:
"   ~/.vim/colors/alanchester.vim          (Vim)
"   ~/.config/nvim/colors/alanchester.vim  (Neovim)
"
" Usage:
"   colorscheme alanchester
"
" In init.vim / init.lua:
"   vim.cmd("colorscheme alanchester")
" =============================================================================
