# Unit Lifecycle no Client (Morte Visual vs Remoção Real)

## Objetivo

Redesenhar o ciclo de vida da unit no client para separar a **morte visual** da **remoção real do sistema**.

Atualmente, quando uma unit morre, o client destrói imediatamente o `Model` da unit. Isso impede que efeitos visuais de morte, animações de fade-out e limpeza controlada de lixo sejam implementados, e causa problemas como o Damage Indicator (que é child do model) sumir abruptamente.

A proposta é:

1. Ao receber `UnitDied`, a unit **não é apagada**. Ela é apenas **removida visualmente** (todos os elementos dentro do model ficam invisíveis) e marcada como **não selecionável** (remover `CanQuery`, `CanTouch`, etc.).
2. Posteriormente, um evento com **delay** (ex: ~5 segundos) remove de fato a unit morta do sistema (destrói o model e limpa o estado do client).
3. A unit morta não pode mais ser selecionada nem interagida.

---

## Escopo

### Incluído

* Alterar o fluxo de morte no client para não destruir o model imediatamente.
* Tornar a unit morta invisível e não selecionável.
* Agendar a remoção real da unit com um delay.
* Limpar o estado do client (registry, caches) quando a unit for removida de fato.
* Garantir que o Damage Indicator e outros efeitos anexados ao model não quebrem durante a transição.

### Fora do escopo

* Animações de morte (modelos/rigs de animação).
* Alterações no sistema de combate do servidor.
* Alterações na lógica de cálculo de dano.
* Novos efeitos visuais além do necessário para a transição de morte.

---

## Arquitetura existente

### Fluxo atual de morte

```text
Server
  ↓
UnitDiedEvent
  ↓
Render / Presentation Pipeline
  ↓
Client: UnitDied
  ↓
UnitDiedClientApplier
  ↓
UnitLifecycleRender.despawn(unitId)  →  model:Destroy()
```

O [`UnitDiedClientApplier.apply()`](src/client/combat/runtime/eventProcessor/client/appliers/UnitLifecycleClientApplier/UnitDiedClientApplier.luau:12) atualmente:

* seta `state.placed = false`, `state.health = 0`, `state.maxHealth = 0`, `state.owner = nil`;
* chama `render.despawn(unitId)`, que destrói o model.

O [`UnitLifecycleRender.despawn()`](src/client/combat/render/unit/UnitLifecycleRender.luau:34) destrói o model imediatamente.

### Problemas do fluxo atual

* O model é destruído na hora, impedindo animações de morte e fade-out.
* Elementos anexados ao model (ex: Damage Indicator) são destruídos junto.
* Não há limpeza controlada de lixo no client.

---

## Comportamento proposto

### 1. Morte visual (imediata)

Ao receber `UnitDied`:

* A unit permanece no mundo, mas fica **invisível** (todos os descendentes do model com `Transparency`/`Visible` são ocultados).
* A unit fica **não selecionável** e **não interativa** (remover `CanQuery`, `CanTouch`, `CanCollide` conforme aplicável).
* O estado do client é atualizado (`state.placed = false`, `state.health = 0`, etc.).

### 2. Remoção real (com delay)

Após um delay (ex: ~5 segundos), a unit é removida de fato:

* O model é destruído.
* O estado é limpo dos registries/caches do client (`UnitViewRegistry`, `UnitStateCache`, `InGameUnitsCache`, etc.).

O delay deve ser implementado de forma **determinística**, seguindo o mesmo modelo temporal do sistema de renderização (baseado em `currentTime`), e não através de timers independentes (`task.wait`).

---

## Considerações de design

* A separação entre "morte visual" e "remoção real" desacopla a apresentação da simulação.
* Permite implementar futuramente: animação de morte, fade-out, e limpeza de lixo no client.
* O Damage Indicator e outros efeitos anexados ao model devem ser tratados de forma que não quebrem durante a transição (ex: o indicador pode ser desanexado do model antes da remoção, ou a remoção pode aguardar o fim da duração do indicador).

---

## Critérios de aceitação

* [ ] Ao receber `UnitDied`, a unit não é destruída imediatamente.
* [ ] A unit morta fica invisível e não selecionável.
* [ ] A remoção real da unit ocorre após um delay determinístico.
* [ ] O estado do client é limpo quando a unit é removida de fato.
* [ ] O Damage Indicator e outros efeitos anexados ao model não quebram durante a transição.
* [ ] Nenhum timer independente ou animação não determinística é introduzido.
* [ ] Nenhuma alteração no sistema de combate do servidor é feita.

---

## Resultado esperado

```text
Server
  ↓
UnitDied
  ↓
Client: morte visual (invisível, não selecionável)
  ↓
(delay determinístico baseado em currentTime)
  ↓
Client: remoção real (model destruído, estado limpo)
```
