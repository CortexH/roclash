local module = {}

export type MovementIntent = {
    ["delay"] : number,
	["eventType"] : "MovementIntent",
	["type"] : "EVENT",
	["data"] : {
        ["unitId"] : string,
		["targetCell"] : {x:number, y:number}?,
        ["targetUnit"] : string?,
        ["reason"] : string?
	},
	["isValid"] : boolean
}

export type MovementIntentAccepted = {
	["delay"] : number,
	["eventType"] : "MovementIntentAccepted",
	["type"] : "EVENT",
	["data"] : {
        ["unitId"] : string,
		["targetCell"] : {x:number, y:number}?,
        ["targetUnit"] : string?,
        ["reason"] : string?
	},
	["isValid"] : boolean
}

export type MovementIntentRejected = {
	["delay"] : number,
	["eventType"] : "MovementIntentRejected",
	["type"] : "EVENT",
	["data"] : {
        ["unitId"] : string,
		["targetCell"] : {x:number, y:number}?,
        ["targetUnit"] : string?,
		["reason"] : "ALREADY_AT_TARGET" | "DEAD_UNIT" | "INVALID_TARGET"
	},
	["isValid"] : boolean
}

return module