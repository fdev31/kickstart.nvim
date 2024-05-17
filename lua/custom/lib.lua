local exported = {}

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

exported.has = function(tbl, item)
	for _, v in ipairs(tbl) do
		if v == item then
			return true
		end
	end
	return false
end

exported.isWorkLaptop = file_exists("/home/fab/liberty/code")

exported.isGitMergetool = vim.env.TEXTDOMAIN == "git" or vim.env.GIT_PREFIX ~= nil

return exported
