local module = {}

export type unitAggroCommand = {
	["delay"] : number,
	["eventType"] : "UnitAggroCommand",
	["type"] : "COMMAND",
	["requesterId"] : string,
	["data"] : {
        ["unitId"] : string,
		["targetId"] : string
	}
}

export type aggroCommandAccept = {
    ["delay"] : number,
    ["eventType"] : "AggroCommandAccept",
    ["type"] : "COMMAND",
    ["requesterId"] : string,
    ["data"] : {
        ["unitId"] : string,
        ["targetId"] : string
    }
}

export type aggroCommandReject = {
	["delay"] : number,
	["eventType"] : "AggroCommandReject",
	["type"] : "COMMAND",
	["requesterId"] : string,
	["data"] : {
		["unitId"] : string,
		["targetId"] : string
	}
}

return module