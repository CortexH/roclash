local module = {}

local pl = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")

local mouse = pl:GetMouse()

local gameConsts = require(script.Parent.Parent.consts.GameConsts)
local mapConsts = require(script.Parent.Parent.consts.MapConsts)

local interactionState = require(script.Parent.Parent.state.InteractionState)
local storedUnitsState = require(script.Parent.Parent.state.StoredUnitsCache)
local mapUtils = require(game.ReplicatedStorage.Shared.combat.shared.utils.PlayerMapUtils)

local eventsAPI = require(script.Parent.Parent.network.CommandSender)

local conns = {}

local currentModel = nil

function module.beginSpawn()
		
	local mouseConn = mouse.Move:Connect(function()
		local x, y = mouse.Hit.X, mouse.Hit.Z
		interactionState.clientState.placementMode.currentPointedCell =
			mapUtils.getCellByPosition({x = x, y = y}, mapConsts)
	end)
	
	local clickConn = mouse.Button1Down:Connect(function()
		local x, y = mouse.Hit.X, mouse.Hit.Z
		interactionState.clientState.placementMode.currentPointedCell =
			mapUtils.getCellByPosition({x = x, y = y}, mapConsts)
		triggerSpawn()
	end)
	
	table.insert(conns, mouseConn)
	table.insert(conns, clickConn)

	--currentModel = getUnitModel()
end

function triggerSpawn()	
	local request = buildRequest(storedUnitsState.getRandom(gameConsts.consts.seed))
	print(request)
	eventsAPI.sendCommand(request)
end

function module.stopSpawn()
	for _, v in conns do
		v:Disconnect()
		v = nil
	end
end

function getUnitModel()
	
end

function buildRequest(unitId)
	local request = {
		type = "PLACE_UNIT",
		target = "UNIT",
		units = {{
			entityId = unitId,
			behavior = interactionState.clientState.placementMode.currentBehavior,
			position = interactionState.clientState.placementMode.currentPointedCell
		}}
	}

	print(request)

	return request
end

return module
