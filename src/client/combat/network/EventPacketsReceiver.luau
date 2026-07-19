local module = {}

local eventPacketsReceiver = require(game.ReplicatedStorage.Shared.combat.shared.API.Remotes).data.toFront.packetsEvent
local currentQueue = require(script.Parent.Parent.runtime.ClientEventQueue)

eventPacketsReceiver.OnClientEvent:Connect(function(events, currentTime)
	local queue = currentQueue.getCurrentQueue()
	for _, v in events do
		queue:enqueue(v)
	end
end)

return module
