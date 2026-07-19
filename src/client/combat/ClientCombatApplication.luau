local module = {}

local pl = game:GetService("Players").LocalPlayer

local guiInitiator = require(script.Parent.ui.initiator.GUIInitiator)
local clientQueueApp = require(script.Parent.ClientQueueApplication)

local api = require(game.ReplicatedStorage.Shared.combat.shared.API.Remotes)

local gameState = require(script.Parent.state.GameState)

local timeOffset = nil
local isReady = false

local tasks = {
	["ping"] = nil
}

function module.loadBattle(currentServerTime)
	guiInitiator.init()
	clientQueueApp.new(currentServerTime)
	module.requestPing()
	runPingSchedule()
end

function runPingSchedule()
	if tasks["ping"] then
		task.cancel(tasks.ping)
	end

	tasks["ping"] = task.spawn(function()
		while true do
			task.wait(5)
			module.requestPing()
		end
	end)
end

function module.requestPing()
	local t0 = os.clock()
	api.data.ping:FireServer("ping", t0)
end

api.data.ping.OnClientEvent:Connect(function(type, t0, serverTime)
	if type == "pong" then
		local t1 = os.clock()

		local rtt = t1 - t0
		local latency = rtt / 2

		local newOffset = (serverTime + latency) - t1

		if timeOffset then
			timeOffset = timeOffset + (newOffset - timeOffset) * 0.2
		else
			timeOffset = newOffset
		end

		isReady = true
	end
end)

api.start.loadBattle.OnClientEvent:Connect(function(currentServerTime)
	module.loadBattle(currentServerTime)
end)

game:GetService("RunService").Heartbeat:Connect(function()
	if not isReady then return end
	local ct = module.getTime()
	gameState.setCurrentTime(ct)
	clientQueueApp.advanceTo(ct)
end)

function module.getTime()
	return os.clock() + timeOffset
end

return module