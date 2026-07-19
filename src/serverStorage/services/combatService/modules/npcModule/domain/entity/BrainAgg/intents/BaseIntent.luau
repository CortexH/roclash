local BaseIntent = {}

BaseIntent.__index = BaseIntent

export type OriginType = "COMMAND" | "SERVER"

export type IntentType =
    "ATTACK_INTENT"|
    "AGGRO_INTENT"

function BaseIntent:getType(): IntentType
    return self.type
end

function BaseIntent:getTimestamp(): number
    return self.time
end

function BaseIntent:getPriority()
    return self.priority
end

function BaseIntent:canBeOverrideBy(otherIntent : typeof(BaseIntent))
    print("FUNCTION 'canBeOverrideBy' NOT IMPLEMENTED")
end

function BaseIntent:canBeInterruptedBy(otherIntent)
    return self:getPriority() > otherIntent:getPriority()
end

function BaseIntent:getOrigin()
    return self.origin
end

return BaseIntent