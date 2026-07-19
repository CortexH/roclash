local module = {}

local viewRegistry = require(script.Parent.Parent.Parent.state.ProjectileViewRegistry)

function module.spawn(projectileId)
	local view = viewRegistry.get(projectileId)
	view.model.Parent = game.Workspace.battleField.projectileModels
	
	view.model:PivotTo(
		CFrame.new(view.visual.movement.startPos)
	)
	
end

function module.despawn(projectileId)
	local view = viewRegistry.get(projectileId)
	view.model:Destroy()
	viewRegistry.unregister(projectileId)
end

return module
