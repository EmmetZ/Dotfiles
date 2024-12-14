local M = {}

function M:spot(job)
	local rows = self:spot_base(job)
	rows[#rows + 1] = ui.Row {}

	ya.spot_table(
		job,
		ui.Table(ya.list_merge(rows, require("file"):spot_base(job)))
			:area(ui.Pos { "center", w = 60, h = 20 })
			:row(1)
			:col(1)
			:col_style(ui.Style():fg("blue"))
			:cell_style(ui.Style():fg("yellow"):reverse())
			:widths { ui.Constraint.Length(14), ui.Constraint.Fill(1) }
	)
end

function M:spot_base(job)
	-- local meta, err = self.list_meta(job.file.url, "format=duration:stream=codec_name,codec_type,width,height")
	local meta, err = self.list_meta(job.file.url, "format=duration:stream=codec_name,codec_type,width,height:stream_tags=handler_name,title")
	if not meta then
		ya.err(tostring(err))
		return {}
	end

	local dur = meta.format.duration or 0
	local rows = {
		ui.Row({ "Video" }):style(ui.Style():fg("green")),
		ui.Row { "  Duration:", string.format("%d:%02d", math.floor(dur / 60), math.floor(dur % 60)) },
	}

	for i, s in ipairs(meta.streams) do
		if s.codec_type == "video" then
			rows[#rows + 1] = ui.Row { string.format("  Stream %d:", i-1), "video" }
			rows[#rows + 1] = ui.Row { "    Codec:", s.codec_name }
			rows[#rows + 1] = ui.Row { "    Size:", string.format("%dx%d", s.width, s.height) }
		elseif s.codec_type == "audio" then
			rows[#rows + 1] = ui.Row { string.format("  Stream %d:", i-1), "audio" }
			rows[#rows + 1] = ui.Row { "    Codec:", s.codec_name }
    elseif s.codec_type == "subtitle" then
			rows[#rows + 1] = ui.Row { string.format("  Stream %d:", i-1), string.format("%s", s.codec_type) }
			rows[#rows + 1] = ui.Row { "    Codec:", s.codec_name }
			if s.tags.handler_name ~= nil and string.len(s.tags.handler_name) > 0 then
			  rows[#rows + 1] = ui.Row { "    Handler:", s.tags.handler_name }
      elseif s.tags.title ~= nil and string.len(s.tags.title) > 0 then
			  rows[#rows + 1] = ui.Row { "    Title:", s.tags.title }
      end
		end
	end
	return rows
end

function M.list_meta(url, entries)
	local output, err =
		Command("ffprobe"):args({ "-v", "quiet", "-show_entries", entries, "-of", "json=c=1", tostring(url) }):output()
	if not output then
		return nil, Err("Failed to start `ffprobe`, error: " .. err)
	end

	local t = ya.json_decode(output.stdout)
	if not t then
		return nil, Err("Failed to decode `ffprobe` output: " .. output.stdout)
	elseif type(t) ~= "table" then
		return nil, Err("Invalid `ffprobe` output: " .. output.stdout)
	end

	t.format = t.format or {}
	t.streams = t.streams or {}
	return t
end

return M
