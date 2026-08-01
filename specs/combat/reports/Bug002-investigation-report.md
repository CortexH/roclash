# 🔍 Investigation Report — Bug 002

> Investigação da causa raiz — sem implementação de correção.

---

## Resumo

O `MovementPlanning` não identifica uma **Wall (BORDER)** posicionada na borda da célula da **Tower** quando a unit recebe a ordem explícita de atacar a torre (`* - X`).

O `UnitMovementPlanningEvent` é gerado com um segmento de caminho **sem `blocker`**, fazendo a unit considerar o caminho livre e atacar a torre sem resolver a parede.

O problema **não está no algoritmo A\*** em si, mas em duas falhas encadeadas:

1. O detector de blockers em borda (`hasWallOnBorder`) **consulta apenas a célula de origem do segmento (`cellA`)** — nunca a célula de destino (`cellB`). Como a Wall fica armazenada na célula da Tower (o destino), ela nunca é encontrada.
2. O detector chama **`unit:getFacing()`, um método que não existe** na entidade (o campo correto é `unit.currentFacing`) — a detecção, quando eventualmente encontrasse uma estrutura BORDER na célula consultada, quebraria em runtime.

Além disso, há uma falha estrutural no `PathService`: o A\* expande vizinhos verificando apenas `isCellWalkable(cell)`, **sem verificar barreiras na borda entre a célula atual e o vizinho**, e o `blocker` só é verificado **no último segmento** do caminho comprimido.

---

## Causa raiz

### 1. `hasWallOnBorder` só inspeciona `cellA` (causa imediata)

[`MapPortImpl.luau:62-84`](../src/serverStorage/services/combatService/modules/npcModule/infrastructure/adapter/outbound/gateway/MapPortImpl.luau:62)

```lua
local unitsInCell = context.UnitsBC:getActiveUnitByCell(cellA)  -- ⚠️ apenas cellA
for _, unit in pairs(unitsInCell) do
    if unit:getStructureConfig() and
        unit:getStructureConfig():getBlockCellType() == "BORDER" then
        if unit:getFacing() == borderFacing then   -- ⚠️ método inexistente
            return true, unit:getId()
        end
    end
end
```

A Wall do cenário está na **mesma célula da Tower** (cellB), com `currentFacing` apontando para a unit. A busca é feita apenas em `cellA` (célula da unit), então a Wall nunca é consultada → `blocker` sempre ausente.

**Convenção de facing** (confirmada em [`AggroDomainService.luau:9-14`](../src/serverStorage/services/combatService/modules/entityModule/domain/domainService/AggroDomainService.luau:9)):

```lua
WEST = 0, NORTH = 1, EAST = 2, SOUTH = 3
```

Ao atravessar a borda de `cellA` → `cellB`, a barreira pode estar:
- na borda de **cellA** voltada para cellB, ou
- na borda de **cellB** voltada para cellA (caso do bug).

O código atual só cobre o primeiro caso.

### 2. `unit:getFacing()` não existe (bug latente)

Busca em todo `src/` por `getFacing` retornou **apenas o uso** em `MapPortImpl.luau:77` — nenhuma definição. A entidade expõe o campo `currentFacing` ([`UnitEntity.luau:39-40,113-114`](../src/serverStorage/services/combatService/modules/entityModule/domain/entity/UnitEntity.luau:39)). O `AggroDomainService` (linha 68) usa corretamente `unit.currentFacing`.

> Consequência: mesmo corrigindo a consulta para incluir `cellB`, o código ainda lançaria erro ao chamar `unit:getFacing()`. A correção precisa usar `unit.currentFacing`.

### 3. A\* não verifica barreiras de borda na expansão (falha estrutural)

[`PathService.luau:147-163`](../src/serverStorage/services/combatService/modules/npcModule/domain/service/PathService.luau:147)

```lua
if not closedList[neighborKey] and mapPort.isCellWalkable(neighbor, context) then
```

O A\* só pergunta *"a célula vizinha está ocupada?"*, nunca *"existe uma barreira entre a célula atual e a vizinha?"*. E o `blocker` só é verificado **post-hoc no último segmento** ([`PathService.luau:129-137`](../src/serverStorage/services/combatService/modules/npcModule/domain/service/PathService.luau:129)). Walls no meio do caminho (segmentos intermediários) nunca são detectadas — o problema é geral, não exclusivo do caso vertical.

### 4. `isCellWalkable` trata BORDER como bloqueio de célula inteira (agravante)

[`MapModuleAPIImpl.luau:10-23`](../src/serverStorage/services/combatService/modules/mapModule/infrastructure/adapter/inbound/controller/MapModuleAPIImpl.luau:10)

```lua
if blockType == "ENTIRE_CELL"
or blockType == "ONLY_CENTER"
or blockType == "BORDER"
then
    return false
end
```

Uma estrutura `BORDER` torna a célula **inteira** não-walkable, o que contradiz o modelo "borda entre células" (`occupies = "BORDER"` em [`StructureUnitData.luau:27-31`](../src/serverStorage/services/combatService/modules/entityModule/infrastructure/config/unitsConfigs/StructureUnitData.luau:27)). No cenário do bug isso não altera o resultado (a célula da torre já é bloqueada por `ONLY_CENTER`), mas mascara o conceito real de barreira direcional.

---

## Evidências

| Evidência | Local |
|---|---|
| A\* expande só com `isCellWalkable(neighbor)` | [`PathService.luau:150`](../src/serverStorage/services/combatService/modules/npcModule/domain/service/PathService.luau:150) |
| `blocker` verificado apenas no último segmento | [`PathService.luau:129-137`](../src/serverStorage/services/combatService/modules/npcModule/domain/service/PathService.luau:129) |
| `hasWallOnBorder` consulta apenas `cellA` | [`MapPortImpl.luau:73`](../src/serverStorage/services/combatService/modules/npcModule/infrastructure/adapter/outbound/gateway/MapPortImpl.luau:73) |
| `unit:getFacing()` não definido em nenhum lugar | busca em `src/**` |
| Campo correto é `currentFacing` | [`UnitEntity.luau:113-114`](../src/serverStorage/services/combatService/modules/entityModule/domain/entity/UnitEntity.luau:113) |
| `AggroDomainService` compara `facingTypes[...] == unit.currentFacing` (referência de lógica correta) | [`AggroDomainService.luau:68-73`](../src/serverStorage/services/combatService/modules/entityModule/domain/domainService/AggroDomainService.luau:68) |
| `isCellWalkable` bloqueia célula inteira para BORDER | [`MapModuleAPIImpl.luau:14-18`](../src/serverStorage/services/combatService/modules/mapModule/infrastructure/adapter/inbound/controller/MapModuleAPIImpl.luau:14) |
| Wall compartilha célula com Tower (`BORDER`) | [`StructureUnitData.luau:27-31`](../src/serverStorage/services/combatService/modules/entityModule/infrastructure/config/unitsConfigs/StructureUnitData.luau:27) |
| Wall armazenada em `UnitsBC.unitsInPositions[key]` (por célula) | [`UnitsBC.luau:52-54`](../src/serverStorage/services/combatService/battleContext/UnitsBC.luau:52) |
| `getNearestPossibleCell` escolhe célula adjacente walkable da torre | [`MapPortImpl.luau:18-55`](../src/serverStorage/services/combatService/modules/npcModule/infrastructure/adapter/outbound/gateway/MapPortImpl.luau:18) |

---

## Hipóteses descartadas

| Hipótese | Veredito | Motivo |
|---|---|---|
| A\* com heurística/expansão incorreta | ❌ Descartada | O A\* encontra o caminho corretamente; o problema é a ausência de verificação de barreiras de borda e a detecção incompleta do `blocker`. |
| Targeting/aggro escolhendo alvo errado | ❌ Descartada | O bug é observável **dentro do próprio `UnitMovementPlanningEvent`** (blocker ausente), antes de qualquer decisão de targeting. |
| Célula da wall não-walkable sendo a causa | ❌ Descartada | A Wall está na célula da Tower (já não-walkable por `ONLY_CENTER`); o mecanismo de falha é a não-detecção da borda, não a walkability. |
| Bug exclusivo do caso vertical | ❌ Descartada | O problema é geral: `blocker` só no último segmento + `hasWallOnBorder` incompleto afetam qualquer wall no caminho. |

---

## Componentes envolvidos

| Componente | Papel |
|---|---|
| [`ListenMovementIntentAccepted.luau`](../src/serverStorage/services/combatService/modules/npcModule/application/eventsService/systems/MovementSystem/ListenMovementIntentAccepted.luau:31) | Orquestra o A\* e gera o `UnitMovementPlanningEvent` |
| [`PathService.luau`](../src/serverStorage/services/combatService/modules/npcModule/domain/service/PathService.luau:22) | A\* + compressão de caminho + `blocker` no último segmento |
| [`MapPortImpl.luau`](../src/serverStorage/services/combatService/modules/npcModule/infrastructure/adapter/outbound/gateway/MapPortImpl.luau:62) | `hasWallOnBorder` (falho) e `getNearestPossibleCell` |
| [`MapModuleAPIImpl.luau`](../src/serverStorage/services/combatService/modules/mapModule/infrastructure/adapter/inbound/controller/MapModuleAPIImpl.luau:10) | `isCellWalkable` (BORDER tratado como bloqueio total) |
| [`UnitEntity.luau`](../src/serverStorage/services/combatService/modules/entityModule/domain/entity/UnitEntity.luau:176) | `getStructureConfig()`; campo `currentFacing` |
| [`UnitConfig.luau`](../src/serverStorage/services/combatService/modules/entityModule/domain/entity/UnitEntityAgg/UnitConfig.luau:76) | `getBlockCellType()` |
| [`StructureUnitData.luau`](../src/serverStorage/services/combatService/modules/entityModule/infrastructure/config/unitsConfigs/StructureUnitData.luau:27) | Definição da Wall (`occupies = "BORDER"`) |
| [`UnitsBC.luau`](../src/serverStorage/services/combatService/battleContext/UnitsBC.luau:52) | Armazenamento de unidades/estruturas por célula |

---

## Nível de confiança

**Alto** para as causas 1 e 2 (evidência direta e verificável no código).

**Alto** para a causa 3 (falha estrutural do A\* em relação a barreiras de borda).

O cenário exato do teste (coordenadas das células) não foi consultado — não há arquivo de teste do MovementPlanning no código atual. Porém, o mecanismo de falha é consistente com o sintoma reportado (segmento único sem `blocker`).

---

## Solução proposta

> Direcional — sem implementação neste relatório.

1. **Corrigir `hasWallOnBorder`** para consultar **ambas as células** (`cellA` e `cellB`):
   - A barreira entre `cellA` → `cellB` pode estar na borda de `cellA` voltada para `cellB` (facing = direção do delta) **ou** na borda de `cellB` voltada para `cellA` (facing = direção oposta).
   - Seguir a convenção existente de [`AggroDomainService`](../src/serverStorage/services/combatService/modules/entityModule/domain/domainService/AggroDomainService.luau:9) (`WEST=0, NORTH=1, EAST=2, SOUTH=3`).

2. **Substituir `unit:getFacing()` por `unit.currentFacing`** (ou expor um getter real na entidade).

3. **Integrar a verificação de barreiras de borda na expansão do A\*** (`PathService`): ao mover de `currentCell` para `neighbor`, verificar se existe wall na borda entre eles — tratando-a como transição bloqueada (não como célula não-walkable). Assim walls no meio do caminho bloqueiam o A\* corretamente.

4. **Revisar `isCellWalkable`** para não tratar `BORDER` como bloqueio de célula inteira — a barreira é direcional (borda), conforme o design de `occupies = "BORDER"`.

5. **Verificar casos diagonais** após a correção, pois diagonais atravessam duas bordas (entrada por um eixo, saída por outro) — a lógica precisa definir qual borda é bloqueada na transição diagonal.

---

## Riscos

- **Risco de regressão no movimento livre**: se a verificação de borda entrar no A\* com facing invertido, units podem ficar presas ou contornar walls indevidamente. Mitigação: casos de teste com e sem wall.
- **Diagonais**: transições diagonais têm 2 bordas envolvidas; decisão de qual borda bloqueia precisa ser explícita para não quebrar o deslocamento diagonal existente.
- **Impacto no aggro/targeting**: mudanças em `isCellWalkable` podem alterar o `getNearestPossibleCell` (que usa walkability) — validar o fluxo `Unit → Wall → Tower` completo.
- **Compatibilidade com `verifyPlacementInBlockType`**: o placement de novas estruturas usa `blockCellType`; não alterar o modelo de dados sem revisar o placement.

---

## Critérios de aceite (do bug) — status de investigação

- [x] Causa da não-detecção identificada (`hasWallOnBorder` só consulta `cellA` + `getFacing` inexistente).
- [x] Confirmado que o A\* não considera barreiras de borda na expansão.
- [x] Confirmado que `blocker` só é produzido no último segmento.
- [x] Confirmado que o problema independe do behavior (ocorre no planning, antes do targeting).
