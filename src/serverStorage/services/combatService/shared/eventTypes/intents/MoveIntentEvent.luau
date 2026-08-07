local module = {}

export type MoveIntent = {
    ["delay"] : number,
	["eventType"] : "MoveIntent",
	["type"] : "EVENT",
	["data"] : {
        ["unitId"] : string,
		["targetCell"] : {x:number, y:number}?,
        ["targetUnit"] : string?,
        ["reason"] : string?,
        ["origin"] : {
            type : string,
            playerId : string | nil
        }?
	},
	["isValid"] : boolean
}

export type MoveIntentAccepted = {
	["delay"] : number,
	["eventType"] : "MoveIntentAccepted",
	["type"] : "EVENT",
	["data"] : {
        ["unitId"] : string,
		["targetCell"] : {x:number, y:number}?,
        ["targetUnit"] : string?,
        ["reason"] : string?,
        ["origin"] : {
            type : string,
            playerId : string | nil
        }?
	},
	["isValid"] : boolean
}

export type MoveIntentRejected = {
	["delay"] : number,
	["eventType"] : "MoveIntentRejected",
	["type"] : "EVENT",
	["data"] : {
        ["unitId"] : string,
		["targetCell"] : {x:number, y:number}?,
        ["targetUnit"] : string?,
		["reason"] : "ALREADY_AT_TARGET" | "DEAD_UNIT" | "INVALID_TARGET" | "NOT_OWNER" | "NOT_PLACED" | "CANNOT_MOVE" | "INVALID_POSITION",
        ["origin"] : {
            type : string,
            playerId : string | nil
        }?
	},
	["isValid"] : boolean
}

return module
