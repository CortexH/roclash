local module = {}

-- Tipos e Imports
export type UnitCardProps = {
	unitId : string,
	unitName: string,
	rarity: string,
	health: number,
	maxHealth : number,
	attackType: string,
	attackPower: number,
	attackRange: number,
	attackSpeed: number,
	aggroRange: number,

	canAttack: boolean,
	canMove: boolean,

	viewportModel: Model?,
}

export type UnitCard = typeof(module.new())

module.__index = module

local IconButton = require(script.Parent.Parent.Parent.Parent.assets.components.buttons.IconButton)
local IconLabel = require(script.Parent.Parent.Parent.Parent.assets.components.labels.IconLabel)
local ColoredViewport = require(script.Parent.Parent.Parent.Parent.assets.components.viewports.ColoredViewport)

-- Configurações de Design
local CARD_WIDTH = 280
local PADDING = 10
local BG_COLOR = Color3.fromRGB(20, 22, 28)
local STAT_BG = Color3.fromRGB(35, 38, 48)
local BORDER_COLOR = Color3.fromRGB(188, 56, 58)

local function getRarityColor(rarity: string): Color3
	local colors = {
		Common = Color3.fromRGB(180, 180, 180),
		Uncommon = Color3.fromRGB(46, 204, 113),
		Rare = Color3.fromRGB(52, 152, 219),
		Epic = Color3.fromRGB(155, 89, 182),
		Legendary = Color3.fromRGB(241, 196, 15)
	}
	return colors[rarity] or Color3.fromRGB(255, 255, 255)
end

function module.new(props: UnitCardProps)
	local self = setmetatable({}, module)

	self.unitId = props.unitId

	-- 1. Frame Principal
	local frame = Instance.new("Frame")
	frame.Name = "UnitCard"
	frame.Size = UDim2.fromOffset(CARD_WIDTH, 0) -- Deixa o tamanho inicial zerado no Y	frame.Position = UDim2.new(0, PADDING, 1, -PADDING)
	frame.AutomaticSize = Enum.AutomaticSize.Y    -- O Card cresce conforme o conteúdo
	frame.AnchorPoint = Vector2.new(0, 1)
	frame.BackgroundColor3 = BG_COLOR
	frame.ClipsDescendants = false

	self.frame = frame

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = BORDER_COLOR
	stroke.Thickness = 1.5

	-- 2. Botão de Fechar (Meio pra fora real)
	local closeButton = IconButton.create({
		iconId = "rbxassetid://107209180277993", 
		size = UDim2.fromOffset(26, 26), -- Menor e mais delicado
		position = UDim2.fromScale(.95, -0.03),
		anchorPoint = Vector2.new(0.5, 0.5),
		borderColor = Color3.fromRGB(255, 80, 80),
		accentColor = Color3.fromRGB(150, 40, 40),
		backgroundTransparency = 0
	})

	self.btnFechar = closeButton
	
	closeButton.Position = UDim2.fromScale(.95, -0.03)
	closeButton.ZIndex = 10
	closeButton.Parent = frame

	-- 3. Layout de Conteúdo
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, 0)
	content.BackgroundTransparency = 1
	content.Parent = frame

	local listLayout = Instance.new("UIListLayout", content)
	listLayout.Padding = UDim.new(0, 8)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	Instance.new("UIPadding", content).PaddingTop = UDim.new(0, 12)
	Instance.new("UIPadding", content).PaddingBottom = UDim.new(0, 18)

	-- 4. Header (LayoutOrder 1 e 2)
	local nameLabel = IconLabel.create({
		text = props.unitName,
		backgroundColor = Color3.fromRGB(15, 15, 20),
		borderColor = BORDER_COLOR,
		size = UDim2.new(0.9, 0, 0, 24),
		textAlign = Enum.TextXAlignment.Center,
	})
	nameLabel.LayoutOrder = 1
	nameLabel.Parent = content

	local rarityLabel = IconLabel.create({
		text = props.rarity,
		textColor = getRarityColor(props.rarity),
		backgroundColor = Color3.fromRGB(10, 10, 15),
		borderColor = getRarityColor(props.rarity),
		size = UDim2.new(0.6, 0, 0, 18),
		textAlign = Enum.TextXAlignment.Center,
	})
	rarityLabel.LayoutOrder = 2
	rarityLabel.Parent = content

	-- 5. Viewport (LayoutOrder 3)
	local viewFrame = Instance.new("Frame", content)
	viewFrame.LayoutOrder = 3
	viewFrame.Size = UDim2.fromOffset(130, 130) 
	viewFrame.BackgroundTransparency = 1

	local viewport = ColoredViewport.create({
		size = UDim2.fromScale(1, 1),
		worldModel = props.viewportModel,
		borderColor = getRarityColor(props.rarity)
	})
	viewport.Parent = viewFrame

	-- 6. Stats Section (LayoutOrder 4)
	local statsFrame = Instance.new("Frame", content)
	statsFrame.LayoutOrder = 4
	statsFrame.Size = UDim2.new(0.95, 0, 0, 0)
	statsFrame.AutomaticSize = Enum.AutomaticSize.Y
	statsFrame.BackgroundTransparency = 1

	local grid = Instance.new("UIGridLayout", statsFrame)
	grid.CellSize = UDim2.new(0, 125, 0, 28) -- Tamanho fixo para não achatar
	grid.CellPadding = UDim2.new(0, 6, 0, 6)
	grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local function addStat(text, icon, val, maxval)
		if not val or val == 0 then return end
		local string = text .. ": " .. tostring(val)
		if maxval ~= nil then string = text .. ": " .. tostring(val) .. "/" .. tostring(maxval) end
		local stat = IconLabel.create({
			text = string,
			backgroundColor = STAT_BG,
			borderColor = BORDER_COLOR,
			imageId = icon,
			imagePosition = "left",
			textAlign = Enum.TextXAlignment.Right,
			imageScale = 1,
			size = UDim2.fromScale(.5, 1)
		})
		stat.Parent = statsFrame
		return stat
	end

	self.hpLabel = addStat("HP", "rbxassetid://10850020485", props.health, props.maxHealth)
	addStat("Atk", "rbxassetid://10850021644", props.attackPower)
	addStat("Rng", "rbxassetid://10850022410", props.attackRange)
	addStat("Spd", "rbxassetid://10850023245", props.attackSpeed)
	addStat("Agr", "rbxassetid://10850024122", props.aggroRange)

	-- 7. Ações (AQUI ESTÁ O SEGREDO DO DESACHATE)
	local actions = Instance.new("Frame", content)
	actions.LayoutOrder = 5
	actions.Size = UDim2.new(0.9, 0, 0, 55) -- Aumentei para 55px de altura
	actions.BackgroundTransparency = 1
	actions.Parent = content

	local actionGrid = Instance.new("UIGridLayout", actions)
	-- Use Offset fixo no CellSize para garantir que o botão seja gordinho
	actionGrid.CellSize = UDim2.new(0, 75, 0, 50) 
	actionGrid.CellPadding = UDim2.new(0, 8, 0, 0)
	actionGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center

	if props.canAttack == true then 
		local btnAtacar = IconButton.create({
			iconId = "rbxassetid://100056902946725", 
			size = UDim2.fromScale(1,1), 
			borderColor = Color3.fromRGB(200, 50, 50),
			accentColor = Color3.fromRGB(200, 50, 50),
			name = "Btn_atacar",
			title = "ATACAR",
			subtitle = "Selecionar alvo"
		})
		btnAtacar.Parent = actions
		self.btnAtacar = btnAtacar
	end

	if props.canMove == true then
		local btnAndar = IconButton.create({
			iconId = "rbxassetid://84644670163497",
			size = UDim2.fromScale(1,1), 
			borderColor = Color3.fromRGB(59, 130, 246),
			accentColor = Color3.fromRGB(59, 130, 246),
			name = "Btn_andar",
			title = "MOVER",
			subtitle = "Definir destino",
			imageScale = 2
		})
		btnAndar.Parent = actions

		self.btnMover = btnAndar

	end

	--local btnDefender = IconButton.create({
	--	iconId = "rbxassetid://10850023245", 
	--	size = UDim2.fromScale(1,1), 
	--	borderColor = Color3.fromRGB(50, 200, 100),
	--	accentColor = Color3.fromRGB(50, 200, 100),
	--	name = "Btn_defender"
	--})
	
	--btnDefender.Parent = actions
	return self
end

-- Atualiza o valor de HP exibido no card.
function module:updateHealth(health, maxHealth)
	if not self.hpLabel then return end
	local text = "HP: " .. tostring(health)
	if maxHealth ~= nil then text = text .. "/" .. tostring(maxHealth) end
	IconLabel.setText(self.hpLabel, text)
end

function module:Destroy()
	self.frame:Destroy()
end

return module