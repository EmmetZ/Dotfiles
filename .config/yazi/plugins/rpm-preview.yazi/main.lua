local M = {}
local function fail(s, ...)
  ya.notify { title = "RPM Preview", content = string.format(s, ...), timeout = 5, level = "error" }
end

function M:peek(job)
  local limit = job.area.h
  local paths = {}

  local files, bound, code = self.list_files(tostring(job.file.url), job.skip, limit)
  if code ~= 0 then
    ya.preview_widgets(job, {
      ui.Text(code == 2 and "No items" or "Failed to parse rpm file"):align(ui.Text.CENTER):area(job.area),
    })
    return
  end

  for _, f in ipairs(files) do
    local icon = File({
      url = Url(f.path),
      cha = Cha { kind = 0 },
    }):icon()

    if icon then
      paths[#paths + 1] = ui.Line { ui.Span(" " .. icon.text .. " "):style(icon.style), f.path }
    else
      paths[#paths + 1] = f.path
    end
  end

  if job.skip > 0 and bound < limit + job.skip then
    ya.emit("peek", { math.max(0, bound - limit), only_if = job.file.url, upper_bound = true })
  else
    ya.preview_widgets(job, {
      ui.Text(paths):area(job.area),
    })
  end
end

function M:seek(job)
  local h = cx.active.current.hovered
  if h and h.url == job.file.url then
    local step = math.floor(job.units * job.area.h / 10)
    ya.emit("peek", {
      math.max(0, cx.active.preview.skip + step),
      only_if = tostring(job.file.url),
    })
  end
end

---List files in an archive
---@param file string
---@param skip integer
---@param limit integer
---@return table files
---@return integer bound
---@return integer code
---  0: success
---  1: failed to spawn
---  2: empty
function M.list_files(file, skip, limit)
  local child = Command("rpm")
      :arg({ "-ql", file })
      :stdout(Command.PIPED)
      :stderr(Command.PIPED)
      :spawn()
  if not child then
    return {}, 0, 1
  end

  local files = { { path = "" } }
  local code = 0
  local num_lines = 1
  repeat
    local line, event = child:read_line()
    if event == 1 then
      goto continue
    elseif event ~= 0 then
      break
    end

    num_lines = num_lines + 1
    if num_lines >= skip then
      files[#files].path = line:match("(.-)[\r\n]+")
      files[#files + 1] = { path = "" }
    end
    ::continue::
  until num_lines >= limit + skip
  if num_lines == 1 then
    code = 2
  elseif num_lines == 2 then
    code = 2
  end

  child:start_kill()

  if files[#files].path == "" then
    files[#files] = nil
  end
  return files, num_lines, code
end

return M
