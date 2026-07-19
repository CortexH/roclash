local module = {}

export type StructureDataDTO = {
	["structureType"] : number,
	["attackerStructure"] : boolean,
	["health"] : {
		["maxHealth"] : number,
		["logFactor"] : number,
		["linearFactor"] : number,
	},
	["damage"] : {
		["baseDamage"] : number,
		["growthFactor"] : number
	},
	["attackRange"] : {
		["baseRange"] : number,
		["rangePerLevel"] : number,
	},
	["attackSpeed"] : {
		["baseAttackSpeed"] :number,
		["maxBonusPercent"] : number
	},
}

return module
