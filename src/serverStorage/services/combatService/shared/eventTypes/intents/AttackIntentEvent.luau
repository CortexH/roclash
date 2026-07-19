local module = {}

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

export type AttackIntentFailed = {
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
        },
        ["reason"] : string
	},
	["isValid"] : boolean
}

return module