## Padrão atual de interação do frontend

O frontend já possui um fluxo estabelecido para interações com Units.

O sistema de ataque deve ser utilizado como referência para implementar a movimentação.

### Fluxo existente de ataque

Quando o jogador clica no botão `ATACAR` da UnitCard:

1. O frontend emite o evento `CardAttackButtonClickedClient`.
2. A interação interrompe/cancela qualquer seleção atualmente ativa.
3. O frontend entra no modo de seleção específico para ataque.
4. Quando o jogador clica em uma Unit no campo, o frontend emite o evento correspondente à intenção de atacar aquela Unit.

### Fluxo esperado para movimentação

O sistema de movimentação deve seguir o mesmo padrão de interação existente no ataque.

Quando o jogador clica no botão `MOVER`:

1. O frontend deve iniciar a interação de movimentação.
2. Qualquer seleção atualmente ativa deve ser interrompida/cancelada.
3. O frontend deve entrar no modo de seleção do destino da movimentação.
4. Quando o jogador selecionar uma posição válida no campo, o frontend deve emitir o evento correspondente à intenção de mover a Unit para aquela posição.

### Importante

Não criar uma nova arquitetura de interação para a movimentação.

Não refatorar ou substituir o sistema de seleção existente.

O fluxo de ataque existente deve ser utilizado como referência para entender:
- como uma ação da UnitCard inicia uma interação;
- como seleções existentes são interrompidas;
- como o frontend entra em um modo de seleção específico;
- como a seleção realizada pelo jogador é transformada em um evento/comando para o backend.

A implementação deve investigar o código existente para descobrir os nomes, abstrações e contratos corretos, em vez de assumir ou inventar novos.