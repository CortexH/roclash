local module = {}

local pointingService = require(script.Parent.Parent.service.PointingService)

local currentInteraction = nil

function module.setInteraction(interaction)
    if currentInteraction then
        currentInteraction:stop()
    end

    currentInteraction = interaction
    currentInteraction:start()
end


function module.getCurrentInteraction() : pointingService.PointingService
    return currentInteraction
end


function module.clearInteraction()
    if currentInteraction then
        currentInteraction:stop()
    end

    currentInteraction = nil
end


return module