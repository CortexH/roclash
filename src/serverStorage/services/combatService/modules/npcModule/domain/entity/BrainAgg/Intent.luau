local module = {}

local BaseIntent = require(script.Parent.intents.BaseIntent)

module.__index = module

function module.new()
    local self = setmetatable({}, module)

    self.activeIntent = nil
    self.activeIntentType = nil

    self.oldIntents = {}

    return self
end

function module:getActiveIntent() : typeof(BaseIntent)
    return self.activeIntent
end

function module:getActiveIntentType() : BaseIntent.IntentType
    return self.activeIntentType
end

function module:setActiveIntent(intent : typeof(BaseIntent))
    if self:getActiveIntent() ~= nil then
        table.insert(self.oldIntents, self:getActiveIntent())
    end

    self.activeIntent = intent
    self.activeIntentType = intent:getType()
end

function module:removeActiveIntent()
    if self:getActiveIntent() == nil then return end

    table.insert(self.oldIntents, self:getActiveIntent())
    self.activeIntent = nil
    self.activeIntentType = nil
end

return module