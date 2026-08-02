local module = {}

local viewRegistry = require(script.Parent.Parent.Parent.state.UnitViewRegistry)
local unitState = require(script.Parent.Parent.Parent.state.UnitStateCache)
local definitionCache = require(script.Parent.Parent.Parent.state.UnitDefinitionCache)
local inGameUnitsCache = require(script.Parent.Parent.Parent.state.InGameUnitsCache)
local storedUnitsCache = require(script.Parent.Parent.Parent.state.StoredUnitsCache)
local gameState = require(script.Parent.Parent.Parent.state.GameState)
local deadUnitRegistry = require(script.Parent.Parent.Parent.state.DeadUnitRegistry)
local damageIndicatorRegistry = require(script.Parent.Parent.Parent.state.DamageIndicatorRegistry)

local mapUtils = require(game.ReplicatedStorage.Shared.combat.shared.utils.PlayerMapUtils)

local battleField = game.Workspace.battleField

-- Tempo (em segundos) que a unit morta permanece no mundo antes da remoção real.
local DEAD_UNIT_DURATION = 5

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

-- Morte visual: torna a unit invisível e não selecionável, e agenda a remoção real.
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
			if descendant.Name ~= "DamageIndicator" then
				descendant.Enabled = false
			end
		end
	end

	deadUnitRegistry.register(unitId, gameState.getCurrentTime(), DEAD_UNIT_DURATION)
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
