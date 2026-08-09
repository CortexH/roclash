local module = {}

export type UnitSelectQuerySuccessResponse = {
    eventType: "UnitSelectQuerySuccessResponse",
    delay: number,
    signature: string,
    requesterId: string,
    data: {
        unitId: string,
        unitName: string,
        unitType : string,
        stats: {
            health: number,
            maxHealth : number,
        },
        attacker : {
            damage: number,
            attackRange: number,
            attackSpeed: number,
        }?,
        npcUnit : {
            weapon : string,
            equipment : string,
            behavior : string,
            aggroRange : number,
            walkspeed : number
        }?,
        structureUnit : {
            structureType : number
        }?,
        canTarget : boolean,
        canMove : boolean
    }
}

export type UnitSelectQueryFailureResponse = {
    eventType: "UnitSelectQueryFailureResponse",
    delay: number,
    signature: string,
    requesterId: string,
    data: {
        unitId: string,
        reason : {
            message: string,
            type: string
        }
    }
}

export type PathSegmentResponse = {
    fromCell: {x: number, y: number},
    toCell: {x: number, y: number},
    blocker: string?
}

export type UnitPathfindingQuerySuccessResponse = {
    eventType: "UnitPathfindingQuerySuccessResponse",
    delay: number,
    signature: string,
    requesterId: string,
    data: {
        unitId: string,
        start: {x: number, y: number},
        goal: {x: number, y: number},
        path: {PathSegmentResponse},
        reachable: boolean,
        blockers: {string}
    }
}

export type UnitPathfindingQueryFailureResponse = {
    eventType: "UnitPathfindingQueryFailureResponse",
    delay: number,
    signature: string,
    requesterId: string,
    data: {
        unitId: string,
        reason : {
            message: string,
            type: string
        }
    }
}

return module