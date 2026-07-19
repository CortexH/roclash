local module = {}

export type unitDefinition = {
	unitId : string,
	unitOwner : string,
	unitType : "NPC" | "STRUCTURE",
	
	npcExclusive : {
		weapon : number,
		equipment : number,
		animations : {
			walk : string,
			attack : string,
			idle : string
		}
	}?,
	
	structureExclusive : {
		structureTypeId : number
	}?,

	blockCellType : string,
	
	party : string
}

return module
