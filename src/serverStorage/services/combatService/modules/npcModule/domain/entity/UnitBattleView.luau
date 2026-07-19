local module = {}

export type UnitBattleView = {
	id: string,

	currentCell: { x: number, y: number },
	currentPosition : {X : number, Y : number},
	
	distanceToSelf: number,

	health: number,
	maxHealth: number,
	
	isAlive: boolean,
	isPlaced : boolean,

	party: string,
	isEnemy: boolean,

	inRange: boolean,
	
	observedAttackRange: number?,
	observedAttackSpeed: number?,
	observedAttackDamage: number?,

	observationConfidence: number?, -- 0 a 1
	
	unitType: "NPC" | "STRUCTURE",

	threatLevel: number,
	priority: number,

	blockingType: "ENTIRE_CELL" | "BORDER" | "ONLY_CENTER" | "ONLY_FOR_NPC",
}

return module
