local module = {}

local eventTypes = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.queryResponse.SelectQueryResponse)
local root = script.Parent.Parent.Parent.Parent.Parent.Parent

local cardController = require(root.ui.controllers.battleHudSubControllers.CardController)
local unitViewRegistry = require(root.state.registry.UnitViewRegistry)

function module.apply(event: eventTypes.UnitSelectQuerySuccessResponse)
    local unitView = unitViewRegistry.get(event.data.unitId)
    if not unitView then return end

    local unitData = event.data
    local viewportModel = unitView.model:Clone()
    
    local cardData = {
        unitId = unitData.unitId,
        unitName = unitData.unitName,
        rarity = unitData.unitType,
        health = unitData.stats.health,
        attackType = unitData.attacker and "Physical" or "None",
        attackPower = unitData.attacker and unitData.attacker.damage or 0,
        attackRange = unitData.attacker and unitData.attacker.attackRange or 0,
        attackSpeed = unitData.attacker and unitData.attacker.attackSpeed or 0,
        aggroRange = unitData.npcUnit and unitData.npcUnit.aggroRange or 0,
        canAttack = event.data.canTarget,
        canMove = event.data.canMove,
        maxHealth = event.data.stats.maxHealth or 0,
        viewportModel = viewportModel
    }

    if unitData.npcUnit then
        cardData.attackType = unitData.npcUnit.weapon or "Physical"
    end

    cardController.showSelectedUnitCard(cardData)
end

return module