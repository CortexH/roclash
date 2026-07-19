local module = {}

local eventLogModule = require(script.Parent.eventQueue.EventLog)
local eventQueue = require(script.Parent.eventQueue.EventQueue)
local eventQueueAPI = require(script.Parent.API.eventQueue.EnqueueEvent)
local activeQueues = require(script.Parent.ActiveQueues)

function module.new(id, time) : eventQueue.queue
	return eventQueue.new(id, time, eventLogModule)
end

eventQueueAPI.enqueueEvent = function(request : eventQueueAPI.request)
	request.targetQueue = tostring(request.targetQueue)
	return module.enqueueEvent(request)
end

function validateRequest(request : eventQueueAPI.request)
	if not request then return false, "Evento enviado como 'nil'" end
	if not request.targetQueue then return false, "Campo 'targetQueue' não encontrado." end
	if not request.event then return false, "Evento enviado sem 'evento'" end
	return true
end

function module.enqueueEvent(request : eventQueueAPI.request)

	local validated, err = validateRequest(request)

	if not validated then
		eventLogModule.eventFail(request, err)
		return
	end

	local activeQueue = activeQueues.getActiveQueue(request.targetQueue)

	if not activeQueue then
		eventLogModule.eventFail(request, "Event Queue com identificador '".. request.targetQueue .."' não encontrada")
		return
	end
	return activeQueue:enqueue(request)

end

function module.enqueueInBatch(request)

	local activeQueue = activeQueues.getActiveQueue(request.targetQueue)

	if not activeQueue then
		for _, v in request.events do
			eventLogModule.eventFail(v, "Event Queue com identificador '".. request.targetQueue .."' não encontrada")
		end
		return
	end

	return activeQueue:enqueueInBatch(request)

end

local modulesFolder = game.ServerStorage.Server.services.combatService.modules

local serviceModules = {
	["entityModule"] = require(modulesFolder.entityModule.EntityModule),
	["npcModule"] = require(modulesFolder.npcModule.NpcModule)
}

function module.processEvent(event, targetQueue, context)

	local createdEvents = {}

	for _, v in serviceModules do
		v.applyEvent(event, context)
	end

	for _, v in serviceModules do
		local newEvents = v.handleEvent(event, context)
		for _, newEvent in newEvents do
			table.insert(createdEvents, newEvent)
		end
	end

	eventLogModule.eventConsumed(event, targetQueue)

	for _, newEvent in createdEvents do
		module.enqueueEvent(
			newEvent
		)

	end

end

return module