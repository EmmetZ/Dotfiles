--- @since 26.8.15
--- @sync entry

local PANE = { parent = 1, current = 2, preview = 3 }

local function eq(other)
	local r = rt.mgr.ratio
	return other[1] == r[1] and other[2] == r[2] and other[3] == r[3]
end

local function get()
	local r = rt.mgr.ratio
	return { r[1], r[2], r[3] }
end

local function set(new) rt.mgr.ratio = { new[1], new[2], new[3] } end

-- The pane that takes over the units freed by hiding pane `i`, so the width
-- of every other pane stays exactly the same (e.g. 1:3:3 -> 1:6:0 instead of
-- rescaling everything to 1:3).
local function absorber(n, i)
	if i ~= PANE.current and n[PANE.current] > 0 then
		return PANE.current
	elseif i ~= PANE.preview and n[PANE.preview] > 0 then
		return PANE.preview
	end
	return PANE.parent
end

local function minimize(n, o, i, hide)
	local a = absorber(n, i)
	if hide and n[i] > 0 then
		n[a] = n[a] + n[i]
		n[i] = 0
	elseif not hide and n[i] == 0 and a ~= i then
		n[i] = math.min(o[i], n[a])
		n[a] = n[a] - n[i]
	end
end

local function entry(st, job)
	job = type(job) == "string" and { args = { job } } or job

	if not eq(st.new or {}) then
		st.new, st.old = nil, nil
	end
	local N, O = st.new or get(), st.old or get()

	local act, to = string.match(job.args[1] or "", "(.-)-(.+)")
	local i = PANE[to]
	if act == "min" then
		minimize(N, O, i, N[i] > 0)
	elseif act == "max" then
		local others = {}
		for j = 1, 3 do
			if j ~= i then
				others[#others + 1] = j
			end
		end
		local hide = N[others[1]] > 0 or N[others[2]] > 0
		minimize(N, O, others[1], hide)
		minimize(N, O, others[2], hide)
	end

	if act then
		st.new, st.old = N, O
	else
		N, st.new, st.old = O, nil, nil
	end

	set(N)
	ya.emit("app:resize", {})
end

return { entry = entry }
