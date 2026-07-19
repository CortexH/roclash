local module = {}

local unitDef = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitDefinitionDataType)
local unitState = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitStateDataType)
local unitView = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitView)
local modelsUtils = require(game.ReplicatedStorage.Shared.combat.shared.utils.ModelsUtils)

local mapUtils = require(script.Parent.Parent.utils.MapUtils)

function module.createStructure(def : unitDef.unitDefinition, state : unitState.unitState) : unitView.unitView
	if not state.placed.isPlaced then return nil end
	if def.unitType ~= "STRUCTURE" then return nil end
	
	local model = modelsUtils.getStructureModelById(def.structureExclusive.structureTypeId)

	model.Configuration.uniqueId.Value = def.unitId
	
	return createView(model, def.unitId, "STRUCTURE")
end

function module.createNpc(def : unitDef.unitDefinition, state : unitState.unitState) : unitView.unitView
	
	if not state.placed.isPlaced then return nil end
	if def.unitType ~= "NPC" then return nil end
	
	local model = modelsUtils.getNpcModelById(1)
	local sword, equipment = modelsUtils.getNpcEquipmentModelById()
	
	model.Configuration.uniqueId.Value = def.unitId
	
	return createNpcView(model, sword, equipment, def.unitId, "NPC")
end

function createView(model : Model, unitId, unitType : string)

	local view : unitView.unitView = {
		unitType = unitType,
		model = model,
		unitId = unitId
	}

	view.metadata = {
		modelHeight = model:GetExtentsSize().Y
	}

	view.visual = {
		muzzleAttachment = getMuzzle(model)
	}

	return view

end

function createNpcView(
	model : Model,
	sword : Model,
	equipment : Model,
	unitId : number,
	unitType : string
) : unitView.unitView
	
	local view : unitView.unitView = {
		unitType = unitType,
		model = model,
		unitId = unitId
	}
	
	view.metadata = {
		modelHeight = model:getExtentsSize().Y
	}
	
	view.visual = {}
	
	return view
	
end

function getMuzzle(model : typeof(modelsUtils.getStructureModelById(1)))
	local shootPart = model:FindFirstChild("ShootPart")
	
	if not shootPart then return nil end
	local muzzle = shootPart.Muzzle.muzzle
	
	if muzzle == nil then return nil end
	
	return muzzle
end

return module
