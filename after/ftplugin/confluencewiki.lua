local ns = vim.api.nvim_create_namespace 'confluence_syntax'

-- Define highlight groups
local highlights = {
  ConfluenceH1 = { fg = '#000000', bg = '#FFA700', bold = true }, -- Gold
  ConfluenceH2 = { fg = '#000000', bg = '#ADFF2F', bold = true }, -- GreenYellow
  ConfluenceH3 = { fg = '#000000', bg = '#87CEEB', bold = true }, -- SkyBlue
  ConfluenceH4 = { fg = '#000000', bg = '#FFA07A', bold = true }, -- LightSalmon
  ConfluenceH5 = { fg = '#000000', bg = '#DA70D6', bold = true }, -- Orchid
  ConfluenceH6 = { fg = '#000000', bg = '#20B2AA', bold = true }, -- LightSeaGreen
  ConfluenceCodeBlock = { fg = '#CABA55', bg = '#205020', bold = true },
  ConfluenceCodePanel = { bg = '#A05010' },
  ConfluenceInlineCode = { fg = '#00EEEE', italic = true }, -- New highlight group
  ConfluenceLink = { fg = '#00AAFF', italic = true }, -- New highlight group
}

-- Create highlight groups
for group, settings in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, settings)
end

-- Function to highlight Confluence syntax
local function highlight_confluence_syntax()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Clear existing highlights
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  -- Get all lines in the buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local in_code_panel = false
  local in_code_block = false
  local code_block_start = 0
  local code_panel_start = 0

  for i, line in ipairs(lines) do
    if in_code_panel then
      if line:match '^{panel}' then
        in_code_panel = false
        -- Highlight the entire code panel
        vim.api.nvim_buf_add_highlight(bufnr, ns, 'ConfluenceCodePanel', code_panel_start, 0, -1)
        vim.api.nvim_buf_add_highlight(bufnr, ns, 'ConfluenceCodePanel', i - 1, 0, -1)
        for j = code_panel_start + 1, i - 2 do
          vim.api.nvim_buf_add_highlight(bufnr, ns, 'ConfluenceCodepanel', j, 0, -1)
        end
      end
    elseif line:match '^{panel' then
      in_code_panel = true
      code_panel_start = i - 1
    end

    if in_code_block then
      if line:match '^%s*{code}' then
        in_code_block = false
        -- Highlight the entire code block
        vim.api.nvim_buf_add_highlight(bufnr, ns, 'ConfluenceCodeBlock', code_block_start, 0, -1)
        vim.api.nvim_buf_add_highlight(bufnr, ns, 'ConfluenceCodeBlock', i - 1, 0, -1)
        for j = code_block_start + 1, i - 2 do
          vim.api.nvim_buf_add_highlight(bufnr, ns, 'ConfluenceCodeBlock', j, 0, -1)
        end
      end
    elseif line:match '^%s*{code' then
      in_code_block = true
      code_block_start = i - 1
    end

    -- Highlight links
    for start_pos, end_pos in line:gmatch '()%[.-()%]' do
      vim.api.nvim_buf_add_highlight(bufnr, ns, 'ConfluenceLink', i - 1, start_pos - 1, end_pos)
    end

    -- Highlight inline code
    for start_pos, end_pos in line:gmatch '()%{%{.-()%}%}' do
      vim.api.nvim_buf_add_highlight(bufnr, ns, 'ConfluenceInlineCode', i - 1, start_pos - 1, end_pos + 1)
    end

    -- Highlight headers
    local level = line:match '^h([0-9])[.]%s+'
    if level then
      local hl_group = 'ConfluenceH' .. level
      vim.api.nvim_buf_add_highlight(bufnr, ns, hl_group, i - 1, 0, -1)
    end
  end
end

-- Set up autocommand to highlight syntax on various events
local augroup = vim.api.nvim_create_augroup('ConfluenceSyntax', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'TextChangedI', 'InsertLeave' }, {
  group = augroup,
  pattern = '*.wiki',
  callback = highlight_confluence_syntax,
})

-- Initial highlighting
highlight_confluence_syntax()
