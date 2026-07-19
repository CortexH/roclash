local module = {}

local domain = script.Parent.Parent.Parent.Parent.domain
local brain = require(domain.entity.Brain)

function module.createBrain()
	return brain.new()
end

return module
