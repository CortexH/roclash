local module = {}

local viewRegistry = require(script.Parent.Parent.Parent.state.UnitViewRegistry)
local unitState = require(script.Parent.Parent.Parent.state.UnitStateCache)
local mapUtils = require(game.ReplicatedStorage.Shared.combat.shared.utils.PlayerMapUtils)

local battleField = game.Workspace.battleField

function module.spawn(unitId : string)
	local view = viewRegistry.get(unitId)
	
	local state = unitState.get(unitId)
		
	if not state.placed.isPlaced then return end
	
	local model = view.model
	local pos = Vector3.new(state.placed.position.X, mapUtils.getMapBaseElevation(), state.placed.position.Y)
	local angles = CFrame.Angles(0, state.placed.rotation * math.pi / 2, 0)
	
	
	model.Parent = battleField.unitsModels
	local cf = CFrame.new(pos) * angles
	model:PivotTo(cf)
	
	if state.status.attackRange then
		if model:FindFirstChild("Folder") and model:FindFirstChild("Folder"):FindFirstChild("range") then
			--model.Folder.range.Size = Vector3.new(state.status.attackRange * 2,state.status.attackRange * 2,state.status.attackRange * 2)
			model.Folder.range:Destroy()
		end
	end
	
end

function module.despawn(unitId : string)
	local view = viewRegistry.get(unitId)
	view.model:Destroy()
end

function module.kill(unitId : string)
	
end

return module
