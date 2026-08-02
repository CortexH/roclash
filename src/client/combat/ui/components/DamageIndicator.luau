local module = {}
module.__index = module

-- Componente puramente visual: representa uma ocorrência de dano.
-- Não conhece regras de gameplay, sistemas de combate ou UnitState.
-- Recebe os dados necessários e cuida somente da representação.

local RISE_HEIGHT = 2
local TEXT_COLOR = Color3.fromRGB(255, 80, 80)

function module.new(amount : number)
	local self = setmetatable({}, module)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "DamageIndicator"
	billboard.Size = UDim2.fromOffset(100, 40)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 200

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = tostring(amount)
	label.TextColor3 = TEXT_COLOR
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.GothamBold
	label.TextSize = 24

	self.billboard = billboard
	self.label = label

	return self
end

function module:attach(model : Model)
	self.billboard.Adornee = model
	self.billboard.Parent = model
end

-- t: progresso de 0 a 1 derivado de currentTime.
function module:update(t : number)
	local rise = t * RISE_HEIGHT
	self.billboard.StudsOffset = Vector3.new(0, rise, 0)
	self.label.TextTransparency = t
	self.label.TextStrokeTransparency = t
end

function module:destroy()
	self.billboard:Destroy()
end

return module

