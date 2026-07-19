local module = {}

module.__index = module

export type targetMode = "SINGLE" | "MULTI" | "AOE"
export type impactShape = "POINT" | "RADIUS" | "LINE" | "CONE"-- | "AREA"
export type deliveryType = "MELEE" | "PROJECTILE" | "INSTANT"
export type targetingBehavior = "NONE" | "CHAIN" | "BOUNCE" | "PIERCE"

export type attackDamageType = "PHYSICAL" | "PROJECTILE" | "MAGIC" | "HEALING"

export type hitsConfig = {quantity : number, interval : number}
export type propagationConfig = {
	maxJumps : number,
	jumpRange : number,
	damageMultiplier : number
}

export type attackerConfig = typeof(module.new())

function module.new(
	windupTime : number,
	targetMode : targetMode,
	impactShape : impactShape,
	deliveryType : deliveryType,
	
	impactSize : number?,
	
	endlag : number,
	
	propagationConfig : propagationConfig,
	hitsConfig : hitsConfig,
	
	attackSpeed : number?,
	damageType : attackDamageType,
	maxTargets : number
)
	local self = setmetatable({}, module)
	
	self.windupTime = windupTime
	
	self.hitConfig = hitsConfig
	self.propagationConfig = propagationConfig
	
	self.effectConfig = {}

	self.impactSize = impactSize
	
	self.targetMode = targetMode
	self.impactShape = impactShape
	self.deliveryType = deliveryType
	
	self.endlag = endlag
	
	-- diferente de attack speed da unit, essa é a velocidade de ataque do atacante (em segundos)
	self.attackSpeed = attackSpeed
	
	-- apenas para ataques de projéteis, essa é a velocidade do projétil (em studs/s)
	self.projectileSpeed = attackSpeed
	
	self.damageType = damageType
	
	self:_validateData()
	
	self.maxTargets = maxTargets
	return self
end

function module:_validateData()
	if self.propagationConfig == nil then
		self.propagationConfig = {
			maxJumps = 0,
			jumpRange = 0,
			damageMultiplier = 0
		}
	end
end

function module:getDamageType()
	return self.damageType
end

function module:getEndlag()
	return self.endlag
end

function module:getWindupTime() : number
	return self.windupTime
end

function module:getHitConfig() : {quantity : number, interval : number}
	return self.hitConfig
end

function module:getPropagationConfig() : propagationConfig
	return self.propagationConfig
end

function module:getTargetMode() : targetMode
	return self.targetMode
end

function module:getImpactShape() : impactShape
	return self.impactShape
end

function module:getDeliveryType() : deliveryType
	return self.deliveryType
end

function module:getImpactSize() : number?
	return self.impactSize
end

function module:getTotalAttackTime() : number
	return self.endlag
		+ self.windupTime
		+ ((self:getHitConfig().quantity - 1) * self:getHitConfig().interval)
end

function module:getAttackProjectileTravelTime(distance)
	if self.deliveryType ~= "PROJECTILE" then return self.attackSpeed end
	return distance / self:getAttackSpeed()
end

function module:getAttackSpeed()
	return self.attackSpeed
end

function module:getMaxTargets()
	return self.maxTargets
end

return module


--[[
	targetMode:
		SINGLE → 1 alvo
		MULTI → N alvos selecionados
		AOE → todas as units inimigas dentro da área
		
	impactShape:
		POINT → alvo único
		RADIUS → explosão circular
		LINE → laser / golpe atravessando
		CONE → breath attack
		
	deliveryType:
		MELEE → golpe físico
		PROJECTILE → projétil
		INSTANT → Instantâneo
		
	targetingBehavior:
		NONE → não ataca mais de um alvo por vez
		CHAIN → vai pulando entre inimigos próximos
		BOUNCE → projétil recocheteia entre targets do mesmo range
		PIERCE → projétil atravessa inimigo
		
	hitsConfig:
		quantity → Número de ataques
		timeBetweenHit → tempo entre os ataques
		
	propagationConfig:
		maxJumps → Número máximo de projéteis que podem ser lançados
		jumpRange → Distância máxima que o projétil pode percorrer
		damageMultiplier → Multiplicador de dano para projéteis subsequentes
		
	
	
]]