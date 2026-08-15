# Spec — Redesign da Unit Card de Batalha

> Status: implementada e validada pelo usuário.

## 1. Objetivo

Redesenhar a interface de seleção de unidade exibida durante a batalha para torná-la:

- compacta;
- limpa;
- visualmente apresentável;
- fácil de ler;
- adequada para permanecer no canto inferior esquerdo da tela;
- coerente com uma interface final de jogo, e não com uma UI de debug.

A interface atual funciona, porém possui aparência muito técnica/provisória, com excesso de caixas, bordas e elementos visuais competindo entre si.

O objetivo desta tarefa **não é alterar a lógica da batalha**, e sim melhorar a apresentação visual e a organização da Unit Card.

---

## 2. Escopo

Esta tarefa deve afetar **somente a interface visual da Unit Card e seus componentes diretamente relacionados**.

A Unit Card é exibida quando o jogador seleciona uma entidade durante a batalha.

O escopo inclui:

- layout da Unit Card;
- organização das informações;
- apresentação dos atributos;
- barra de vida;
- viewport/portrait da entidade;
- botões de ação;
- tratamento de atributos opcionais;
- reaproveitamento/criação de componentes visuais quando necessário;
- pequenos ajustes estruturais necessários para tornar a UI reutilizável.

Não faz parte do escopo:

- debug mode;
- alterações na IA;
- alterações no sistema de combate;
- alterações no comportamento dos NPCs;
- novos comandos;
- novas ações;
- refatorações de backend sem relação direta com a UI;
- novos sistemas de gameplay.

---

## 3. Resultado visual desejado

A Unit Card deve continuar aparecendo no **canto inferior esquerdo da tela**.

Ela não deve ocupar uma parte significativa da área de jogo.

O jogador precisa conseguir:

1. identificar rapidamente a entidade selecionada;
2. visualizar sua vida;
3. visualizar apenas os atributos relevantes daquela entidade;
4. acessar as ações disponíveis;
5. continuar enxergando a batalha sem a interface atrapalhar.

A interface deve possuir aparência semelhante a um painel compacto de RTS/RPG.

### Direção visual

Preferir:

- fundo escuro / carvão;
- bordas discretas;
- cantos arredondados;
- espaçamento consistente;
- pequenos destaques de cor;
- tipografia com hierarquia clara;
- ícones utilizados como apoio visual;
- vermelho apenas quando possuir significado;
- azul para movimento;
- vermelho para ataque.

Evitar:

- grandes áreas vazias;
- excesso de bordas vermelhas;
- cada informação dentro de uma caixa separada;
- textos muito pequenos;
- botões muito altos;
- muitas linhas de descrição;
- aparência de painel administrativo/debug.

---

## 4. Estrutura sugerida

A organização pode ser adaptada à estrutura existente da codebase, mas o resultado visual deve seguir aproximadamente esta hierarquia:

```text
┌──────────────────────────────┐
│ NPC                    [tag] │
│                              │
│ ┌────────┐  ♥ HP   300/300   │
│ │        │  ███████████████  │
│ │VIEWPORT│                   │
│ │        │  ⚔ Atk 150  ◎ 6  │
│ └────────┘  ⚡ Spd 30  ◉ 80  │
│                              │
│ [  MOVER  ]   [  ATACAR  ]   │
└──────────────────────────────┘
```

A referência acima representa apenas a **hierarquia**, não dimensões obrigatórias.

---

## 5. Cabeçalho

A parte superior deve ser simples.

Mostrar:

- nome da entidade;
- opcionalmente um pequeno badge/tag relevante.

Exemplos de tag:

- NPC;
- INIMIGO;
- ALIADO;
- TORRE;
- PAREDE.

Não criar sistemas novos apenas para preencher essa informação.

Usar somente dados que já existam ou possam ser obtidos pela estrutura atual.

O cabeçalho não deve possuir uma grande caixa vazia acima do conteúdo.

Caso exista botão de fechar:

- deve ser pequeno;
- discreto;
- alinhado ao canto;
- não deve competir visualmente com o card.

---

## 6. Viewport / Portrait

O viewport da entidade deve continuar existindo.

Porém:

- deve ocupar menos espaço do que ocupa atualmente;
- deve estar integrado ao restante da interface;
- a entidade deve preencher melhor o viewport;
- evitar grande quantidade de espaço vazio dentro dele.

O viewport deve funcionar como identificação visual da entidade, não como elemento dominante da tela inteira.

---

## 7. Vida

A vida deve possuir prioridade visual maior do que os demais atributos.

Substituir a apresentação atual baseada apenas em texto por:

- ícone de vida;
- label;
- valor atual / máximo;
- barra horizontal.

Exemplo:

```text
♥ HP                         300 / 300
████████████████████████████
```

A barra deve representar proporcionalmente a vida atual.

Se já existir algum componente reutilizável para barras/progresso, investigá-lo antes de criar outro.

---

## 8. Atributos

### Regra principal

**Os atributos não são fixos.**

Nem toda entidade possui:

- ataque;
- alcance;
- velocidade;
- aggro;
- ou qualquer outro atributo atualmente exibido.

Portanto, a Unit Card **não deve possuir slots fixos obrigatórios** para cada stat.

Ela deve renderizar apenas os atributos disponibilizados para aquela entidade.

Exemplo de NPC:

```text
⚔ Atk 150
◎ Rng 6
⚡ Spd 30
◉ Agr 80
```

Exemplo de parede:

```text
🛡 Armor 30
```

Exemplo de torre:

```text
⚔ Atk 120
◎ Rng 15
⏱ Atk Spd 0.8
```

A interface deve continuar organizada caso existam:

- 0 atributos adicionais;
- 1 atributo;
- 2 atributos;
- 3 atributos;
- 4 ou mais atributos.

---

## 9. Componente genérico de stats

Investigar a arquitetura atual antes de implementar.

A preferência é que a visualização dos atributos seja baseada em dados e componentes reutilizáveis.

Conceitualmente:

```lua
stats = {
    {
        key = "attack",
        label = "Atk",
        icon = "...",
        value = 150,
    },
    {
        key = "range",
        label = "Rng",
        icon = "...",
        value = 6,
    },
}
```

O card não deve depender diretamente de uma estrutura como:

```lua
AttackText
RangeText
SpeedText
AggroText
```

se isso puder ser evitado sem quebrar a arquitetura existente.

Uma estrutura possível:

```text
StatList / StatGrid
    ├── StatItem
    ├── StatItem
    ├── StatItem
    └── StatItem
```

Cada `StatItem` pode possuir:

```text
Icon
Label
Value
```

Os nomes reais dos componentes devem respeitar a nomenclatura já utilizada no projeto.

**Não criar novos componentes sem antes investigar se já existe algo equivalente.**

---

## 10. Caixas de texto / componentes atuais

A UI atual utiliza assets/componentes já existentes.

Algumas caixas atuais aparentemente foram pensadas para possuir ícones em suas bordas.

Antes de substituir ou recriar qualquer componente:

1. investigar os componentes existentes;
2. identificar quais já são reutilizáveis;
3. verificar se algum componente está apenas incompleto ou mal utilizado;
4. preferir corrigir/reaproveitar antes de duplicar responsabilidade.

A tarefa deve manter a filosofia de frontend baseado em componentes.

Não transformar a Unit Card em um único frame monolítico cheio de lógica visual interna.

---

## 11. Botões de ação

Atualmente existem ações como:

- mover;
- atacar.

Os botões devem ficar menores e mais simples.

Evitar:

```text
ATACAR
Selecionar
alvo
```

ou:

```text
MOVER
Definir
destino
```

Preferir:

```text
[ ⚑ MOVER ]
[ ⚔ ATACAR ]
```

ou equivalente.

A informação detalhada pode ser comunicada pelo contexto da interação, hover, estado selecionado ou outro mecanismo já existente.

Não adicionar novos mecanismos apenas para esta tarefa.

### Cores

Sugestão:

- MOVER → azul;
- ATACAR → vermelho.

O restante da interface deve permanecer majoritariamente neutro.

### Estado ativo

Se a arquitetura atual já suporta estado visual de ação selecionada, o botão ativo deve possuir uma diferenciação clara.

Exemplo:

- borda mais forte;
- glow sutil;
- fundo ligeiramente preenchido.

Não criar nova lógica de gameplay para suportar isso.

---

## 12. Responsividade do card

O tamanho do card deve se adaptar ao conteúdo dentro do razoável.

Exemplo:

Uma entidade que possua somente HP e uma ação não deve obrigatoriamente ocupar a mesma altura de uma entidade com HP, quatro atributos e duas ações.

Evitar grandes espaços vazios.

Ao mesmo tempo, evitar mudanças bruscas de layout que façam o card parecer instável.

Preferir tamanhos consistentes de:

- padding;
- linhas;
- ícones;
- botões;
- gaps.

---

## 13. Hierarquia visual

A prioridade visual esperada é:

1. entidade selecionada;
2. vida;
3. atributos relevantes;
4. ações.

O jogador não deve precisar procurar onde está a informação.

Valores importantes devem possuir contraste suficiente.

Labels podem ter menos destaque que valores.

Exemplo:

```text
Atk        150
```

Onde `Atk` pode ser mais discreto e `150` mais evidente.

---

## 14. Ícones

Ícones devem ser utilizados para reduzir texto e melhorar leitura.

Exemplos conceituais:

- vida → coração;
- ataque → espada;
- alcance → alvo;
- movimento → bota;
- aggro → olho;
- mover → bandeira;
- atacar → espada.

Não é obrigatório utilizar exatamente estes símbolos.

Usar os assets existentes do projeto sempre que possível.

Não introduzir assets externos desnecessariamente.

---

## 15. Tratamento de entidades diferentes

A Unit Card deve ser genérica o suficiente para suportar diferentes tipos de entidade.

Ela não deve assumir que toda seleção é um NPC ofensivo.

Por exemplo:

### NPC

```text
NPC

HP 300 / 300

Atk 150
Rng 6
Spd 30
Agr 80

[MOVER] [ATACAR]
```

### Torre

```text
Torre

HP 800 / 800

Atk 120
Rng 15
Atk Spd 0.8
```

### Parede

```text
Parede

HP 2000 / 2000

Armor 30
```

Os exemplos representam somente comportamento visual esperado.

Não adicionar suporte de gameplay que ainda não exista.

---

## 16. Preservar fluxo atual

O redesign não deve quebrar:

- seleção de unidade;
- fechamento da Unit Card;
- atualização dos dados;
- UnitSelectQuery;
- ações de mover;
- ações de atacar;
- callbacks existentes;
- integrações existentes com componentes.

Alterações de contratos devem ser evitadas.

Se uma alteração estrutural for realmente necessária, justificar antes de implementá-la.

---

## 17. Investigação obrigatória antes da implementação

Antes de editar:

1. localizar a Unit Card atual;
2. identificar quem a instancia;
3. identificar quem atualiza seus dados;
4. identificar os componentes visuais utilizados;
5. identificar assets de ícones existentes;
6. localizar componentes de botão já utilizados;
7. localizar componentes de barra/progresso, caso existam;
8. entender como stats são recebidos atualmente;
9. entender como diferentes tipos de entidade chegam ao frontend;
10. verificar se já existe algum sistema para ocultar campos ausentes.

Não assumir estrutura de arquivos ou nomes.

Usar a codebase como fonte da verdade.

---

## 18. Estratégia de implementação

Preferir mudanças pequenas e incrementais.

Ordem sugerida:

1. reorganizar layout base da Unit Card;
2. melhorar viewport;
3. implementar/ajustar health bar;
4. transformar stats em lista/grid dinâmica;
5. simplificar botões;
6. ajustar tipografia, padding e cores;
7. validar diferentes quantidades de atributos;
8. validar entidades com dados incompletos;
9. revisar integração existente.

---

## 19. Critérios de aceitação

A tarefa pode ser considerada concluída quando:

- [ ] A Unit Card permanece compacta no canto inferior esquerdo.
- [ ] A UI não bloqueia uma parte significativa da batalha.
- [ ] A aparência deixou de parecer uma interface de debug.
- [ ] O viewport está melhor integrado ao card.
- [ ] HP possui barra visual.
- [ ] Stats não possuem grandes caixas individuais desnecessárias.
- [ ] Apenas stats existentes para a entidade são exibidos.
- [ ] Uma entidade sem `Atk`, `Rng` ou `Spd` continua sendo exibida corretamente.
- [ ] Os botões `MOVER` e `ATACAR` estão menores e mais limpos.
- [ ] Os botões não dependem de subtítulos grandes como “Selecionar alvo”.
- [ ] O card continua funcional com diferentes quantidades de stats.
- [ ] Componentes existentes foram investigados antes da criação de novos.
- [ ] Não foi adicionada lógica de debug.
- [ ] Não foi alterada a IA.
- [ ] Não foi alterada a lógica de combate.
- [ ] O fluxo atual de seleção/mover/atacar continua funcionando.
- [ ] Não houve criação desnecessária de novos sistemas.

---

## 20. Não objetivos

Não implementar nesta tarefa:

- painel de debug;
- visualização de commands;
- visualização de intents;
- visualização de brain state;
- target interno da IA;
- pathfinding debug;
- IDs internos;
- logs;
- cooldown debug;
- novas decisões de IA;
- novos comportamentos de NPC;
- novos tipos de comando.

Esses recursos podem ser tratados futuramente em um Debug Mode separado.

---

## 21. Princípio final

A Unit Card deve responder à seguinte ideia:

> Mostrar somente o que o jogador precisa para entender e controlar a entidade selecionada, ocupando o menor espaço possível sem sacrificar clareza.

Priorizar:

**clareza > quantidade de informação**

**hierarquia visual > caixas**

**componentes reutilizáveis > implementação específica**

**polimento > novas funcionalidades**
