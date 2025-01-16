local M = {}

function M:spot(job)
  ya.spot_table(
    job,
    ui.Table(self:spot_base(job))
    :area(ui.Pos { "center", w = 60, h = 20 })
    :row(1)
    :col(1)
    :col_style(ui.Style():fg("blue"))
    :cell_style(ui.Style():fg("yellow"):reverse())
    :widths { ui.Constraint.Length(14), ui.Constraint.Fill(1) }
  )
end

function M:spot_base(job)
  local url, cha = job.file.url, job.file.cha
  local spotter = PLUGIN.spotter(url, job.mime)
  local previewer = PLUGIN.previewer(url, job.mime)
  local fetchers = PLUGIN.fetchers(job.file, job.mime)
  local preloaders = PLUGIN.preloaders(url, job.mime)

  for i, v in ipairs(fetchers) do
    fetchers[i] = v.cmd
  end
  for i, v in ipairs(preloaders) do
    preloaders[i] = v.cmd
  end

  local rows = {
    ui.Row({ "Base" }):style(ui.Style():fg("green")),
    ui.Row { "  Created:", cha.btime and os.date("%y/%m/%d %H:%M", math.floor(cha.btime)) or "-" },
    ui.Row { "  Modified:", cha.mtime and os.date("%y/%m/%d %H:%M", math.floor(cha.mtime)) or "-" },
    ui.Row { "  Mimetype:", job.mime },
    ui.Row {},
  }

  local sum, t = self:spot_tokei(job)
  if sum ~= 0 then
    local tokei = {
      ui.Row({ "Line" }):style(ui.Style():fg("green")),
      ui.Row { "  Code:", tostring(t.code) or "-" },
      ui.Row { "  Comments:", tostring(t.comments) or "-" },
      ui.Row { "  Blanks:", tostring(t.blanks) or "-" },
      ui.Row { "  Total:", tostring(sum) or "-" },
      ui.Row {},
    }
    rows = ya.list_merge(rows, tokei)
  end

  local plugins = {
    ui.Row({ "Plugins" }):style(ui.Style():fg("green")),
    ui.Row { "  Spotter:", spotter and spotter.cmd or "-" },
    ui.Row { "  Previewer:", previewer and previewer.cmd or "-" },
    ui.Row { "  Fetchers:", #fetchers ~= 0 and fetchers or "-" },
    ui.Row { "  Preloaders:", #preloaders ~= 0 and preloaders or "-" },
  }
  return ya.list_merge(rows, plugins)
end

function M:spot_tokei(job)
  local url = job.file.url
  local output, err = Command("tokei"):args({ tostring(url), "-o", "json" }):output()

  if not output then
    return nil, Err("Failed to start `tokei`, error: " .. err)
  end

  local t = ya.json_decode(output.stdout)
  if not t then
    return nil, Err("Failed to decode `tokei` output: " .. output.stdout)
  elseif type(t) ~= "table" then
    return nil, Err("Invalid `tokei` output: " .. output.stdout)
  end

  if not t.Total then
    return nil, Err("Failed to decode `tokei` output: " .. output.stdout)
  elseif type(t.Total) ~= "table" then
    return nil, Err("Invalid `tokei` output: " .. output.stdout)
  end

  local total = t.Total
  local blanks = total.blanks or 0
  local code = total.code or 0
  local comments = total.comments or 0
  local sum = blanks + code + comments
  return sum, total
end

return M
