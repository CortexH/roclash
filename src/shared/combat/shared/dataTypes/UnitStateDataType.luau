local module = {}

export type unitState = {
	unitId : string,
	placed : {
		isPlaced : boolean,
		position : {X : number, Y : number},
		cell : {x : number, y : number},
		rotation : number
	},
	status : unitStatus,
	currentEffects : {effect}
}

export type unitStatus = {
	maxHealth : number,
	currentHealth : number,
	aggroRange : number,
	attackRange : number,
	isDead : boolean
}

export type effect = {
	
}

return module
