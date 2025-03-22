-- callout2latex.lua
-- Pandoc Lua filter to GitHub / Obsidian / Microsoft styled Markdown Callout
-- Blocks / Alart Blocks / Message Boxes / Admonitions callout blocks to LaTeX
-- environments.
--
-- Author: DeepSeek, ChatGPT, Githubonline1396529
-- Date: 2023-10-11
-- Version: 0.0.1.2
-- Usage:
--
-- For example, Convert File.md to File.tex.
-- +----------------------------------+--------------------------------------+
-- |    Before Convert                |    After Convert                     |
-- +----------------------------------+--------------------------------------+
-- | > [!note] This is the note title | \begin{note}[This is the note title] |
-- | > This is a line of info.        |                                      |
-- |                                  |   This is a line of info.            |
-- |                                  |                                      |
-- |                                  | \end{note}                           |
-- |                                  |                                      |
-- +----------------------------------+--------------------------------------+
-- | > [!note]                        | \begin{note}[]                       |
-- | > This is a line of info         |                                      |
-- | > It may contain multiple lines, |   This is a line of info             |
-- | >                                |                                      |
-- | > Or even a new paragraph.       |   It may contain multiple lines,     |
-- |                                  |                                      |
-- |                                  |   Or even a new paragraph.           |
-- |                                  |                                      |
-- |                                  | \end{note}                           |
-- +----------------------------------+--------------------------------------+
--
-- Here are a few things to note about this filter script:
-- 
-- 1. Currently, ordered lists (`enumerate`) and unordered lists (`itemize`)
--    are not supported within callout blocks.
-- 2. Every single line in the callout block will be converted into one 
--    paragraph in LaTeX.
-- 
-- DO NOT USE SPACE AFTER THE TYPE LABEL
--  
-- Leaving a space (or any other blank character) after the callout block type
-- label `[!TYPE]` may cause unwanted and unexpected LaTeX formatting. For 
-- example:
--  
--   ```markdown
--   > [!NOTE]  
--   > Notice here is two spaces after the `[!NOTE]` label.
--   ```
--  
-- You may can't see the spaces but they do exist. However this will be 
-- converted to:
--  
--   ```tex
--   \begin{note}[Notice the two spaces after the `[!NOTE]` label. ]
--   \end{note}
--   ```
--  
-- This may result in unexpected formatting of the content.
--
-- LICENSE --------------------------------------------------------------------
--
-- MIT License
--
-- Copyright (c) 2025
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- dealin the Software without restriction, including without limitation the 
-- rightsto use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sellcopies of the Software, and to permit persons to whom the Software
-- isfurnished to do so, subject to the following conditions:The above
-- copyright notice and this permission notice shall be included in allcopies 
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- ORIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
-- THEAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
-- OTHERLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THESOFTWARE.

local types = require 'pandoc.utils'.type
local stringify = require 'pandoc.utils'.stringify

--[[
Pandoc AST Structure Insight:
A Markdown blockquote:

> [!note] Title
> Content

Is parsed as:

BlockQuote {
  content = {
    Para {
      Str "[!note]", Space, Str "Title", SoftBreak, 
      Str "Content"
    }
  }
}

Try `pandoc -t native file.md > doctree.ast` to see the output.

This filter needs to:

1. Identify the [!type] marker
2. Separate title from content
3. Rebuild as LaTeX environment

]]

local types = require 'pandoc.utils'.type
local stringify = require 'pandoc.utils'.stringify

function BlockQuote(el)
    -- Validate block structure: First element must be a paragraph.
    if #el.content < 1 or el.content[1].t ~= 'Para' then
        return el
    end

    -- Extract first paragraph's inline elements.
    local first_para = el.content[1].content
    if #first_para < 1 or first_para[1].t ~= 'Str' then
        return el
    end

    -- Locate the [!type] marker in inline elements.
    --
    -- AST structure: Para contains sequence of Str/Space/SoftBreak elements
    -- local marker_idx = nil .
    for i, inline in ipairs(first_para) do
        if inline.t == 'Str' and inline.text:match('^%[!%w+%]$') then
            marker_idx = i
            break
        end
    end
    if not marker_idx then return el end

    -- Extract callout type from marker (e.g., "note" from [!note])
    local callout_type = first_para[marker_idx].text:match('%[!(%w+)%]')
    if not callout_type then return el end

    -- Find content starting point after first SoftBreak.
    -- This separates title from content in the AST.
    local content_start_idx = nil
    for i = marker_idx + 1, #first_para do
        if first_para[i].t == 'SoftBreak' then
            content_start_idx = i + 1  -- Skip SoftBreak itself.
            break
        end
    end

    -- Extract title elements (between marker and first SoftBreak)
    local title_elems = {}
    for i = marker_idx + 1, (content_start_idx or #first_para + 1) - 1 do
        table.insert(title_elems, first_para[i])
    end

    -- Process content blocks -------------------------------------------------
    local content_blocks = pandoc.List()

    -- Handle inlines after content_start_idx (actual callout content)
    if content_start_idx then
        local content_inlines = {}
        for i = content_start_idx, #first_para do
            local elem = first_para[i]

            -- Split paragraphs at SoftBreak nodes (Markdown newlines)
            if elem.t == 'SoftBreak' then
                if #content_inlines > 0 then
                    content_blocks:insert(pandoc.Para(content_inlines))
                    content_inlines = {}
                end
            else
                table.insert(content_inlines, elem)
            end
        end
        -- Add remaining inlines as last paragraph
        if #content_inlines > 0 then
            content_blocks:insert(pandoc.Para(content_inlines))
        end
    end

    -- Add subsequent blocks (other Markdown elements after first paragraph)
    for i = 2, #el.content do
        content_blocks:insert(el.content[i])
    end

    -- Build LaTeX output -----------------------------------------------------
    local env_name = callout_type:lower()
    local title_str = #title_elems > 0 and stringify(title_elems) or nil

    -- Clean title whitespace (collapse multiple spaces, trim edges)
    if title_str then
        title_str = title_str:gsub('%s+', ' '):gsub('^%s*(.-)%s*$', '%1')
    end
    
    -- LaTeX environment start with optional title
    local output_blocks = pandoc.List()
    local title_part = ''

    if title_str ~= nil and not title_str:match('^%s*$') then
        title_part = '[' .. title_str .. ']'
    end
    
    output_blocks:insert(pandoc.RawBlock('latex',
        '\\begin{' .. env_name .. '}' .. title_part
    ))

    -- output_blocks:insert(pandoc.RawBlock('latex', 
    --     '\\begin{'..env_name..'}'..(title_str and ('['..title_str..']') or '')
    -- ))

    -- Insert processed content blocks
    output_blocks:extend(content_blocks)

    -- Close LaTeX environment
    output_blocks:insert(pandoc.RawBlock('latex', '\\end{'..env_name..'}'))

    return output_blocks
end

