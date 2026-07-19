local module = {}

local eventLog = require(game.ReplicatedStorage.Shared.combat.shared.monitoring.ClientEventLogParams)

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

function module.eventFail(event, additionalMessage)
	if eventLog.eventFailLog == false then return end
	if not event then event = {} end
	if not event.eventType then event.eventType = "nil" end
	if not event.time then event.time = 0 end
	
	local item : logType = {
		logType = "QUEUE FAIL",
		data = {
			timestamp = os.clock(),
			eventType = event.eventType,
			eventTime = event.time,
			rawEvent = event,
			additionalMessage = additionalMessage
		}
	}
	
	log(item)
end

function module.eventEnqueued(event, additionalMessage)
	if eventLog.eventEnqueuedLog == false then return end
	
	local item :logType = {
		logType = "QUEUE SUCCESS",
		data = {
			timestamp = os.clock(),
			eventType = event.eventType,
			eventTime = event.time,
			rawEvent = event,
			additionalMessage = additionalMessage
		}
	}
	
	log(item)
	
end

function module.eventConsumed(event)
	if eventLog.eventConsumedLog == false then return end
	
	local item : logType = {
		logType = "CONSUMED",
		data = {
			timestamp = os.clock(),
			eventType = event.eventType,
			eventTime = event.time,
			rawEvent = event
		}
	}
	
	log(item)
	
end

function log(item : logType)
	print("EVENT " .. item.logType .. " - type: " .. item.data.eventType .. " - DATA ::", item)
end

return module
