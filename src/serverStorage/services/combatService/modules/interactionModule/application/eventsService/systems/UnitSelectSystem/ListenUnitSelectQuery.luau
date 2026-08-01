local module = {}

local query = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.queries.UnitSelectQuery)
local entityDomain = game.ServerStorage.Server.services.combatService.modules.entityModule.domain

local unitEntity = require(entityDomain.entity.UnitEntity)


function module.handle(event : query.UnitSelectQuery, context)
    local unitId = event.data.unitId
    local unit : unitEntity.unitEntity = context["UnitsBC"]:getActiveUnitById(unitId)

    if unit:isDead() then return {generateFail(event, "DEAD_UNIT")} end

    return {generateSuccess(event, unit, context)}
end

function generateFail(event : query.UnitSelectQuery, reason : string)
    return {
        eventType = "UnitSelectQueryFailure",
        type = "QUERY",
        delay = 0,
        requesterId = event.requesterId,
        data = {
            unitId = event.data.unitId,
            reason = {
                reason = reason,
                failMessageId = ""
            }
        }
    }
end

function generateSuccess(event : query.UnitSelectQuery, unit : unitEntity.unitEntity, context)
    local npcConfig = unit:getNpcConfig()
    local npcUnit = nil
    local structureUnit = nil
    if npcConfig:getUnitType() == "NPC" then
        npcUnit = {
            weapon = npcConfig:getWeaponType(),
            equipment = npcConfig:getEquipmentType(),
            behavior = npcConfig:getBehavior(),
            aggroRange = npcConfig:getAggroRange(),
            walkspeed = npcConfig:getWalkSpeed()
        }
    elseif npcConfig:getUnitType() == "STRUCTURE" then
        structureUnit = {
            structureType = npcConfig:getStructureType()
        }
    end

    local attackerUnit = nil

    if unit:isAttacker() then
        local attacker = unit:getAttacker()
        attackerUnit = {
            damage = attacker:getDamage(),
            attackRange = attacker:getRange(),
            attackSpeed = attacker:getAttackSpeed(),
        }
    end
    
    return {
        eventType = "UnitSelectQuerySuccess",
        type = "QUERY",
        delay = 0,
        requesterId = event.requesterId,
        data = {
            unitId = event.data.unitId,
            unitType = unit:getNpcConfig():getUnitType(),
            stats = {
                health = unit:getHealth(),
                maxHealth = unit:getMaxHealth(),
            },
            attacker = attackerUnit,
            npcUnit = npcUnit,
            structureUnit = structureUnit,
            canTarget = unit:validateOwner(context["IdentityBC"].attackerPlayerId),
            canMove = unit:validateOwner(context["IdentityBC"].attackerPlayerId)
        }
    }
end

return module