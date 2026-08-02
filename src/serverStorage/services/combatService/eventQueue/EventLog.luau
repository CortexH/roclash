local module = {}

local monitorParams = require(game.ServerStorage.Server.monitoring.EventLogParams)

export type logType = {
	data : {
		timestamp : number,
		queueId : string,
		eventType : string,
		eventTime : number,
		rawEvent : {}
	},
	logType : string
}

function module.eventFail(request, additionalMessage)
	if monitorParams.eventFailLog == false then return end
	if monitorParams.onlyValid == true and request.event.isValid == false then return end
	if not verifyEventType(request.event.eventType) then return end
	if not request then request = {logType = "NIL REQUEST"} end
	if not request.targetQueue then request.targetQueue = "nil" end
	if not request.event then request.event = {} end
	if not request.event.eventType then request.event.eventType = "nil" end
	if not request.event.time then request.event.time = 0 end
	
	
	local item : logType = {
		logType = "QUEUE FAIL",
		data = {
			timestamp = os.clock(),
			queueId = request.targetQueue,
			eventType = request.event.eventType,
			eventTime = request.event.time,
			rawEvent = request.event,
			additionalMessage = additionalMessage
		}
	}
	
	log(item)
end

function module.eventEnqueued(request, additionalMessage)
	if monitorParams.eventEnqueuedLog == false then return end
	if monitorParams.onlyValid == true and request.event.isValid == false then return end
	if not verifyEventType(request.event.eventType) then return end

	local item :logType = {
		logType = "QUEUE SUCCESS",
		data = {
			timestamp = os.clock(),
			queueId = request.targetQueue,
			eventType = request.event.eventType,
			eventTime = request.event.time,
			rawEvent = request.event,
			additionalMessage = additionalMessage
		}
	}
	
	log(item)
	
end

function module.eventConsumed(event, targetQueue)
	if monitorParams.eventConsumedLog == false then return end
	if monitorParams.onlyValid == true and event.isValid == false then return end
	if not verifyEventType(event.eventType) then return end
	
	local item : logType = {
		logType = "CONSUMED",
		data = {
			timestamp = os.clock(),
			queueId = targetQueue,
			eventType = event.eventType,
			eventTime = event.time,
			rawEvent = event
		}
	}
	
	log(item)
	
end

function verifyEventType(eventType)
	for i, v in monitorParams.monitorTypes do
		if i == eventType then
			return v
		end
	end
	return true
end

function log(item : logType)
	print("[SERVER] EVENT " .. item.logType .. " - type: " .. item.data.eventType .. " - DATA ::", item)
end

return module
