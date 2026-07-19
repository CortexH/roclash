local module = {}

module.__index = module

export type position = typeof(module.new(0,0))

function module.new(X : number, Y : number)
	local self = setmetatable({}, module)
	
	self.X = X
	self.Y = Y
	
	return self
end

function module:add(other : position)
	return module.new(self.X + other.X, self.Y + other.Y)
end

function module:sub(other : position)
	return module.new(self.X - other.X, self.Y - other.Y)
end

function module:mul(scalar : number)
	return module.new(self.X * scalar, self.Y * scalar)
end

function module:div(other : number)
	return module.new(self.X / other, self.Y / other)
end

function module:dot(other : position)
	return self.X * other.X + self.Y * other.Y
end

function module:magnitudeSquared()
	return self.X * self.X + self.Y * self.Y
end

function module:distanceTo(other : position)
	return (self:sub(other)):magnitude()
end

function module:directionTo(other : position)
	return other:sub(self):normalize()
end

function module:magnitude()
	return math.sqrt(self:magnitudeSquared())
end

function module:distanceSquared(other)
	local dx = self.X - other.X
	local dy = self.Y - other.Y
	return dx * dx + dy * dy
end

function module:normalize()
	local mag = self:magnitude()

	if mag == 0 then
		return module.new(0, 0)
	end

	return self:div(mag)
end

function module:lerp(other, alpha)
	return module.new(
		self.X + (other.X - self.X) * alpha,
		self.Y + (other.Y - self.Y) * alpha
	)
end

function module:equals(other, epsilon)
	epsilon = epsilon or 1e-6

	return math.abs(self.X - other.X) <= epsilon
		and math.abs(self.Y - other.Y) <= epsilon
end

return module
