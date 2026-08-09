local module = {}

export type PathSegment = {
	fromCell: {x: number, y: number},
	toCell: {x: number, y: number},
	blocker: string?
}

export type UnitPathfindingQuery = {
	eventType: "UnitPathfindingQuery",
	type: "QUERY",
	delay: number,
	signature: string,
	requesterId: string,
	data: {
		unitId: string,
		start: {x: number, y: number},
		goal: {x: number, y: number}
	}
}

export type UnitPathfindingQuerySuccess = {
	eventType: "UnitPathfindingQuerySuccess",
	type: "QUERY",
	delay: number,
	signature: string,
	requesterId: string,
	data: {
		unitId: string,
		start: {x: number, y: number},
		goal: {x: number, y: number},
		path: {PathSegment},
		reachable: boolean
	}
}

export type UnitPathfindingQueryFailure = {
	eventType: "UnitPathfindingQueryFailure",
	type: "QUERY",
	delay: number,
	signature: string,
	requesterId: string,
	data: {
		unitId: string,
		reason: {
			message: string,
			type: string
		}
	}
}

return module
