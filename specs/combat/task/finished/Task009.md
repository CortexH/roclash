# Spec — Notification System

> Status: finalizada e validada.

## 1. Objetivo

Criar um sistema de notificações baseado em eventos, seguindo os padrões arquiteturais já existentes no projeto.

O sistema deve permitir que acontecimentos relevantes do backend sejam convertidos em **eventos semânticos de notificação**, que posteriormente possam ser enviados ao frontend e consumidos por ele.

O `NotificationModule` ainda **não existe** e deverá ser criado do zero.

Antes de implementar qualquer coisa, investigue a codebase e entenda como os módulos atuais funcionam.

---

## 2. Princípio principal

O backend deve decidir:

> **“Este acontecimento deve ser comunicado ao jogador?”**

O frontend deve decidir:

> **“Como essa notificação será apresentada?”**

O backend **não deve controlar UI**.

Não enviar informações como:

- posição da notificação na tela;
- duração;
- cor;
- animação;
- componente visual;
- texto final pronto para renderização, salvo se já existir algum padrão explícito no projeto que justifique isso.

O frontend continua responsável pela apresentação.

---

## 3. Eventos de notificação devem ser explícitos

Não criar um evento genérico como:

```text
NotificationCreatedEvent
```

com algo semelhante a:

```lua
notificationType = "UNIT_DIED"
```

Isso criaria um segundo sistema de tipagem de eventos dentro do próprio sistema de eventos.

Preferir eventos explícitos, por exemplo:

```text
UnitDiedNotificationEvent
UnitSpawnedNotificationEvent
HeroDiedNotificationEvent
SectorDominatedNotificationEvent
BattleFinishedNotificationEvent
```

O nome final deve seguir **as convenções já existentes na codebase**.

Se o projeto não utiliza o sufixo `Event` nesse tipo de arquivo/evento, preserve o padrão existente.

---

## 4. Diferença entre Domain Event e Notification Event

Esses conceitos não são equivalentes.

Exemplo:

```text
UnitDiedEvent
```

significa:

> Uma unidade morreu.

Enquanto:

```text
UnitDiedNotificationEvent
```

significa:

> O sistema decidiu que essa morte deve ser comunicada ao jogador.

Portanto:

```text
Domain Event
    ↓
Notification Policy
    ↓
Notification Event
```

Uma notificação **não deve existir automaticamente para todo evento do domínio**.

---

## 5. Evitar duplicação da árvore inteira de eventos

Não criar versões `Notification` para todos os eventos existentes.

Exemplos do que NÃO deve acontecer automaticamente:

```text
DamageAppliedEvent
→ DamageAppliedNotificationEvent

MovementStartedEvent
→ MovementStartedNotificationEvent

TargetAcquiredEvent
→ TargetAcquiredNotificationEvent
```

A existência de um evento de domínio não implica que ele precise gerar uma notificação.

Crie uma Notification Event apenas quando existir uma regra real dizendo que aquilo deve ser comunicado ao jogador.

A granularidade das notificações deve acompanhar **o que o jogador percebe como conceitos distintos**, e não a granularidade interna da simulação.

---

## 6. NotificationModule

Criar um novo módulo responsável exclusivamente por avaliar eventos relevantes e gerar Notification Events.

Responsabilidade conceitual:

```text
Evento acontece
    ↓
NotificationModule observa
    ↓
valida se deve gerar notificação
    ↓
retorna Notification Event
```

O módulo não deve:

- renderizar UI;
- conhecer componentes visuais;
- controlar toast/banner/feed;
- criar efeitos visuais;
- duplicar lógica de domínio pertencente a outros módulos;
- decidir regras que já pertencem ao módulo original responsável pelo evento.

Ele deve apenas aplicar **políticas de notificação**.

---

## 7. Investigação obrigatória antes da implementação

Antes de criar o módulo, investigue a estrutura atual.

Analise principalmente:

- módulos existentes;
- listeners existentes;
- appliers existentes;
- event factories;
- event types;
- registro/dispatch de listeners;
- registro/dispatch de appliers;
- pipelines que enviam eventos do backend para o frontend;
- convenções de nomes;
- organização de pastas;
- forma como os módulos recebem contexto;
- forma como os módulos retornam novos eventos;
- documentação existente em `EVENTS.md` e `MODULES.md`.

### Regra importante

**Não invente uma arquitetura paralela para notificações.**

Use os listeners, appliers e módulos já existentes como referência.

O novo sistema deve parecer parte natural da codebase atual.

Se já existir um padrão como:

```text
listener → valida → gera evento
applier → aplica mudança de estado
```

siga esse padrão.

Se notificações não precisarem de um applier próprio, não crie um apenas por simetria.

Primeiro descubra como o projeto realmente organiza esse tipo de fluxo.

---

## 8. Fluxo esperado

Exemplo conceitual:

```text
UnitDiedEvent
    ↓
NotificationModule / listener correspondente
    ↓
verifica se essa morte deve ser comunicada
    ↓
UnitDiedNotificationEvent
    ↓
pipeline apropriada
    ↓
frontend
    ↓
NotificationSystem
    ↓
frontend decide como representar
```

Outro exemplo:

```text
HeroDiedEvent
    ↓
NotificationModule
    ↓
HeroDiedNotificationEvent
```

O frontend pode posteriormente decidir algo como:

```text
HeroDiedNotificationEvent
→ banner + som
```

mas isso não pertence ao backend.

---

## 9. Escopo inicial

O objetivo desta mudança é criar **a infraestrutura inicial** do sistema de notificações.

Não tente mapear todos os eventos atuais para notificações.

Comece com um conjunto mínimo suficiente para validar a arquitetura.

Preferencialmente escolha 1 ou 2 eventos simples e já existentes na codebase para provar o fluxo.

Exemplos possíveis:

- unit spawn;
- unit death;
- hero death;

Escolha somente depois de investigar quais eventos reais existem hoje e quais se encaixam melhor.

Não invente eventos de domínio novos apenas para conseguir demonstrar o NotificationModule.

---

## 10. Frontend

O frontend deve continuar trabalhando por eventos.

Ao receber algo como:

```text
UnitDiedNotificationEvent
```

um sistema/listener de notificações no frontend poderá decidir:

- mostrar;
- ignorar;
- agrupar;
- usar toast;
- usar banner;
- usar feed;
- tocar som;
- mudar a apresentação dependendo do contexto.

Essa decisão não pertence ao backend.

Caso já exista no frontend um padrão de listeners/event handling, investigue e utilize-o como base antes de criar qualquer estrutura nova.

---

## 11. Notificações fora da batalha

A arquitetura precisa permitir futuramente que uma Notification Event possa ser consumida fora da batalha.

Exemplo futuro:

```text
BattleFinishedEvent
    ↓
BattleFinishedNotificationEvent
    ↓
    ├─ frontend da batalha
    ├─ lobby
    └─ persistência/inbox do jogador
```

Isso é importante porque existem situações onde o jogador que deve receber a informação não está participando daquela batalha em tempo real.

### Importante

Não implementar persistência, inbox offline ou push notification nesta tarefa, a menos que já exista infraestrutura pronta e seja indispensável para o fluxo mínimo.

Apenas não criar uma arquitetura que impeça isso futuramente.

---

## 12. Event payload

Cada Notification Event deve possuir um payload específico para seu significado.

Exemplo conceitual:

```lua
UnitDiedNotificationEvent = {
    data = {
        unitId = "...",
        killerId = "...", -- somente se fizer sentido e existir no evento original
    }
}
```

Não adicionar campos por especulação.

Use somente informações:

1. necessárias para o consumidor;
2. disponíveis de forma confiável no fluxo atual;
3. consistentes com os padrões de eventos já existentes.

---

## 13. Regras arquiteturais

Preservar as regras existentes do sistema:

- arquitetura event-driven;
- módulos não devem criar dependências desnecessárias entre si;
- eventos devem continuar sendo dados;
- seguir os event factories existentes, caso esse seja o padrão atual;
- seguir os padrões de typing existentes;
- seguir os padrões de listeners/appliers existentes;
- evitar lógica de UI no backend;
- evitar event types genéricos com subtype interno;
- evitar criar abstrações antes de existir necessidade real.

---

## 14. Workflow obrigatório

### 1. Entendimento

Entenda o objetivo completo da mudança antes de editar código.

### 2. Investigação

Investigue a codebase, com foco especial nos listeners, appliers, módulos, factories, event types e pipelines existentes.

### 3. Decisão

Defina como o `NotificationModule` se encaixa na arquitetura atual sem criar um padrão paralelo.

Explique brevemente a decisão antes da implementação.

### 4. Branch

Crie uma nova branch para a mudança antes de implementar, seguindo o padrão de branches existente no repositório.

### 5. Implementação

Implemente a infraestrutura mínima do NotificationModule e um fluxo inicial pequeno de Notification Events.

### 6. Revisão

Revise a implementação procurando:

- duplicação de eventos;
- responsabilidade de UI vazando para o backend;
- listeners fora do padrão;
- abstrações desnecessárias;
- inconsistências de naming;
- dependências indevidas;
- violações do fluxo event-driven existente.

### 7. Validação com o usuário

Antes de expandir o sistema para mais notificações, apresente o que foi criado e aguarde validação.

### 8. Commit / merge

Não faça merge na master sem autorização.

Solicite confirmação antes de commit final/merge, conforme o fluxo atual do projeto.

### 9. Encerramento

Resuma:

- arquivos criados;
- arquivos alterados;
- eventos adicionados;
- módulos adicionados;
- fluxo final criado;
- pontos deixados para evolução futura.

---

## 15. Documentação obrigatória

Qualquer novo evento criado deve ser documentado em:

```text
EVENTS.md
```

Se o evento participar de um fluxo existente, atualize também o fluxo correspondente dentro do `EVENTS.md`.

O novo módulo deve ser documentado em:

```text
MODULES.md
```

Documente:

- responsabilidade do `NotificationModule`;
- eventos que ele consome;
- eventos que ele pode produzir;
- limites da responsabilidade;
- relação com o frontend.

---

## 16. Critérios de aceitação

A tarefa estará correta quando:

- [ ] o `NotificationModule` existir e seguir o padrão dos módulos atuais;
- [ ] listeners/appliers existentes tiverem sido usados como referência arquitetural;
- [ ] não existir um `NotificationCreatedEvent` genérico com subtype interno;
- [ ] Notification Events forem semanticamente explícitos;
- [ ] não houver duplicação automática de todos os Domain Events;
- [ ] backend não possuir responsabilidade de apresentação de UI;
- [ ] frontend continuar livre para decidir como renderizar a notificação;
- [ ] existir pelo menos um fluxo completo de Domain Event → Notification Event;
- [ ] novos eventos estiverem documentados em `EVENTS.md`;
- [ ] `NotificationModule` estiver documentado em `MODULES.md`;
- [ ] a arquitetura continuar compatível com uma futura utilização de notificações fora da batalha;
- [ ] nenhuma expansão de escopo desnecessária tiver sido feita.

---

## 17. Regra final

A implementação deve privilegiar **consistência com a codebase atual** acima de preferências pessoais ou padrões genéricos.

Antes de criar uma nova classe, pasta, factory, listener base, applier base ou abstração:

> procure primeiro se já existe algo equivalente no projeto e use-o como referência.

O objetivo não é criar "o melhor sistema de notificações possível" isoladamente.

O objetivo é criar **o sistema de notificações que encaixa corretamente na arquitetura atual do RoClash**.
