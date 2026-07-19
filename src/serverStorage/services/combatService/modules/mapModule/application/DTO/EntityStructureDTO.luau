local module = {}

export type entity = {
	["type"] : number,
	["maxLife"] : number,
	["facing"] : number,
	["uniqueId"] : number,
	["cell"] : {x : number, y : number}
}

return module
