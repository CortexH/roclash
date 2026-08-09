local module = {}

local UnitCard = require(script.Parent.Parent.Parent.components.UnitCard)
local eventQueue = require(script.Parent.Parent.Parent.Parent.network.EnqueueEvent)
local eventType = require(script.Parent.Parent.Parent.Parent.events.unitCard.CardAttackButtonClick)
local moveEventType = require(script.Parent.Parent.Parent.Parent.events.unitCard.CardMoveButtonClick)

local currentUnitCard = nil
local battleHudScreen = nil

local conns = {}

function module.init(selfBattleHudScreen)
    battleHudScreen = selfBattleHudScreen
end

function module.showSelectedUnitCard(unitData: UnitCard.UnitCardProps)
    module.hideSelectedUnitCard()

    -- Garante que os botões de ação comecem desligados ao exibir um novo card.
    isAtacarSelected = false
    isMoverSelected = false

    currentUnitCard = UnitCard.new({
        unitId = unitData.unitId,
        unitName = unitData.unitName,
        rarity = unitData.rarity,
        health = unitData.health,
        attackType = unitData.attackType,
        attackPower = unitData.attackPower,
        attackRange = unitData.attackRange,
        attackSpeed = unitData.attackSpeed,
        aggroRange = unitData.aggroRange,
        canMove = unitData.canMove,
        canAttack = unitData.canAttack,
        viewportModel = unitData.viewportModel,
        maxHealth = unitData.maxHealth,
    })
    
    currentUnitCard.frame.Parent = battleHudScreen.frame
    currentUnitCard.frame.Position = UDim2.fromScale(0.04, 0.95)

    table.insert(conns, currentUnitCard.btnFechar.Activated:Connect(function(inputObject, clickCount)
        module.hideSelectedUnitCard()
    end))

    if currentUnitCard.btnAtacar then
        table.insert(conns, currentUnitCard.btnAtacar.Activated:Connect(function(inputObject, clickCount)
            onAtacarClicked(unitData.unitId)
        end))
    end

    if currentUnitCard.btnMover then
        table.insert(conns, currentUnitCard.btnMover.Activated:Connect(function(inputObject, clickCount)
            onMoverClicked(unitData.unitId)
        end))
    end

end

-- Atualiza o estado observado do card atualmente exibido.
function module.updateSelectedUnitCard(unitData)
	if not currentUnitCard then return end
	if currentUnitCard.unitId ~= unitData.unitId then return end

	if unitData.stats then
		currentUnitCard:updateHealth(unitData.stats.health, unitData.stats.maxHealth)
	end

	if unitData.isDead then
		module.hideSelectedUnitCard()
	end
end

function module.hideSelectedUnitCard()
	if not currentUnitCard then return end
	currentUnitCard.frame:Destroy()

	for _, v in conns do v:Disconnect() end

	currentUnitCard = nil

	-- Reseta o estado dos botões de ação para que, ao reselecionar a unit,
	-- o primeiro clique volte a ativar a interação (e não desativar).
	isAtacarSelected = false
	isMoverSelected = false
end

-- Esconde o card apenas se ele estiver exibindo a unit informada.
function module.hideSelectedUnitCardIfUnit(unitId)
	if currentUnitCard and currentUnitCard.unitId == unitId then
		module.hideSelectedUnitCard()
	end
end

local isAtacarSelected = false

function onAtacarClicked(unitId)
    isAtacarSelected = not isAtacarSelected

    eventQueue.enqueueEvent({
        delay = 0,
        eventType = "CardAttackButtonClickedClient",
        data = {
            btnSelected = isAtacarSelected,
            unitId = unitId
        }
    })

end

local isMoverSelected = false

function onMoverClicked(unitId)
    isMoverSelected = not isMoverSelected

    eventQueue.enqueueEvent({
        delay = 0,
        eventType = "CardMoveButtonClickedClient",
        data = {
            btnSelected = isMoverSelected,
            unitId = unitId
        }
    })

end

return module