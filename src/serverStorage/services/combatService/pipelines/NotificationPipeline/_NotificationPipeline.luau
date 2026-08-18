local module = {}

local filter = require(script.Parent.FilterNotificationPipeline)
local translateEvent = require(script.Parent.TranslateNotificationPipeline)

function module.process(event)
	if not filter.filterEvent(event) then
		return nil
	end

	return translateEvent.translateEvent(event)
end

function module.processInBatch(events)
	local generatedNotifications = {}

	for _, event in events do
		local notification = module.process(event)

		if notification then
			table.insert(generatedNotifications, notification)
		end
	end

	return generatedNotifications
end

return module
