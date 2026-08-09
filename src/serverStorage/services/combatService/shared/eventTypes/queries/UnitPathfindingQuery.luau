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
		goal: {x: number, y: number},
		-- Se presente, o destino é a célula da unit alvo (ex.: hover de ataque).
		goalUnitId: string?
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
		reachable: boolean,
		-- Ids das units/estruturas que bloqueiam o caminho (serão destruídas).
		blockers: {string}
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
