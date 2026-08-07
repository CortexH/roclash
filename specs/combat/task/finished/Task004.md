# TASK — UI State Synchronization Pipeline

## 1. Objetivo

Implementar um mecanismo de sincronização do **estado atualmente observado pelo jogador** entre o servidor e o cliente.

Atualmente, o sistema já possui o fluxo de seleção/inspeção de unidades:

```text
Player
    ↓
Select / Inspect
    ↓
Query
    ↓
Server
    ↓
Interaction Pipeline
    ↓
UnitSelectQuerySuccessResponse
    ↓
Client
    ↓
UI apresenta os dados da Unit
```

Esse fluxo **já funciona e não deve ser substituído**.

O problema é o que acontece depois.

Exemplo:

```text
Player seleciona Unit A
        ↓
QuerySuccess
        ↓
UI mostra:
    Health = 100
        ↓
Unit A recebe dano
        ↓
Health = 70
        ↓
UI continua mostrando:
    Health = 100
```

A seleção inicial já está implementada.

O que falta é a capacidade de atualizar automaticamente os dados que o jogador está observando quando o estado daquilo que ele está observando muda.

---

# 2. Solução

Criar uma **terceira pipeline**, seguindo o padrão arquitetural das pipelines existentes.

Atualmente existem:

```text
Render Pipeline
Interaction Pipeline
```

A nova pipeline será responsável por traduzir mudanças no estado observado pelo jogador em uma representação de atualização que o cliente consiga aplicar à UI.

Conceitualmente:

```text
Render Pipeline
    → mudanças na representação do mundo

Interaction Pipeline
    → respostas às interações / queries do jogador

UI State Pipeline
    → mudanças no estado atualmente observado pelo jogador
```

O nome final da pipeline deve seguir as convenções já existentes no projeto. A IA deve analisar o código e escolher o nome mais apropriado.

---

# 3. Separação de Responsabilidades

Essa separação é fundamental.

## 3.1 Render Pipeline

A Render Pipeline é responsável por eventos relacionados à **renderização do mundo**.

Exemplos:

```text
Unit nasceu
Unit morreu
Unit se moveu
Unit mudou de posição
Estrutura foi criada
Estrutura foi destruída
```

Em termos conceituais:

> "Algo mudou no mundo que precisa ser representado visualmente."

A nova funcionalidade **não deve contaminar a Render Pipeline** com lógica relacionada ao estado observado pelo jogador.

---

## 3.2 Interaction Pipeline

A Interaction Pipeline é responsável por traduzir interações do jogador e suas respostas.

Exemplo existente:

```text
Player seleciona Unit
    ↓
Query
    ↓
Server
    ↓
Interaction Pipeline
    ↓
UnitSelectQuerySuccessResponse
    ↓
Client
```

A função `translateSelectQuery` existente demonstra esse padrão.

Ela recebe dados internos e produz uma representação explicitamente destinada ao cliente.

Esse comportamento deve permanecer.

A seleção inicial da unidade **não faz parte desta task**.

---

## 3.3 UI State Pipeline

A nova pipeline será responsável por outro tipo de situação:

> O jogador já está observando alguma informação, e essa informação mudou após o processamento de eventos da simulação.

Exemplo:

```text
Unit selecionada
    ↓
Health = 100

...

Unit recebe dano
    ↓
Health = 70

...

UI State Pipeline
    ↓
Unit selecionada mudou
    ↓
Client recebe atualização
    ↓
UI mostra Health = 70
```

Essa pipeline não representa uma nova interação do jogador.

Também não representa uma mudança de renderização do mundo.

Ela representa:

> **uma mudança no estado que o jogador está atualmente observando.**

---

# 4. PlayerSession

O `PlayerSession` faz parte do `BattleContext`.

Isso é intencional.

O `BattleContext` representa o contexto da batalha e contém informações que acompanham a batalha durante sua execução.

`PlayerSession` representa informações específicas da sessão do jogador dentro desse contexto.

Exemplo conceitual:

```lua
BattleContext = {
    ...,

    playerSession = {
        selectedUnitId = ...
    }
}
```

A existência de dados relacionados ao jogador dentro do `BattleContext` não significa que esses dados sejam "UI state".

Eles são parte do contexto da participação do jogador naquela batalha.

A UI State Pipeline pode utilizar esse contexto para determinar quais alterações são relevantes para aquele jogador.

---

# 5. Papel do PlayerSession na Sincronização

Considere:

```lua
PlayerSession = {
    selectedUnitId = "unit_123"
}
```

E o tick processa:

```text
DamageAppliedEvent(UnitA)
DamageAppliedEvent(UnitB)
UnitMovedEvent(UnitC)
TargetChangedEvent(UnitA)
```

A UI State Pipeline pode determinar:

```text
Player observa UnitA
        ↓
UnitA sofreu alterações
        ↓
essas alterações são relevantes
        ↓
gerar UI diff
```

Enquanto:

```text
UnitB mudou
UnitC mudou
```

podem não possuir relevância para o estado atualmente observado por aquele jogador.

O `PlayerSession` não deve ser transformado em uma cópia do estado completo da batalha.

Ele continua sendo apenas o contexto da sessão.

---

# 6. Momento de Execução

O jogo possui um tick.

O tick considera o horário atual e processa todos os eventos agendados para um timestamp menor ou igual ao horário atual.

Conceitualmente:

```text
currentTime = X

Tick
    ↓
processar todos os eventos com:
event.time <= X
    ↓
tick termina
```

As pipelines existentes são executadas ao final do tick.

A nova pipeline deve seguir esse mesmo modelo.

Conceitualmente:

```text
                    TICK
                      │
                      ▼
          processa eventos <= X
                      │
                      ▼
                Tick termina
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
       Render    Interaction   UI State
      Pipeline     Pipeline    Pipeline
          │           │           │
          ▼           ▼           ▼
       Client      Client      Client
```

A implementação deve respeitar a arquitetura existente para determinar exatamente onde a pipeline será executada.

Não criar um novo tick.

Não criar um loop separado.

Não utilizar `Heartbeat`, polling ou qualquer mecanismo paralelo para sincronização.

---

# 7. UI Diff

A UI State Pipeline deve produzir uma representação incremental das alterações relevantes para a UI.

Esse objeto pode ser chamado conceitualmente de:

```text
UIDiff
```

O nome final deve seguir as convenções existentes.

O ponto importante é:

> O diff representa **alterações de estado relevantes para a UI**, não comandos específicos de componentes visuais.

Exemplo conceitual:

```lua
{
    selectedUnit = {
        unitId = "unit_123",

        stats = {
            health = 70,
            maxHealth = 100
        }
    }
}
```

Esse diff significa:

> "A informação atualmente observada referente à Unit 123 agora possui esses valores."

Ele não deve significar:

```lua
{
    updateHealthBar = true
}
```

ou:

```lua
{
    updateUnitCard = true
}
```

ou:

```lua
{
    openInspectionModal = true
}
```

A pipeline não deve conhecer componentes específicos da UI.

---

# 8. O Diff É Específico da UI

O diff criado nesta task **não é um diff genérico do BattleContext**.

Não criar:

```text
BattleContextDiff
SessionStateDiff
WorldStateDiff
```

como mecanismo geral de sincronização.

O objetivo é exclusivamente produzir uma representação de alterações que o cliente precisa conhecer para manter a UI atualmente apresentada sincronizada.

Portanto:

```text
Server State
      ↓
eventos processados
      +
PlayerSession
      ↓
UI State Pipeline
      ↓
UI Diff
      ↓
Client
```

---

# 9. Eventos Existentes Continuam Existindo

A nova pipeline **não substitui os eventos já enviados ao cliente**.

Por exemplo, atualmente quando uma unidade morre, um evento relacionado à morte pode ser enviado ao cliente pela Render Pipeline.

Esse comportamento deve continuar.

Não transformar automaticamente:

```text
UnitDiedEvent
```

em:

```text
UIDiff
```

A UI State Pipeline é complementar às pipelines existentes.

Um mesmo evento pode ter consequências diferentes:

```text
UnitDiedEvent
    │
    ├── Render Pipeline
    │       ↓
    │   UnitDestroyed / representação visual
    │
    └── UI State Pipeline
            ↓
        estado atualmente observado
        deixou de ser válido / mudou
```

Cada pipeline deve manter sua própria responsabilidade.

---

# 10. Não Criar Diff para Cada Evento

A existência de um evento não significa automaticamente que um UI Diff precisa ser enviado.

Exemplo:

```text
UnitB sofreu dano
```

Se o jogador não estiver observando qualquer informação relacionada à UnitB, isso pode não gerar nenhuma alteração relevante para a UI daquele jogador.

Outro exemplo:

```text
UnitA sofreu dano
UnitA sofreu dano novamente
UnitA recebeu um buff
```

durante o mesmo tick.

A pipeline deve poder consolidar essas alterações em uma única representação final.

Por exemplo:

```lua
{
    selectedUnit = {
        stats = {
            health = 70
        }
    }
}
```

Não é necessário enviar três atualizações intermediárias.

---

# 11. O Diff Deve Representar o Resultado Observável

A pipeline deve ser pensada como uma transformação:

```text
Estado relevante antes do tick
        +
Eventos processados no tick
        +
PlayerSession
        ↓
Estado observável após o tick
        ↓
UIDiff
```

A intenção não é reproduzir cada mutação intermediária.

A intenção é informar ao cliente o que ele precisa saber depois que o tick terminou.

Exemplo:

```text
Antes:
Health = 100

Tick:
Damage 20
Damage 10
Buff -5

Depois:
Health = 65
```

O cliente pode receber apenas:

```lua
{
    selectedUnit = {
        stats = {
            health = 65
        }
    }
}
```

---

# 12. Exemplo Completo

## Estado inicial

```lua
PlayerSession = {
    selectedUnitId = "unit_123"
}
```

A Unit possui:

```lua
stats = {
    health = 100,
    maxHealth = 100
}
```

O jogador já realizou a query normalmente.

O cliente recebeu:

```text
UnitSelectQuerySuccessResponse
```

e mostra:

```text
Health: 100 / 100
```

---

## Tick seguinte

O servidor processa:

```text
DamageAppliedEvent
```

A Unit passa para:

```lua
stats = {
    health = 70,
    maxHealth = 100
}
```

O tick termina.

A UI State Pipeline verifica o contexto:

```text
selectedUnitId = unit_123
```

e identifica que a informação observada mudou.

Ela produz algo conceitualmente equivalente a:

```lua
{
    selectedUnit = {
        unitId = "unit_123",

        stats = {
            health = 70,
            maxHealth = 100
        }
    }
}
```

O cliente recebe esse resultado.

A UI atualiza:

```text
Health: 70 / 100
```

Sem nova query.

---

# 13. Exemplo com Alterações Múltiplas

Durante o mesmo tick:

```text
Unit A
    DamageAppliedEvent
    TargetChangedEvent

Unit B
    DamageAppliedEvent

Unit C
    MovementEvent
```

O jogador está observando Unit A.

A UI State Pipeline não precisa enviar:

```text
Update #1
Update #2
Update #3
Update #4
```

Pode produzir uma única atualização consolidada:

```lua
{
    selectedUnit = {
        unitId = "unit_A",

        stats = {
            health = 70
        },

        targetId = "unit_D"
    }
}
```

O cliente aplica a representação final.

---

# 14. A Pipeline Não Deve Executar Regras de Domínio

A UI State Pipeline não deve decidir:

```text
quanto dano uma Unit recebeu;
se uma Unit morreu;
qual é o alvo;
se uma Unit pode atacar;
qual é o caminho;
```

Essas decisões continuam pertencendo aos sistemas de domínio existentes.

A pipeline apenas traduz o estado já decidido pelo servidor para uma representação apropriada ao cliente.

Em outras palavras:

```text
Domain
    ↓
decide o que aconteceu

UI State Pipeline
    ↓
decide como representar
    informação relevante ao cliente
```

---

# 15. A Pipeline Não Deve Alterar o Estado da Simulação

A pipeline deve ser somente de leitura em relação ao estado da simulação.

Ela não deve:

* modificar `UnitState`;
* modificar `PlayerSession`;
* executar regras de combate;
* alterar eventos;
* agendar eventos;
* alterar a Event Queue;
* executar comandos.

Sua responsabilidade é produzir a representação necessária para comunicação com o cliente.

---

# 16. Não Criar Novo Módulo

Esta task **não requer um novo Module**.

A arquitetura existente já possui:

```text
Entity
Game
Interaction
Map
NPC
```

e:

```text
Render Pipeline
Interaction Pipeline
```

A nova responsabilidade deve ser implementada como uma **Pipeline**, seguindo o padrão já existente.

Não criar:

```text
UIDiffModule
UIStateModule
PlayerStateModule
SessionSyncModule
```

apenas para implementar essa funcionalidade.

---

# 17. Não Contaminar as Outras Pipelines

A nova responsabilidade não deve ser adicionada artificialmente à `RenderPipeline`.

A `RenderPipeline` possui uma responsabilidade clara:

> traduzir eventos que criam, destroem ou modificam elementos do mundo para que o cliente possa representá-los.

Exemplos:

```text
Unit nasceu
Unit morreu
Unit andou
Unit mudou de posição
```

A atualização de dados que o jogador está observando não deve ser adicionada à Render Pipeline apenas porque também termina no cliente.

Da mesma forma, não adicionar essa responsabilidade à `InteractionPipeline` apenas porque `PlayerSession` possui informações relacionadas ao jogador.

A separação conceitual deve permanecer:

```text
Render
    = mudanças no mundo

Interaction
    = respostas a interações do jogador

UI State
    = mudanças no estado atualmente observado pelo jogador
```

---

# 18. Não Substituir Query / QuerySuccess

O sistema de seleção já funciona.

O fluxo:

```text
Client
    ↓
Select Query
    ↓
Server
    ↓
Interaction Pipeline
    ↓
UnitSelectQuerySuccessResponse
    ↓
Client
```

deve permanecer exatamente como mecanismo de obtenção inicial dos dados.

A nova pipeline apenas resolve o problema posterior:

```text
QuerySuccess
    ↓
estado inicial
    ↓
eventos futuros
    ↓
UI State Pipeline
    ↓
UIDiff
    ↓
estado atualizado
```

Não refatorar a query existente sem necessidade.

---

# 19. Tradução de Dados

A nova pipeline deve seguir o mesmo princípio demonstrado pelas pipelines existentes.

Ela deve explicitamente selecionar os dados que o cliente pode receber.

Não retornar automaticamente um `UnitState` inteiro.

Por exemplo, conceitualmente:

```lua
{
    unitId = event.data.unitId,

    stats = {
        health = event.data.stats.health,
        maxHealth = event.data.stats.maxHealth
    }
}
```

é preferível a:

```lua
return unitState
```

A pipeline representa a fronteira entre o estado interno do servidor e a informação exposta ao cliente.

---

# 20. Investigação Obrigatória

Antes de implementar, a IA deve investigar o repositório e compreender:

### Battle Context

* `BattleContext`;
* `PlayerSession`;
* onde `PlayerSession` é criada;
* onde `selectedUnitId` ou equivalente é mantido;
* como o contexto é disponibilizado aos módulos/pipelines.

### Pipelines

* implementação da `RenderPipeline`;
* implementação da `InteractionPipeline`;
* como pipelines são executadas no final do tick;
* qual é o contrato de entrada;
* qual é o contrato de saída;
* como eventos traduzidos são enviados ao cliente.

### Interaction

* implementação da query de seleção;
* `translateSelectQuery`;
* `UnitSelectQuerySuccessResponse`;
* fluxo atual de seleção.

### Eventos

* como eventos consumidos pelo tick ficam disponíveis;
* como eventos são enviados ao cliente;
* eventos de dano;
* eventos de morte;
* eventos de alteração de estado relevantes.

### Frontend

* onde `UnitSelectQuerySuccessResponse` é recebido;
* como os dados da Unit são armazenados/apresentados;
* como a UI atualmente atualiza informações da Unit;
* como eventos enviados pelo servidor são consumidos.

A IA deve adaptar a implementação à estrutura real encontrada no projeto.

Não assumir nomes, caminhos ou APIs.

---

# 21. Critérios de Aceitação

## Caso 1 — Seleção existente continua funcionando

1. Jogador seleciona uma Unit.
2. Query existente é enviada.
3. `UnitSelectQuerySuccessResponse` é recebido.
4. UI apresenta os dados normalmente.

Nenhuma regressão no fluxo existente.

---

## Caso 2 — Unit selecionada recebe dano

1. Jogador está observando Unit A.
2. UI mostra Health = 100.
3. Unit A recebe dano.
4. Server atualiza o estado.
5. Tick termina.
6. UI State Pipeline detecta alteração relevante.
7. Client recebe UIDiff.
8. UI mostra o novo Health.
9. Nenhuma nova query é necessária.

---

## Caso 3 — Alteração irrelevante

1. Jogador está observando Unit A.
2. Unit B recebe dano.
3. Nenhum dado atualmente observado pelo jogador precisa ser atualizado.
4. Não enviar UIDiff desnecessário.

---

## Caso 4 — Múltiplas alterações no mesmo tick

1. Unit observada sofre várias alterações.
2. Todas são processadas no mesmo tick.
3. Pipeline produz uma representação consolidada.
4. Client recebe a atualização correspondente ao estado final observável.

---

## Caso 5 — Unidade morre

1. Unit observada morre.
2. Evento de morte continua sendo processado normalmente pela Render Pipeline.
3. UI State Pipeline também pode produzir a alteração necessária para o estado observado.
4. O comportamento da UI deve permanecer consistente com a seleção/inspection existente.

Não substituir o evento de morte existente pelo UIDiff.

---

## Caso 6 — Nenhuma alteração observável

Se nenhum evento processado no tick produzir alteração relevante para a UI daquele jogador:

```text
não enviar UIDiff vazio
```

---

# 22. Fora do Escopo

Não fazer nesta task:

* alterar regras de combate;
* alterar dano;
* alterar morte;
* alterar targeting;
* alterar NPC AI;
* alterar movimentação;
* alterar Event Queue;
* substituir o modelo atual de tick;
* criar um segundo tick;
* criar polling;
* usar `Heartbeat` para sincronização;
* substituir `QuerySuccess`;
* refatorar a seleção de unidades;
* criar um novo módulo de UI;
* transformar `PlayerSession` em uma cópia do BattleContext;
* replicar todo o estado da batalha;
* enviar todos os dados da batalha a cada tick;
* criar um sistema genérico de sincronização de estado;
* alterar a responsabilidade da Render Pipeline;
* alterar a responsabilidade da Interaction Pipeline.

O escopo é exclusivamente:

> **Criar uma pipeline responsável por traduzir mudanças no estado atualmente observado pelo jogador em atualizações incrementais para a UI, executada no fluxo normal de pipelines ao final do tick.**

---

# 23. Princípio Arquitetural Final

A arquitetura deve manter a seguinte separação:

```text
                 SERVER
                   │
            Battle Simulation
                   │
          eventos processados
                   │
       ┌───────────┼────────────┐
       │           │            │
       ▼           ▼            ▼
    RENDER     INTERACTION   UI STATE
   PIPELINE      PIPELINE    PIPELINE
       │           │            │
       │           │            │
 mundo mudou   jogador pediu   jogador
       │           │          observa algo
       │           │          que mudou
       ▼           ▼            ▼
 Render Event   Response       UI Diff
       │           │            │
       └───────────┴────────────┘
                   │
                   ▼
                 CLIENT
```

Cada pipeline deve responder a uma pergunta diferente:

### Render Pipeline

> **O que mudou no mundo?**

### Interaction Pipeline

> **O que o jogador pediu e qual é a resposta?**

### UI State Pipeline

> **O que mudou no estado que o jogador está atualmente observando?**

A nova implementação deve preservar essa separação.

---

# 24. Resultado Esperado

Depois da implementação, o fluxo completo deverá ser:

```text
Player seleciona Unit
        ↓
Interaction Query
        ↓
QuerySuccess
        ↓
UI mostra estado inicial
        ↓
        ...
        ↓
Simulação processa eventos
        ↓
Tick termina
        ↓
UI State Pipeline
        ↓
detecta alterações relevantes
        ↓
UIDiff
        ↓
Client
        ↓
UI atualiza automaticamente
```

O jogador não precisa consultar novamente a Unit para descobrir que seu estado mudou.

A UI passa a acompanhar automaticamente o estado observado, sem transformar o frontend em uma cópia completa da simulação e sem misturar responsabilidades entre Render, Interaction e UI State.
