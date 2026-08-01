local module = {}

-- View dedicada aos dados de versionamento de uma entidade.
-- Mantém os dados de versão separados da SelfBattleView (view de combate),
-- permitindo que o NpcModule consulte versões sem acessar o UnitsBC diretamente.
export type UnitVersionView = {
	id : string,
	movementVersion : number,
	aggroVersion : number,
	attackVersion : number,
	lifeVersion : number,
}

return module
