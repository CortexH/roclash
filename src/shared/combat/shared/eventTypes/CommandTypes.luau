local module = {}

export type spawnUnitCommand = {
	type : "PLACE_UNIT",
	target : "UNIT",
	units : {
		[number] : {
			id : string,
			behavior : string,
			position : {x : number, y : number}
		}
	}
}

export type unitSelectCommand = {
	type : "SELECT_UNIT",
	target : "UNIT",
	signature : string,
	unitId : string
}

export type unitAggroCommand = {
	type : "AGGRO_UNIT",
	target : "UNIT",
	targetAggro : string,
	unitId : string
}

export type unitMoveCommand = {
	type : "MOVE_UNIT",
	target : "UNIT",
	targetCell : {x : number, y : number},
	unitId : string
}

export type unitPathfindingCommand = {
	type : "PATHFIND_UNIT",
	target : "UNIT",
	signature : string,
	unitId : string,
	start : {x : number, y : number},
	goal : {x : number, y : number}
}

return module
