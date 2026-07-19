local module = {}

function projectileArc(currentTime, self)
	local elapsed = currentTime - self.startTime

	-- Clamp
	elapsed = math.clamp(elapsed, 0, self.duration)

	local t = elapsed
	local T = self.duration

	local startPos = self.startPos
	local endPos = self.endPos
	-- ajustar aqui
	local gravity = Vector3.new(0, -workspace.Gravity * .5, 0)

	local displacement = endPos - startPos

	local v0 = (displacement - 0.5 * gravity * T * T) / T

	local position = startPos + v0 * t + 0.5 * gravity * t * t

	return position
end

function module.get(typeId)
	return module.functions[typeId]
end

module.functions = {
	[1] = projectileArc
}


return module
