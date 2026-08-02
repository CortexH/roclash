local module = {}

local states = script.Parent.Parent.Parent.Parent.Parent.Parent.state
local clientEvents = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

local viewRegistry = require(states.registry.ProjectileViewRegistry)
local unitViewRegistry = require(states.registry.UnitViewRegistry)

local projectileMovement = require(game.ReplicatedStorage.Shared.combat.shared.entity.UnitClientProjectileMovement)

local mapUtils = require(script.Parent.Parent.Parent.Parent.Parent.Parent.utils.MapUtils)

local render = require(script.Parent.Parent.Parent.Parent.Parent.Parent.render.projectiles.ProjectileLifecycleRender)

local httpService = game:GetService("HttpService")

function module.apply(event : clientEvents.projectileLaunch)
	
	local view = viewRegistry.create(
		event.data.source,
		event.data.projectileTypeId,
		1, -- TODO: adicionar movement para receber valores diferentes de 1
		httpService:GenerateGUID(false)
	)
		
	view.visual.movement = generateMovement(event, view)
	
	viewRegistry.register(view.registryId, view)
	render.spawn(view.registryId)
end

function generateMovement(event : clientEvents.projectileLaunch, view : typeof(viewRegistry.get(1)))
	
	local unitView = unitViewRegistry.get(event.data.source)
		
	local targetPos = Vector3.new(
		event.data.targetPosition.X,
		mapUtils.getMapBaseElevation(),
		event.data.targetPosition.Y
	)
	
	
	local movement = projectileMovement.new(
		view.registryId,
		view.movementId,
		event.time,
		event.data.timeToHit,
		unitView.visual.muzzleAttachment.WorldPosition,
		targetPos
	)
	
	return movement
	
end

return module
