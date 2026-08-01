local module = {}

local domain = game.ServerStorage.Server.services.combatService.modules.entityModule.domain

local filter = require(script.Parent.FilterRenderPipeline)
local translateEvent = require(script.Parent.TranslateEventRenderPipeline)

local endpoint = require(game.ServerStorage.Server.services.combatService.API.frontEnd.Remotes)

local playerService = game:GetService("Players")

function module.process(event, currentTime)
	if not filter.filterEvent(event) then return nil end
	return translateEvent.translateEvent(event, currentTime)
end

function module.processInBatch(events, currentTime)
	local generatedRenders = {}
	
	for _, v in events do
		local render = module.process(v, currentTime)
		if not render then continue end
		table.insert(generatedRenders, render)
	end
	
	return generatedRenders
end

function module.renderEvents(events, currentTime, clientId)
	return module.processInBatch(events, currentTime)
end

return module
