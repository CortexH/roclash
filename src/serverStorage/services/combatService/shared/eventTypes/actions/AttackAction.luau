local module = {}

export type AttackAction = {
    ["delay"] : number,
	["eventType"] : "AttackAction",
	["type"] : "EVENT",
	["data"] : {
        ["source"] : string,
        ["target"] : {
            ["targetType"] : "POSITION" | "UNIT",
            ["id"] : string | nil,
            ["position"] : {x:number,y:number} | nil
        },
	},
	["isValid"] : boolean
}

return module