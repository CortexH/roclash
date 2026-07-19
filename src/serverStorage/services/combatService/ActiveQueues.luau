local module = {}

local eventQueue = require(script.Parent.eventQueue.EventQueue)

module.activeQueues = {}

function module.getActiveQueues() : {eventQueue.queue}
	return module.activeQueues
end

function module.getActiveQueue(battleId) : eventQueue.queue
	return module.activeQueues[battleId]
end

function module.addActiveQueue(battleId, queue) : nil
	module.activeQueues[battleId] = queue
end

function module.removeActiveQueue(battleId) : nil
	module.activeQueues[battleId] = nil
end

return module
