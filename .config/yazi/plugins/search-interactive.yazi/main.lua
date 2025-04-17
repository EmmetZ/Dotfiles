local state = ya.sync(function() return cx.active.current.cwd end)

local function fail(s, ...) ya.notify { title = "Skim", content = string.format(s, ...), timeout = 5, level = "error" } end

local function entry()
  local permit = ya.hide()
  local cwd = tostring(state())

  local rg_prefix = "rg --column --line-number --no-heading --color=always --smart-case "
  local child, err = Command("fzf"):args({
    "--ansi",
    "--disabled",
    -- "--query",
    -- "${*:-}",
    "--bind",
    "start:reload:" .. rg_prefix .. " {q}",
    "--bind",
    "change:reload:sleep 0.1; " .. rg_prefix .. " {q} || true",
    "--delimiter",
    ":",
    "--preview",
    "bat --color=always {1} --highlight-line {2}",
    "--preview-window",
    "up,60%,border-bottom,+{2}+3/3,~3",
    -- "--bind",
    -- "enter:become(nvim {1} +{2})"
  }):cwd(cwd):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail("Spawn `fzf` and `rg` failed with error code %s. Do you have it installed?", err)
  end

  local output, err = child:wait_with_output()
  if not output then
    return fail("Cannot read `fzf` output, error code %s", err)
  elseif not output.status.success and output.status.code ~= 130 then
    return fail("`fzf` exited with error code %s", output.status.code)
  end

  local target = output.stdout:gsub("\n$", "")
  local res = {}
  if target ~= "" then
    for _ = 1, 2 do
      local colon_pos = target:find(":")
      table.insert(res, colon_pos and target:sub(1, colon_pos - 1) or target)
      target = target:sub(colon_pos + 1)
    end
    ya.manager_emit(res[1]:find("[/\\]$") and "cd" or "reveal", { res[1] })
    -- ya.manager_emit("shell", { "kitty sh -c 'nvim " .. tostring(res[1]) .. " +" .. tostring(res[2]) .. "'", "--orphan", "--conform" })
  end
end

return { entry = entry }
