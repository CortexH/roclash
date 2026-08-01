local module = {}

export type BeginUnitSelectionClientEvent = {
    delay : number,
	eventType : "BeginUnitSelectionClientEvent",
    data : {}
}

export type StopUnitSelectionClientEvent = {
    delay : number,
	eventType : "StopUnitSelectionClientEvent",
    data : {}
}

export type BeginUnitAttackSelectionClientEvent = {
    delay : number,
	eventType : "BeginUnitAttackSelectionClientEvent",
    data : {
        unit : string
    }
}

export type StopUnitAttackSelectionClientEvent = {
    delay : number,
	eventType : "StopUnitAttackSelectionClientEvent",
    data : {
        unit : string
    }
}

return module