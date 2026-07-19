local module = {}

module.unitType = {
	[1] = "NPC", 
	[2] = "BUILD", 
	[3] = "CASTLE_TOWER", 
	[4] = "CASTLE"
}

export type unitDTO = {
	["maxHealth"] : number,
	["damage"] : number,
	["attackSpeed"] : number,
	["range"] : number,
	["cell"] : {x : number, y : number},
	["facing"] : number
}

return module
