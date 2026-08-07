local module = {}

export type UnitSelectQuery = {
    eventType: "UnitSelectQuery",
    type: "QUERY",
    delay: number,
    signature: string,
    requesterId: string,
    data: {
        unitId: string
    }
}

export type UnitSelectQuerySuccess = {
    eventType: "UnitSelectQuerySuccess",
    type: "QUERY",
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
        },
        npcUnit : {
            weapon : string,
            equipment : string,
            behavior : string,
            aggroRange : number,
            walkspeed : number
        },
        structureUnit : {
            structureType : number
        },
        canTarget : boolean,
        canMove : boolean
    }
}

export type UnitSelectQueryFailure = {
    eventType: "UnitSelectQueryFailure",
    type: "QUERY",
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