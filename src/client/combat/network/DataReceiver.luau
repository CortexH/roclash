local module = {}

local lp = game:GetService("Players").LocalPlayer

local toFront = require(game.ReplicatedStorage.Shared.combat.shared.API.Remotes)
local loadDataContract = require(game.ReplicatedStorage.Shared.combat.shared.API.Contracts)

local mapConsts = require(script.Parent.Parent.consts.MapConsts)

local definitionCache = require(script.Parent.Parent.state.cache.UnitDefinitionCache)
local stateCache = require(script.Parent.Parent.state.cache.UnitStateCache)
local unitViewRegistry = require(script.Parent.Parent.state.registry.UnitViewRegistry)
local inGameUnitsCache = require(script.Parent.Parent.state.cache.InGameUnitsCache)
local storedUnitsCache = require(script.Parent.Parent.state.cache.StoredUnitsCache)

local structureRender = require(script.Parent.Parent.render.unit.UnitLifecycleRender)

toFront.data.toFront.loadData.OnClientEvent:Connect(function(data : loadDataContract.loadDataContract)
	print(data)
	updateMapConsts(data)
	updateUnitStateCache(data)
	updateUnitDefinitionCache(data)
	updateUnitViewRegistry(data)
	updateInGameUnitsCache(data)
	updateStoredUnitsCache(data)
	--renderStructures()
end)

function updateMapConsts(data)
	mapConsts.consts.mapId = data.map.mapId
	mapConsts.consts.cellSize = data.map.cellSize
	mapConsts.consts.firstCornerPosition = data.map.battleFieldFirstCornerPosition
	mapConsts.consts.lastCornerPosition = data.map.battleFieldLastCornerPosition
end

function updateUnitStateCache(data : loadDataContract.loadDataContract)
	for i, v in data.units do
		stateCache.register(i, v.state)
	end
end

function updateUnitDefinitionCache(data : loadDataContract.loadDataContract)
	for i, v in data.units do
		definitionCache.register(i, v.definition)
	end
end

function updateUnitViewRegistry(data : loadDataContract.loadDataContract)
	for i, v in data.units do
		local view = unitViewRegistry.create(v.definition, v.state)
		unitViewRegistry.register(i, view)
	end
end

function updateInGameUnitsCache(data)
	for i in data.units do
		inGameUnitsCache.register(i)
	end
end

function updateStoredUnitsCache(data : loadDataContract.loadDataContract)
	for i in data.units do
		if data.units[i].state.placed.isPlaced then continue end
		if data.units[i].definition.unitOwner ~= tostring(lp.UserId) then continue end
		storedUnitsCache.register(i)
	end
end

function renderStructures()
	for _, v in inGameUnitsCache.getAll() do
		structureRender.spawn(v)
	end
end

return module
