local module = {}

export type entityDTO = {
	["type"] : number,
	["maxHealth"] : number,
	["damage"] : number,
	["attackSpeed"] : number,
	["range"] : number,
	["cell"] : {x : number, y : number},
	["facing"] : number
}

return module
