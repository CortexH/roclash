local module = {}

export type npcOutboundDTO = {
	["uniqueId"] : string,
	["attackRange"] : number,
	["attackSpeed"] : number,
	["attackDamage"] : number,
	["aggroRange"] : number,
	["maxHealth"] : number,
	["currentHealth"] : number,
	["damageType"] : number,
	["sword"] : number,
	["equipment"] : number,
	["walkSpeed"] : number,
	["ownerId"] : string,
	["cell"] : {x : number, y : number},
	["facing"] : number,
	["config"] : {}
}

export type structureOutboundDTO = {
	
}

return module
