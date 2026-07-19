local module = {}

module.applies = {
	["ProjectileLaunch"] = require(script.Parent.ProjectLauncherClientApplier).apply
}

return module
