local Richard = {}

function Richard.bbcode_catchTags(str)
	--We're catching tags here!
	local tags = {}
	local tagLenghtAcummulator = 0

	for tagStart, tag in str:gmatch("()(%[.-%])") do
		local newTag = {}
		local tagProperties = {}
		local tagName = false

		--Capture properties
		--Key value pairs only
		for k, v in string.gmatch(tag, "([^%s=%[%]]+)=(%w+)") do
			tagProperties[k] = v
		end

		--We assume that the first property is indeed the tag's name
		for k in string.gmatch(tag, "([^%s=%[%]]+)") do
			if not tagName then tagName = k end
		end

		newTag.cleanStart = tagStart - tagLenghtAcummulator
		newTag.name = tagName or ""
		newTag.length = tag:len() or 0
		newTag.position = tagStart
		newTag.properties = tagProperties or {}
		newTag.raw = tag

		--print(tagStart, tag:len(), str:sub(tagStart, tagStart + tag:len() - 1))
		--print(tagStart - tagLenghtAcummulator)
		table.insert(tags, newTag)
		tagLenghtAcummulator = tagLenghtAcummulator + tag:len()
	end

	return tags
end

function Richard.bbcode_cleanText(str)
	local newText = str:gsub("(%[.-%])", "")
	local splices = {}

	--Prepare our sorta of scissor guides
	for tagStart, tag in str:gmatch("()(%[.-%])") do
		local tagFinish = tagStart + tag:len() -- 1

		table.insert(splices, {start = tagStart, finish = tagFinish})
	end

	return newText, splices
end

function Richard.bbcode(str)
	local parsed = {}
	parsed.tags = Richard.bbcode_catchTags(str) or {}
	parsed.text = Richard.bbcode_cleanText(str) or ""
	return parsed
end

return Richard