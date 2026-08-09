# Débito Técnico — Recalcular path preview quando uma unit que bloqueia a visão é destruída

## Contexto

No preview de path (movimento e ataque), quando uma unit/estrutura bloqueia o caminho da unit, o path mostra o desvio (a unit dá a volta). Se a unit que **atrapalha a visão** for destruída, o path deveria ser **recalculado** automaticamente, pois o caminho direto passou a ser viável.

Atualmente, o frontend e o backend não tratam essa mudança: o preview continua mostrando o path desviado (ou não é atualizado) até o usuário refazer o hover.

## Ideia (proposta)

1. O backend deve devolver, no evento de front do preview (`UnitPathfindingQuerySuccessResponse` ou equivalente), quais units estão **atrapalhando a visão** do path (as que bloqueiam o caminho).
2. O frontend deve observar a **destruição** dessas units (`UnitDied` / `UnitRemoved`).
3. Quando qualquer unit que estava bloqueando a visão for destruída, o path deve ser **recalculado automaticamente**.

## Pontos de atenção

- Requer mudança no backend (`PathService` / `UnitPathfindingSystem`) para expor os blockers além das Walls — hoje o `AStarSegment.blocker` parece cobrir apenas Walls/BORDER, não units/estruturas que bloqueiam por serem ocupantes de célula.
- Requer mudança no frontend (preview de path) para escutar a morte das units bloqueadoras e re-disparar a query.
- **Performance:** re-disparar queries deve ser controlado (apenas quando há mudança relevante), evitando flood de `UnitPathfindingQuery`.

## Status

- [ ] Backend expõe, na resposta do preview, as units/estruturas que bloqueiam a visão do path.
- [ ] Frontend escuta a morte dessas units e recalcula o preview automaticamente.
- [ ] Controlar a frequência de re-disparo (sem flood de queries).
