local state = ya.sync(function() return cx.active.current.cwd end)

local function fail(s, ...) ya.notify { title = "Skim", content = string.format(s, ...), timeout = 5, level = "error" } end

local function entry()
  local permit = ya.hide()
  local cwd = tostring(state())

  local child, err =
      Command("sk"):args({
        "--ansi",
        '--color=fg:#cad3f5,bg:#24273a,matched:#363a4f,matched_bg:#f0c6c6,current:#cad3f5,current_bg:#494d64,current_match:#24273a,current_match_bg:#f4dbd6,spinner:#a6da95,info:#c6a0f6,prompt:#8aadf4,cursor:#ed8796,selected:#ee99a0,header:#8bd5ca,border:#6e738d"',
        "-i",
        "-c",
        "rg --color=always -S --line-number '{}'",
      }):cwd(cwd):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail("Spawn `skim` failed with error code %s. Do you have it installed?", err)
  end

  local output, err = child:wait_with_output()
  if not output then
    return fail("Cannot read `skim` output, error code %s", err)
  elseif not output.status.success and output.status.code ~= 130 then
    return fail("`skim` exited with error code %s", output.status.code)
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
