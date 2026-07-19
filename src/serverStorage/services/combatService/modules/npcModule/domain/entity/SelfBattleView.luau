local module = {}

export type SelfBattleView = {
	id: string,

	currentCell: { x: number, y: number },
	currentPosition : {X : number, Y : number},
	
	lastUpdatedCell : { x: number, y: number },
	lastUpdatedPosition : {X : number, Y : number},
	
	health: number,
	maxHealth: number,
	healthPercent: number,
	
	isAlive: boolean,
	isPlaced : boolean,
	
	damage: number,
	range: number,
	attackSpeed: number,
	
	aggroRange : number?,
	aggroBehavior : string?,
	
	canAttack: boolean,
	cooldownRemaining: number,

	maxTargets : number,
	
	party: string,

	isLowHealth: boolean,
	dangerLevel: number,
	
	targetingPriority : "FARTEST" | "NEAREST" | "STRONGEST" | "WEAKEST" | "HERO",
	targetingBehavior : "",
	
	hasActiveMovement : boolean,
	
}

return module
