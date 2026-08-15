local module = {}

local eventTypes = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.queryResponse.SelectQueryResponse)
local root = script.Parent.Parent.Parent.Parent.Parent.Parent

local cardController = require(root.ui.controllers.battleHudSubControllers.CardController)
local unitViewRegistry = require(root.state.registry.UnitViewRegistry)

local STAT_ICONS = {
    attack = "rbxassetid://128522466088567",
    attackSpeed = "rbxassetid://96444505828070",
    range = "rbxassetid://133284426978191",
    speed = "rbxassetid://134443016402946",
    aggro = "rbxassetid://99712706799376",
}

local STAT_COLORS = {
    attack = Color3.fromRGB(222, 75, 79),
    range = Color3.fromRGB(205, 207, 214),
    attackSpeed = Color3.fromRGB(230, 158, 67),
    speed = Color3.fromRGB(55, 145, 218),
    aggro = Color3.fromRGB(174, 80, 207),
}

local function appendStat(stats, key, label, value, iconId, iconColor)
    if value == nil then return end
    table.insert(stats, {
        key = key,
        label = label,
        value = value,
        iconId = iconId,
        iconColor = iconColor,
    })
end

function module.apply(event: eventTypes.UnitSelectQuerySuccessResponse)
    local unitView = unitViewRegistry.get(event.data.unitId)
    if not unitView then return end

    local unitData = event.data
    local viewportModel = unitView.model:Clone()
    local health = unitData.stats and unitData.stats.health
    local maxHealth = unitData.stats and unitData.stats.maxHealth
    
    local stats = {}
    if unitData.attacker then
        appendStat(
            stats,
            "attack",
            "Atk",
            unitData.attacker.damage,
            STAT_ICONS.attack,
            STAT_COLORS.attack
        )
        appendStat(
            stats,
            "range",
            "Rng",
            unitData.attacker.attackRange,
            STAT_ICONS.range,
            STAT_COLORS.range
        )
        appendStat(
            stats,
            "attackSpeed",
            "Atk Spd",
            unitData.attacker.attackSpeed,
            STAT_ICONS.attackSpeed,
            STAT_COLORS.attackSpeed
        )
    end

    if unitData.npcUnit then
        appendStat(
            stats,
            "walkSpeed",
            "Spd",
            unitData.npcUnit.walkspeed,
            STAT_ICONS.speed,
            STAT_COLORS.speed
        )
        appendStat(
            stats,
            "aggroRange",
            "Agr",
            unitData.npcUnit.aggroRange,
            STAT_ICONS.aggro,
            STAT_COLORS.aggro
        )
    end

    local cardData = {
        unitId = unitData.unitId,
        unitName = unitData.unitName,
        unitType = unitData.unitType,
        relationship = unitData.relationship,
        health = health,
        stats = stats,
        canAttack = unitData.canTarget,
        canMove = unitData.canMove,
        maxHealth = maxHealth,
        viewportModel = viewportModel
    }

    cardController.showSelectedUnitCard(cardData)
end

return module
