local module = {}

local viewRegistry = require(script.Parent.Parent.Parent.state.registry.UnitViewRegistry)
local unitState = require(script.Parent.Parent.Parent.state.cache.UnitStateCache)
local definitionCache = require(script.Parent.Parent.Parent.state.cache.UnitDefinitionCache)
local inGameUnitsCache = require(script.Parent.Parent.Parent.state.cache.InGameUnitsCache)
local storedUnitsCache = require(script.Parent.Parent.Parent.state.cache.StoredUnitsCache)
local damageIndicatorRegistry = require(script.Parent.Parent.Parent.state.registry.DamageIndicatorRegistry)

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

-- Morte visual: torna a unit invisível e não selecionável.
-- A remoção real é agendada pelo UnitDiedSystem através do evento UnitRemoved.
function module.kill(unitId : string)
	local view = viewRegistry.get(unitId)
	if not view then return end
	local model = view.model
	if not model then return end

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Transparency = 1
			descendant.CanQuery = false
			descendant.CanTouch = false
			descendant.CanCollide = false
		elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
			descendant.Transparency = 1
		elseif descendant:IsA("BillboardGui") then
			-- Não desabilita o DamageIndicator: ele deve terminar sua animação normalmente.
			if descendant.Name ~= "damageIndicator" then
				descendant.Enabled = false
			end
		end
	end
end

-- Remoção real: destrói o model e limpa o estado do client.
function module.despawn(unitId : string)
	local view = viewRegistry.get(unitId)
	if not view then return end
	view.model:Destroy()

	damageIndicatorRegistry.removeByUnit(unitId)
	viewRegistry.unregister(unitId)
	unitState.unregister(unitId)
	definitionCache.unregister(unitId)
	inGameUnitsCache.remove(unitId)
	storedUnitsCache.remove(unitId)
end

return module
