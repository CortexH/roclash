# Task: Refatorar fluxo de movimentação para seguir `Intent → Planning`

## Objetivo

Refatorar o fluxo de movimentação para que ele siga corretamente a arquitetura do sistema de Intents.

Atualmente a movimentação funciona corretamente, porém a responsabilidade entre **Intent** e **Planning** está invertida.

O objetivo desta task **não é alterar o comportamento da movimentação**, apenas reorganizar a arquitetura para que cada componente possua sua responsabilidade correta.

Ao final da implementação, a movimentação deve continuar funcionando exatamente como hoje.

---

# Situação atual

Hoje o fluxo funciona aproximadamente desta forma:

```text
MovementPlanning
        ↓
MovementIntent
        ↓
Movement...
```

O problema é que o `MovementIntent` recebe informações que pertencem ao planejamento do movimento, como por exemplo:

- caminho calculado;
- células percorridas;
- blockers encontrados;
- informações produzidas pelo algoritmo A*.

Isso faz com que o Intent deixe de representar apenas uma intenção e passe a carregar detalhes de implementação do planejamento.

Essa responsabilidade pertence ao Planning.

---

# Fluxo desejado

O novo fluxo deve seguir esta sequência:

```text
MovementIntent
        ↓
MovementIntentAcceptedEvent
        ↓
MovementIntentAcceptedHandler
        ↓
UnitMovementPlanningEvent
        ↓
applyUnitMovementPlanning
        ↓
MovementStartedEvent
        ↓
...
        ↓
MovementFinishedEvent
        ↓
VerifyAggroReachedEvent
```

---

# Responsabilidades

## MovementIntent

O Intent deve representar apenas a intenção de movimentação.

Ele deve conter apenas as informações necessárias para descrever o objetivo da movimentação, por exemplo:

- unitId;
- destination;
- motivo da movimentação (caso exista).

O Intent **não deve conter**:

- path;
- blockers;
- waypoints;
- células percorridas;
- qualquer dado produzido pelo algoritmo A*.

---

## MovementIntentAcceptedEvent

Quando o Intent for aceito, o fluxo deve continuar normalmente através do evento de accepted.

Caso seja rejeitado, o fluxo existente de rejected deve continuar funcionando normalmente.

---

## MovementIntentAcceptedHandler

Este Handler será responsável por executar o planejamento do movimento.

Ele deve:

- executar o algoritmo A*;
- gerar o caminho;
- identificar blockers encontrados;
- montar o objeto de planejamento;
- emitir um `UnitMovementPlanningEvent`.

Este Handler pertence ao módulo do NPC.

Ele não deve aplicar estado ao mundo.

Sua única responsabilidade é transformar um Intent aceito em um planejamento.

---

# UnitMovementPlanningEvent

O Handler deve emitir um evento seguindo a estrutura abaixo:

```lua
export type unitMovementPlanningEvent = {
    ["eventType"] : "UnitMovementPlanningEvent",
    ["delay"] : number,
    ["type"] : "EVENT",
    ["data"] : {
        ["unitId"] : string,
        ["startCell"] : string,
        ["path"] : {
            {
                ["fromCell"] : {x : number, y : number},
                ["toCell"] : {x : number, y : number},
                ["blocker"] : string?
            }
        },
        ["reachable"] : boolean
    }
}
```

Onde:

- `path` representa todo o caminho calculado;
- cada segmento pode possuir um `blocker`;
- `reachable` informa se o destino é alcançável.

---

# Sobre o campo `reachable`

Atualmente o sistema de Intent já identifica quando um destino não pode ser alcançado.

Portanto, espera-se que o `MovementPlanning` sempre seja gerado com sucesso.

Mesmo assim, o campo `reachable` deve permanecer no evento para manter o contrato preparado para futuras evoluções.

---

# applyUnitMovementPlanning

Após o `UnitMovementPlanningEvent`, deve existir um **Handler** chamado `applyUnitMovementPlanning`.

> Apesar do nome possuir o prefixo `apply`, este componente é um **Handler**, e não um Applier.

Ele será responsável por transformar o planejamento em eventos da simulação.

Ele deve:

- percorrer o caminho calculado;
- gerar todos os `MovementStartedEvent`;
- gerar todos os `MovementFinishedEvent`;
- manter exatamente o comportamento atual da movimentação.

Toda a lógica de geração dos eventos de movimento deve sair do fluxo atual e passar para este Handler.

Os Appliers continuam responsáveis **apenas** por atualizar o estado do mundo.

Eles **não** devem gerar novos eventos.

---

# VerifyAggroReachedEvent

Atualmente, ao finalizar a movimentação, o sistema envia diretamente um `AggroReachedEvent`.

Essa lógica deve ser alterada.

Após o **último** `MovementFinishedEvent`, deve ser emitido um novo evento:

```text
VerifyAggroReachedEvent
```

Esse evento representa apenas a necessidade de verificar se a unidade realmente chegou ao seu objetivo.

Ele **não** significa que o aggro foi alcançado.

---

# VerifyAggroReachedHandler

Nesta task, implementar apenas um Handler para esse evento.

O fluxo esperado será:

```text
MovementFinishedEvent
        ↓
VerifyAggroReachedEvent
        ↓
VerifyAggroReachedHandler
```

Nesta primeira implementação, o Handler deve apenas possuir a estrutura necessária para permitir futuras implementações.

A lógica completa será implementada posteriormente.

No futuro, este Handler será responsável por:

- verificar se o NPC realmente chegou próximo do aggro;
- caso tenha chegado, emitir `AggroReachedEvent`;
- caso ainda não tenha chegado, emitir um novo `MovementIntent` para continuar a movimentação.

Essa lógica **não precisa ser implementada agora**.

O objetivo desta task é apenas preparar a arquitetura para suportar esse fluxo.

---

# Importante

Esta task é uma **refatoração arquitetural**.

O objetivo não é alterar a lógica da movimentação.

Ao final da implementação:

- o comportamento da movimentação deve permanecer igual;
- apenas as responsabilidades entre Intent e Planning devem ser reorganizadas;
- o fluxo deve passar a refletir corretamente o modelo:

```text
MovementIntent
        ↓
MovementIntentAcceptedEvent
        ↓
MovementIntentAcceptedHandler
        ↓
UnitMovementPlanningEvent
        ↓
applyUnitMovementPlanning
        ↓
MovementStartedEvent
        ↓
...
        ↓
MovementFinishedEvent
        ↓
VerifyAggroReachedEvent
```

---

# Critérios de aceite

- [ ] O fluxo atual continua funcionando.
- [ ] O `MovementIntent` não contém mais informações de pathfinding.
- [ ] O `MovementIntentAcceptedHandler` executa o planejamento.
- [ ] O Handler gera um `UnitMovementPlanningEvent`.
- [ ] Existe um Handler chamado `applyUnitMovementPlanning`.
- [ ] `applyUnitMovementPlanning` é responsável por gerar todos os eventos de movimentação.
- [ ] Nenhum Applier gera novos eventos.
- [ ] O `MovementPlanning` deixa de ser executado antes do Intent.
- [ ] O fluxo passa a seguir `Intent → Planning`.
- [ ] Após o último `MovementFinishedEvent`, é emitido um `VerifyAggroReachedEvent`.
- [ ] Existe um `VerifyAggroReachedHandler` preparado para futuras implementações.
- [ ] Nenhum comportamento atual da movimentação foi alterado.