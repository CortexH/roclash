export type getStructureDataReturn = {
	["structureType"] : number,
	["occupies"] : string,
	["attackerStructure"] : boolean,
	["targetConfig"] : {
		["impactShape"] : string,
		["deliveryType"] : string,
		["targetMode"] : string,
		["targetingBehavior"] : string,
		["maxTargets"] : number
	},
	["impactSize"] : number,
	["attackWindup"] : number,
	["projectileSpeed"] : number,
	["attackEndlag"] : number,
	["hitsConfig"] : {
		["quantity"] : number,
		["timeBetweenHit"] : number
	},
	["damageType"] : string
}

export type getSwordDataReturn = {
	["swordType"] : number,
	["name"] : string,
	["targetConfig"] : {
		["impactShape"] : string,
		["deliveryType"] : string,
		["targetMode"] : string,
		["maxTargets"] : number
	},
	["attackWindup"] : number,
	["attackSpeed"] : number,
	["attackEndlag"] : number,
	["hitsConfig"] : {
		["quantity"] : number,
		["timeBetweenHit"] : number
	},
	["damageType"] : string
}

return {
	getStructureData = function(structureType : number) : getStructureDataReturn
		return
	end,
	getSwordData = function(swordType : number) : getSwordDataReturn
		return
	end,
}