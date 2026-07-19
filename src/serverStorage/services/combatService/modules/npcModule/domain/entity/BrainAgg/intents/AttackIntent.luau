local BaseIntent = require(script.Parent.BaseIntent)

local AttackIntent = {}
AttackIntent.__index = AttackIntent

setmetatable(AttackIntent, {
    __index = BaseIntent
})

function AttackIntent:new(
    timestamp: number,
    priority : number,
    origin : BaseIntent.OriginType
)
    local self = setmetatable({}, AttackIntent)

    self.time = timestamp
    self.type = "ATTACK_INTENT"

    self.priority = priority
    self.origin = origin

    return self
end

function AttackIntent:canBeOverrideBy(otherIntent : typeof(BaseIntent))

    if self:getOrigin() == "COMMAND" then
        return false
    end

    return self:getPriority() > otherIntent:getPriority()
end

return AttackIntent