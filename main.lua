local richard = require("Richard")

local function readAll(file)
	local f = assert(io.open(file, "rb"))
	local content = f:read("*all")
	f:close()
	return content
end

local text = readAll("sample.txt")

for k,v in pairs(richard.bbcode(text).tags or {}) do
	for i,v in pairs(v) do
		print(i,v)
	end
end
