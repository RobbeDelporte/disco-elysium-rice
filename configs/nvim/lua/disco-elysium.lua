-- =============================================
-- Disco Elysium — Neovim Colorscheme
-- Philosophy: 4 syntax colors (one per skill
-- category), everything else grayscale.
-- =============================================

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "disco-elysium"
vim.o.background = "dark"

-- Palette
local c = {
    -- Grayscale
    base     = "#171b1a",
    surface  = "#1e2221",
    hover    = "#282c2b",
    border   = "#363b3a",
    disabled = "#4b4b4b",
    muted    = "#999a95",
    cream    = "#d2d2d2",
    text     = "#ccc8c2",

    -- Skill categories (syntax)
    intellect = "#5bc0d6",  -- types, tags, constructors
    psyche    = "#7555c6",  -- keywords, conditionals, includes
    physique  = "#cb456a",  -- strings, characters
    motorics  = "#e3ba3e",  -- numbers, booleans, constants

    -- Functional
    action  = "#eb6408",  -- special chars, TODOs, search highlight
    success = "#0fb666",  -- git additions, diagnostics info
    error   = "#b83a3a",  -- errors, git deletions

    none = "NONE",
}

--- Set a highlight group.
---@param group string
---@param opts table
local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor chrome ──────────────────────────────────────────

hl("Normal",       { fg = c.text, bg = c.base })
hl("NormalFloat",  { fg = c.text, bg = c.surface })
hl("FloatBorder",  { fg = c.border, bg = c.surface })
hl("CursorLine",   { bg = c.surface })
hl("CursorColumn", { bg = c.surface })
hl("ColorColumn",  { bg = c.surface })
hl("LineNr",       { fg = c.disabled })
hl("CursorLineNr", { fg = c.cream })
hl("SignColumn",   { bg = c.base })
hl("VertSplit",    { fg = c.border })
hl("WinSeparator", { fg = c.border })
hl("Visual",       { bg = c.hover })
hl("VisualNOS",    { bg = c.hover })
hl("Search",       { fg = c.base, bg = c.action })
hl("IncSearch",    { fg = c.base, bg = c.action })
hl("CurSearch",    { fg = c.base, bg = c.motorics })
hl("Substitute",   { fg = c.base, bg = c.action })

hl("Pmenu",        { fg = c.text, bg = c.surface })
hl("PmenuSel",     { fg = c.text, bg = c.hover })
hl("PmenuSbar",    { bg = c.surface })
hl("PmenuThumb",   { bg = c.border })

hl("StatusLine",   { fg = c.cream, bg = c.surface })
hl("StatusLineNC", { fg = c.disabled, bg = c.surface })
hl("TabLine",      { fg = c.muted, bg = c.surface })
hl("TabLineFill",  { bg = c.base })
hl("TabLineSel",   { fg = c.text, bg = c.base })
hl("WildMenu",     { fg = c.base, bg = c.motorics })

hl("Folded",       { fg = c.muted, bg = c.surface })
hl("FoldColumn",   { fg = c.disabled, bg = c.base })
hl("NonText",      { fg = c.disabled })
hl("SpecialKey",   { fg = c.disabled })
hl("Whitespace",   { fg = c.disabled })
hl("EndOfBuffer",  { fg = c.base })

hl("MatchParen",   { fg = c.action, bold = true })
hl("Directory",    { fg = c.intellect })
hl("Title",        { fg = c.cream, bold = true })
hl("Question",     { fg = c.success })
hl("MoreMsg",      { fg = c.success })
hl("WarningMsg",   { fg = c.action })
hl("ErrorMsg",     { fg = c.error, bold = true })
hl("ModeMsg",      { fg = c.cream })
hl("Conceal",      { fg = c.disabled })
hl("SpellBad",     { undercurl = true, sp = c.error })
hl("SpellCap",     { undercurl = true, sp = c.action })
hl("SpellRare",    { undercurl = true, sp = c.psyche })
hl("SpellLocal",   { undercurl = true, sp = c.intellect })

-- ── Diff ───────────────────────────────────────────────────

hl("DiffAdd",    { fg = c.success, bg = "#0f2a1a" })
hl("DiffChange", { fg = c.motorics, bg = "#2a2510" })
hl("DiffDelete", { fg = c.error, bg = "#2a1515" })
hl("DiffText",   { fg = c.motorics, bg = "#3a3515", bold = true })

-- ── Git signs ──────────────────────────────────────────────

hl("GitSignsAdd",          { fg = c.success })
hl("GitSignsChange",       { fg = c.motorics })
hl("GitSignsDelete",       { fg = c.error })
hl("GitSignsAddNr",        { fg = c.success })
hl("GitSignsChangeNr",     { fg = c.motorics })
hl("GitSignsDeleteNr",     { fg = c.error })
hl("GitSignsAddLn",        { bg = "#0f2a1a" })
hl("GitSignsChangeLn",     { bg = "#2a2510" })
hl("GitSignsDeleteLn",     { bg = "#2a1515" })

-- ── Diagnostics ────────────────────────────────────────────

hl("DiagnosticError",          { fg = c.error })
hl("DiagnosticWarn",           { fg = c.action })
hl("DiagnosticInfo",           { fg = c.success })
hl("DiagnosticHint",           { fg = c.muted })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.action })
hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.success })
hl("DiagnosticUnderlineHint",  { undercurl = true, sp = c.muted })
hl("DiagnosticVirtualTextError", { fg = c.error, bg = "#2a1515" })
hl("DiagnosticVirtualTextWarn",  { fg = c.action, bg = "#2a1f10" })
hl("DiagnosticVirtualTextInfo",  { fg = c.success, bg = "#0f2a1a" })
hl("DiagnosticVirtualTextHint",  { fg = c.muted, bg = c.surface })

-- ── Standard syntax ────────────────────────────────────────

hl("Comment",     { fg = c.border, italic = true })
hl("String",      { fg = c.physique })
hl("Character",   { fg = c.physique })
hl("Number",      { fg = c.motorics })
hl("Float",       { fg = c.motorics })
hl("Boolean",     { fg = c.motorics })
hl("Constant",    { fg = c.motorics })

hl("Identifier",  { fg = c.text })
hl("Function",    { fg = c.text })
hl("Statement",   { fg = c.psyche })
hl("Keyword",     { fg = c.psyche })
hl("Conditional", { fg = c.psyche })
hl("Repeat",      { fg = c.psyche })
hl("Label",       { fg = c.psyche })
hl("Exception",   { fg = c.psyche })

hl("Operator",    { fg = c.disabled })
hl("Delimiter",   { fg = c.disabled })

hl("Type",        { fg = c.intellect })
hl("StorageClass", { fg = c.intellect })
hl("Structure",   { fg = c.intellect })
hl("Typedef",     { fg = c.intellect })

hl("Include",     { fg = c.psyche })
hl("Define",      { fg = c.psyche })
hl("Macro",       { fg = c.psyche })
hl("PreProc",     { fg = c.psyche })
hl("PreCondit",   { fg = c.psyche })

hl("Special",     { fg = c.action })
hl("SpecialChar", { fg = c.action })
hl("Tag",         { fg = c.intellect })
hl("Todo",        { fg = c.base, bg = c.action, bold = true })
hl("Error",       { fg = c.error, bold = true })
hl("Underlined",  { underline = true })

-- ── Treesitter ─────────────────────────────────────────────

-- Variables & identifiers
hl("@variable",           { fg = c.muted })
hl("@variable.builtin",   { fg = c.muted, italic = true })
hl("@variable.parameter", { fg = c.muted })
hl("@variable.member",    { fg = c.muted })
hl("@constant",           { fg = c.motorics })
hl("@constant.builtin",   { fg = c.motorics })
hl("@constant.macro",     { fg = c.motorics })

-- Functions
hl("@function",           { fg = c.text })
hl("@function.builtin",   { fg = c.text })
hl("@function.call",      { fg = c.text })
hl("@function.macro",     { fg = c.text })
hl("@function.method",    { fg = c.text })
hl("@method",             { fg = c.text })
hl("@method.call",        { fg = c.text })
hl("@constructor",        { fg = c.intellect })

-- Keywords
hl("@keyword",            { fg = c.psyche })
hl("@keyword.function",   { fg = c.psyche })
hl("@keyword.operator",   { fg = c.psyche })
hl("@keyword.return",     { fg = c.psyche })
hl("@keyword.coroutine",  { fg = c.psyche })
hl("@keyword.import",     { fg = c.psyche })
hl("@keyword.repeat",     { fg = c.psyche })
hl("@keyword.conditional",{ fg = c.psyche })
hl("@keyword.exception",  { fg = c.psyche })
hl("@conditional",        { fg = c.psyche })
hl("@repeat",             { fg = c.psyche })
hl("@include",            { fg = c.psyche })
hl("@exception",          { fg = c.psyche })

-- Strings & literals
hl("@string",             { fg = c.physique })
hl("@string.escape",      { fg = c.action })
hl("@string.regex",       { fg = c.action })
hl("@string.special",     { fg = c.action })
hl("@character",          { fg = c.physique })
hl("@character.special",  { fg = c.action })
hl("@number",             { fg = c.motorics })
hl("@float",              { fg = c.motorics })
hl("@boolean",            { fg = c.motorics })

-- Types
hl("@type",               { fg = c.intellect })
hl("@type.builtin",       { fg = c.intellect })
hl("@type.definition",    { fg = c.intellect })
hl("@type.qualifier",     { fg = c.psyche })
hl("@attribute",          { fg = c.intellect })
hl("@property",           { fg = c.muted })

-- Tags (HTML/JSX)
hl("@tag",                { fg = c.intellect })
hl("@tag.attribute",      { fg = c.muted })
hl("@tag.delimiter",      { fg = c.disabled })

-- Punctuation
hl("@punctuation.bracket",   { fg = c.disabled })
hl("@punctuation.delimiter", { fg = c.disabled })
hl("@punctuation.special",   { fg = c.action })

-- Operators
hl("@operator",           { fg = c.disabled })

-- Comments
hl("@comment",            { fg = c.border, italic = true })
hl("@comment.todo",       { fg = c.base, bg = c.action, bold = true })
hl("@comment.note",       { fg = c.base, bg = c.success, bold = true })
hl("@comment.warning",    { fg = c.base, bg = c.action, bold = true })
hl("@comment.error",      { fg = c.base, bg = c.error, bold = true })

-- Misc treesitter
hl("@label",              { fg = c.psyche })
hl("@namespace",          { fg = c.intellect })
hl("@module",             { fg = c.intellect })
hl("@text",               { fg = c.text })
hl("@text.strong",        { bold = true })
hl("@text.emphasis",      { italic = true })
hl("@text.underline",     { underline = true })
hl("@text.strike",        { strikethrough = true })
hl("@text.title",         { fg = c.cream, bold = true })
hl("@text.uri",           { fg = c.intellect, underline = true })
hl("@text.todo",          { fg = c.base, bg = c.action, bold = true })
hl("@text.note",          { fg = c.base, bg = c.success, bold = true })
hl("@text.warning",       { fg = c.base, bg = c.action, bold = true })
hl("@text.danger",        { fg = c.base, bg = c.error, bold = true })
