local module = {}

local lp = game:GetService("Players").LocalPlayer

local states = script.Parent.Parent.Parent.Parent.Parent.Parent.state
local cmdResponseTypes = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.CommandResponseTypes)

local storedUnitState = require(states.StoredUnitsCache)

function module.apply(event : cmdResponseTypes.unitPlacementCommandResponse)
	
	if event.data.commandResponseType == "SUCCESS" then success(event) end
	if event.data.commandResponseType == "FAIL" then fail(event) end
end

function fail(event : cmdResponseTypes.unitPlacementCommandResponse)
end

function success(event : cmdResponseTypes.unitPlacementCommandResponse)
	local placedUnit = event.data.success.entityId
	storedUnitState.remove(placedUnit)
end

return module
