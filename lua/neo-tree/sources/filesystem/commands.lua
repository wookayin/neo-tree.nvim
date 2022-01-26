--This file should contain all commands meant to be used by mappings.

local cc = require("neo-tree.sources.common.commands")
local fs = require("neo-tree.sources.filesystem")
local utils = require("neo-tree.utils")
local filter = require("neo-tree.sources.filesystem.lib.filter")
local manager = require("neo-tree.sources.manager")

local M = {}
local refresh = utils.wrap(manager.refresh, "filesystem")
local redraw = utils.wrap(manager.redraw, "filesystem")

M.add = function(state)
  cc.add(state, fs.show_new_children)
end

M.clear_filter = function(state)
  fs.reset_search(true)
end

M.close_all_nodes = cc.close_all_nodes
M.close_node = cc.close_node

---Marks node as copied, so that it can be pasted somewhere else.
M.copy_to_clipboard = function(state)
  cc.copy_to_clipboard(state, redraw)
end

---Marks node as cut, so that it can be pasted (moved) somewhere else.
M.cut_to_clipboard = function(state)
  cc.cut_to_clipboard(state, redraw)
end

M.show_debug_info = cc.show_debug_info

---Pastes all items from the clipboard to the current directory.
M.paste_from_clipboard = function(state)
  cc.paste_from_clipboard(state, fs.show_new_children)
end

M.delete = function(state)
  cc.delete(state, refresh)
end

---Shows the filter input, which will filter the tree.
M.filter_as_you_type = function(state)
  filter.show_filter(state, true)
end

---Shows the filter input, which will filter the tree.
M.filter_on_submit = function(state)
  filter.show_filter(state, false)
end

---Navigate up one level.
M.navigate_up = function(state)
  local parent_path, _ = utils.split_path(state.path)
  local path_to_reveal = nil
  local node = state.tree:get_node()
  if node then
    path_to_reveal = node:get_id()
  end
  if state.search_pattern then
    fs.reset_search(false)
  end
  fs.navigate(parent_path, path_to_reveal)
end

M.open = function(state)
  cc.open(state, fs.toggle_directory)
end
M.open_split = function(state)
  cc.open_split(state, fs.toggle_directory)
end
M.open_vsplit = function(state)
  cc.open_vsplit(state, fs.toggle_directory)
end

M.refresh = refresh

M.rename = function(state)
  cc.rename(state, refresh)
end

M.set_root = function(state)
  local tree = state.tree
  local node = tree:get_node()
  if node.type == "directory" then
    if state.search_pattern then
      fs.reset_search(false)
    end
    fs.navigate(node.id)
  end
end

---Toggles whether hidden files are shown or not.
M.toggle_hidden = function(state)
  state.filters.show_hidden = not state.filters.show_hidden
  refresh()
end

---Toggles whether the tree is filtered by gitignore or not.
M.toggle_gitignore = function(state)
  state.filters.respect_gitignore = not state.filters.respect_gitignore
  refresh()
end

return M
