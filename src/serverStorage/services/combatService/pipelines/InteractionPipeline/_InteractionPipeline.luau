local module = {}

local translate = require(script.Parent.TranslateInteractionPipeline)
local endpoint = require(game.ServerStorage.Server.services.combatService.API.frontEnd.Remotes)
local playerService = game:GetService("Players")

function module.process(event, currentTime)
    return translate.translateEvent(event, currentTime)
end

function module.processInBatch(events, currentTime)
    local processedEvents = {}
    
    for _, v in events do
        local translated = module.process(v, currentTime)
        if not translated then continue end
        table.insert(processedEvents, translated)
    end
    return processedEvents
end

function module.updatePlayerState(events, currentTime)
    return module.processInBatch(events, currentTime)
end

return module