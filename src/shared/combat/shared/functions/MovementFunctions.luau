local module = {}

function linearMovement(currentTime, data)
	local alpha = (currentTime - data.startTime) / data.duration
	alpha = math.clamp(alpha, 0, 1)

	
	return data.startPos:Lerp(data.endPos, alpha)
end

function module.get(typeId)
	return module.functions[typeId]
end

module.functions = {
	[1] = linearMovement
}


return module
