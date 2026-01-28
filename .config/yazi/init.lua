-- show symlink in status bar
function Status:name()
	local h = self._tab.current.hovered
	if not h then
		return ui.Line({})
	end

	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end
	return ui.Line(" " .. h.name .. linked)
end

-- show username and hostname in header
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line({})
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)

Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end
	local name = ya.user_name(h.cha.uid) or tostring(h.cha.uid)
	if name ~= "baiyx" then
		return ui.Line({
			ui.Span(name):fg("magenta"),
			" ",
		})
	end
end, 500, Status.RIGHT)

-- disable rounded indicator
-- function Entity:padding() return " " end
-- function Linemode:padding() return " " end

-- sort files/folders by create time in Downloads folder
require("folder-rules"):setup()

-- show birth time in Downloads folder
function Linemode:custom()
	local cwd = cx.active.current.cwd
	local time = math.floor(self._file.cha.btime or 0)
	if cwd:ends_with("Downloads") then
    if time == 0 then
      return ""
    elseif os.date("%Y", time) == os.date("%Y") then
      return os.date("%m/%d %H:%M", time)
    else
      return os.date("%m/%d  %Y", time)
    end
  end
  return ""
end
