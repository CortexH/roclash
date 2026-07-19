local module = {}

module.clientState = {
	placementMode = {
		currentBehavior = nil,
		currentPointedCell = nil
	},
	selection = {
		currentHoveredUnit = nil,
		currentSelectedUnit = nil
	}
}

return module
