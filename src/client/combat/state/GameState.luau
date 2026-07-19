local module = {}

module.state = {
	currentTime = 0
}

function module.setCurrentTime(ct)
	module.state.currentTime = ct
end

function module.getCurrentTime()
	return module.state.currentTime
end

return module
