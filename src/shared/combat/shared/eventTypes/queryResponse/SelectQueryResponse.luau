local module = {}

export type UnitSelectQuerySuccessResponse = {
    eventType: "UnitSelectQuerySuccessResponse",
    delay: number,
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
    data: {
        unitId: string,
        reason : {
            message: string,
            type: string
        }
    }
}

return module