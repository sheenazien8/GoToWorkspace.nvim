local fn = vim.fn
local cmd = vim.cmd
local json_file = os.getenv("HOME") .. "/.vim/workspace.json"
local path_session = os.getenv("HOME") ..  "/.vim/sessions/"
local custom_commands_before_save = "NvimTreeClose"

local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end
local function tableLength(table)
  if table == nil  then
    return nil
  end
  local lastIndex = 0
  for _, _ in pairs(table) do
    lastIndex = lastIndex + 1
  end

  return lastIndex
end

local function FileExists(name)
  local f=io.open(name,"r")
  if f~=nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function lines_from(file)
  if not FileExists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end

  return lines
end

local function getJson()
  local lines = lines_from(json_file)
  if tableLength(lines) == 0 then
    return 2
  end

  -- print all line numbers and their contents
  local lines_concat = ""
  for _,v in pairs(lines)  do
    lines_concat = lines_concat .. v
  end
  local string ="return " .. lines_concat:gsub('("[^"]-"):','[%1]=')
  local result = loadstring(string)()

  return result
end

function SavedWorkspace()
  local result = ""
  if getJson() ~= 2 then
    for key, _ in pairs(getJson()) do
      result = result .. key .. "\n"
    end
  end
  if result == "" then
    return ""
  end

  return result
end

function OpenWorkspace()
  cmd('e ' .. json_file)
end

function GoToWorkspace(target)
  local data = getJson()[target]
  if data ~= nil then
    cmd("silent! lua SaveSession()")
    local path = data['path']
    local session = data['session']
    cmd("silent! bufdo bd")
    cmd("cd " .. path)
    cmd("source " .. session)
  else
    print("Workspace " .. target .. " doesn't exists")
  end
end

local function getCwd()
  local current_path = fn.getcwd()
  local arr = split(current_path, '/')
  local lastIndex = #arr - 0
  local cwd = arr[lastIndex]

  return {
    cwd = cwd,
    current_path = current_path
  }
end

local function saveJson(string)
  io.output(io.open(json_file, "w"))
  io.write(string)
  io.close()
end

function SaveSession()
  local dirIsExist = fn.isdirectory(vim.fn.expand(path_session))
  if dirIsExist == 0 then
    cmd("execute " .. fn.mkdir(fn.mkdir(fn.expand(path_session))))
  end
  local jsonFileExist = fn.isdirectory(vim.fn.expand(json_file))
  if jsonFileExist == 0 then
    cmd("silent !touch " .. fn.expand(json_file))
  end
  local cwd = getCwd().cwd
  cmd(custom_commands_before_save)
  cmd("mksession! " .. path_session .. cwd)
  local opened_parenthesis = "{"
  local closed_parenthesis = "}"
  local result = ""
  if getJson() == 2 then
    saveJson("{}")
  end
  local lastIndex = tableLength(getJson())
  local index = 0
  local reset = true
  for key, value in pairs(getJson()) do
    local path = "\"path\":".. "\"" .. value.path .. "\","
    local session = "\"session\":".. "\"" .. value.session .. "\""
    result = result .. "\"" .. key .. "\":" .. opened_parenthesis .. path .. session .. closed_parenthesis
    index = index + 1
    if index ~= lastIndex then
      result = result .. ","
    end
    if key == cwd then
      reset = false
    end
  end

  if reset then
    local new_path = "\"path\":".. "\"" .. getCwd().current_path .. "\","
    local new_session = "\"session\":".. "\"" .. path_session ..cwd .. "\""
    if lastIndex ~= 0 then
      result = result .. ",\"" .. cwd .. "\":" .. opened_parenthesis .. new_path .. new_session .. closed_parenthesis
    else
      result = result .. "\"" .. cwd .. "\":" .. opened_parenthesis .. new_path .. new_session .. closed_parenthesis
    end
  end

  saveJson(opened_parenthesis .. result .. closed_parenthesis)

  print('Session saveed with name: ' .. cwd)
end

function SessionRestore()
  local existFile = path_session .. getCwd().cwd
  if FileExists(existFile) then
    cmd("silent source " .. existFile)
  else
    print("Belum ada workspace")
  end
end

function CloseWithSave()
  SaveSession()
  cmd("qa")
end

cmd("command! OpenWorkspace :lua OpenWorkspace()")
cmd("command! SaveSession :lua SaveSession()")
cmd("command! SessionRestore :lua SessionRestore()")
cmd("silent! command -nargs=1 -complete=custom,v:lua.SavedWorkspace GoToWorkspace :lua GoToWorkspace(<f-args>)")
--cmd("silent! autocommand BufEnter * :NvimTreeGitRefresh<CR>")
--cmd("au VimEnter * SessionRestore")
