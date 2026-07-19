local module = {}

module.__index = module

function module.new(
	range: number
)
	local self = setmetatable({}, module)
	
	self.range = range
	
	return self
end

function module:getValue()
	return self.range
end

export type RangeVO = typeof(module.new(0,0,0))


return module
