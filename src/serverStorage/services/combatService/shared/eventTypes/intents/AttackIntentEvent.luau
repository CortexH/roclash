local module = {}

-- Definição dos motivos de falha centralizada
export type AttackIntentReason = "OUT_OF_RANGE" | "TARGET_DEAD" | "COOLDOWN_NOT_READY" | "INVALID_TARGET"

export type AttackIntent = {
    ["delay"] : number,
	["eventType"] : "AttackIntent",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
        ["target"] : {
            ["targetType"] : "POSITION" | "UNIT",
            ["id"] : string,
            ["position"] : {x:number,y:number}
        },
        ["origin"] : {
            type : string,
            playerId : string | nil
        }
	},
	["isValid"] : boolean
}

export type AttackIntentRejected = {
    ["delay"] : number,
	["eventType"] : "AttackIntentRejected",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
        ["target"] : {
            ["targetType"] : "POSITION" | "UNIT",
            ["id"] : string,
            ["position"] : {x:number,y:number}
        },
        ["origin"] : {
            type : string,
            playerId : string | nil
        },
        ["reason"] : AttackIntentReason
	},
	["isValid"] : boolean
}

export type AttackIntentAccepted = {
    ["delay"] : number,
    ["eventType"] : "AttackIntentAccepted",
    ["type"] : "EVENT",
    ["data"] : {
        ["source"] : string,
        ["target"] : {
            ["targetType"] : "POSITION" | "UNIT",
            ["id"] : string | nil,
            ["position"] : {x:number,y:number} | nil
        }
    },
    ["isValid"] : boolean
}

return module