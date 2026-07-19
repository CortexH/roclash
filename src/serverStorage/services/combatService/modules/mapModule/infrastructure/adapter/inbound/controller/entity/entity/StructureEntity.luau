local module = {}

export type entity = {
	["uniqueId"] : number,
	["maxHealth"] : number,
	["facing"] : number,
	["cell"] : {x : number, y : number},
	["rotation"] : number,
	["position"] : {x : number, y : number, z : number}
}

export type position = {
	["cellElevation"] : number,
	["uniqueId"] : number,
	["worldPosition"] : Vector3,
	["worldRotation"] : number,
}

return module
