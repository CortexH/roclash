local module = {}

local lp = game:GetService("Players").LocalPlayer

local queue = require(script.Parent.runtime.ClientEventQueue)
local clientLog = require(script.Parent.runtime.ClientEventLog)

local processor = require(script.Parent.runtime.eventProcessor.EventProcessor)

local clientQueue = nil

function module.new(currentTime)
	clientQueue = queue.new(lp.UserId, currentTime, clientLog)
	clientQueue:setProcessor(module.processEvent)
end

function module.enqueueEvent(event)
	return clientQueue:enqueue(event)
end

function module.processEvent(event)
	local createdEvents = {}

	local newEvents = processor.handle(event)

	for _, newEvent in newEvents do
		table.insert(createdEvents, newEvent)
	end
	
	clientLog.eventConsumed(event)

	for _, newEvent in createdEvents do

		module.enqueueEvent(newEvent)

	end
end

function module.advanceTo(time)
	clientQueue:advanceTo(time)
end

return module
