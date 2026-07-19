local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local states = root.state
local shared = game.ReplicatedStorage.Shared.combat.shared

local clientEvents = require(shared.eventTypes.FrontEventTypes)
local movementEntity = require(shared.entity.UnitClientMovement)

local unitViews = require(states.UnitViewRegistry)
local mapUtils = require(root.utils.MapUtils)


function module.apply(event : clientEvents.unitMove)
	local view = unitViews.get(event.data.unitId)
		
	local origin = event.data.origin
	local destination = event.data.destination
			
	local movement = movementEntity.new(
		event.data.unitId,
		1, -- TODO: mudar para receber tipos distintos de movimento,
		event.time,
		event.data.movementTime,
		Vector3.new(origin.X, mapUtils.getMapBaseElevation(), origin.Y),
		Vector3.new(destination.X, mapUtils.getMapBaseElevation(), destination.Y)
	)
		
	view.visual.currentMovement = movement
end

return module
