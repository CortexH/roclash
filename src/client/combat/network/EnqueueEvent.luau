local module = {}

local currentQueue = require(script.Parent.Parent.runtime.ClientEventQueue)

function module.enqueueEvent(event)
    currentQueue.getCurrentQueue():enqueue(event)
end

return module
