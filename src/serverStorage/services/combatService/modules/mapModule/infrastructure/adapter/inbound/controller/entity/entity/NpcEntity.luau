local module = {}

export type entity = {
	currentHealth : number,
	maxHealth : number,
	party : string,
	stats : {
		aggroRange : number,
		damage : number,
		damageType : number,
		movementSpeed : number,
		range : number,
		attackSpeed : number
	},
	uniqueId : string,
	state : {
		currentState : string,
		currentEffectState : string
	},
	cell : {
		x : number,
		y : number
	}
}

export type position = {
	["cellElevation"] : number,
	["uniqueId"] : number,
	["worldPosition"] : Vector3,
	["worldRotation"] : number,
}

return module
