# Damage Indicator

## Objetivo

Adicionar ao frontend uma representação visual dos danos recebidos pelas units.

Quando uma unit receber dano, o client deverá receber o evento de domínio correspondente (`UnitDamaged` ou `UnitDamageReceived`) contendo as informações relevantes sobre a alteração ocorrida.

O frontend será responsável por decidir como representar visualmente esse acontecimento.

A primeira representação será um **Damage Indicator**: um número correspondente ao dano causado que aparece próximo à unit, sobe e desaparece.

---

## Escopo

Esta implementação deve adicionar **somente o Damage Indicator**.

### Incluído

* Propagar para o client o evento de dano da unit.
* Garantir que o evento contenha as informações necessárias para o frontend.
* Criar o componente visual `DamageIndicator`, seguindo os padrões existentes de componentes da UI.
* Criar o sistema responsável por transformar `UnitDamaged` em um evento interno relacionado ao Damage Indicator.
* Criar o applier responsável por aplicar esse evento ao runtime/renderização do client.
* Renderizar o número do dano próximo à unit atingida.
* Fazer o número subir e desaparecer.
* Fazer o comportamento temporal utilizar o mesmo modelo determinístico já utilizado pelo sistema de renderização, baseado em `currentTime`.

### Fora do escopo

Não implementar nesta tarefa:

* Alterações de Health Bar.
* Hit Flash.
* Screen Shake.
* VFX de impacto.
* Sons.
* Combat Log.
* Animações de morte.
* Agregação de múltiplos danos.
* Alterações no sistema de combate.
* Alterações na lógica de cálculo de dano.
* Novos efeitos visuais além do Damage Indicator.

Mesmo que a arquitetura permita essas extensões futuramente, elas não devem ser implementadas agora.

---

## Arquitetura existente

O frontend utiliza uma arquitetura orientada a eventos semelhante à arquitetura do backend.

O servidor produz eventos que representam acontecimentos no mundo.

A pipeline responsável por apresentar o estado do mundo ao client deve transmitir esses acontecimentos ao frontend sem transformá-los em eventos específicos de UI.

Por exemplo:

```text
Server
  ↓
UnitDamaged
  ↓
Render / Presentation Pipeline
  ↓
Client
  ↓
UnitDamaged
```

O evento recebido pelo frontend representa o **fato ocorrido no mundo**, e não a representação visual que deverá ser utilizada.

O frontend decide o que fazer com esse acontecimento.

---

## Evento de dano no frontend

Quando uma unit recebe dano, o client deverá receber um evento que represente esse acontecimento.

O evento deve carregar as informações relevantes disponíveis no contexto do domínio, incluindo, quando aplicável:

```text
unitId
damage
previousHealth
newHealth
died
sourceUnitId
```

Os nomes exatos devem seguir as convenções já existentes no projeto.

O evento deve representar o acontecimento de dano de maneira suficientemente rica para que diferentes sistemas do frontend possam reagir a ele independentemente.

### Importante

A pipeline **não deve criar um evento como `DamageIndicatorCreated` diretamente**.

Ela deve apenas apresentar ao frontend o fato de que a unit recebeu dano.

A decisão de transformar esse fato em um Damage Indicator pertence ao frontend.

---

## Systems e Appliers

A implementação deve respeitar a separação existente no frontend.

### Systems

Systems observam eventos/estado e podem produzir novos eventos relacionados.

Neste caso, deverá existir um sistema responsável por observar o evento de dano e decidir que um Damage Indicator deve ser criado.

Conceitualmente:

```text
UnitDamaged
    ↓
Damage Indicator System
    ↓
DamageIndicatorCreated
```

Esse sistema é uma consequência da lógica do frontend.

O servidor não deve possuir conhecimento sobre `DamageIndicator`.

### Appliers

Appliers aplicam efeitos no runtime do próprio sistema.

O applier relacionado ao Damage Indicator deverá receber o evento produzido pelo system e criar/registrar o estado necessário para sua renderização.

Conceitualmente:

```text
DamageIndicatorCreated
    ↓
DamageIndicator Applier
    ↓
DamageIndicator State
```

---

## UnitBattleView

O frontend já possui `UnitBattleView`, responsável por fornecer a representação visual da unit e seu `Model` a partir do identificador da unit.

O Damage Indicator deverá utilizar essa abstração existente para encontrar a representação visual da unit afetada.

O componente `DamageIndicator` não deve passar a conhecer diretamente sistemas de domínio, combate ou contextos que não sejam necessários para sua função visual.

A resolução:

```text
unitId
  ↓
UnitBattleView
  ↓
Unit Model / posição visual
```

deve permanecer fora da responsabilidade puramente visual do componente sempre que a arquitetura existente permitir.

---

## DamageIndicator

Deve ser criado um componente de UI/renderização denominado **DamageIndicator**, ou um nome equivalente caso as convenções atuais do projeto indiquem outro padrão.

O componente deve seguir a mesma filosofia dos componentes existentes, como `UnitCard` e `PrimaryButton`.

Sua responsabilidade é representar visualmente uma ocorrência de dano.

O componente não deve:

* calcular dano;
* consultar sistemas de combate;
* modificar `UnitState`;
* decidir se uma unit morreu;
* produzir eventos de domínio;
* conhecer regras de gameplay.

Ele recebe os dados necessários para representar o dano e cuida somente da representação visual.

---

## Comportamento visual

A primeira versão do Damage Indicator deverá:

1. Aparecer próximo à unit que recebeu o dano.
2. Exibir o valor do dano.
3. Subir enquanto permanece visível.
4. Desaparecer ao final de sua duração.
5. Ser removido quando sua duração terminar.

Exemplo:

```text
       32
      ↑
     ↑
    ↑
 [UNIT]
```

Caso múltiplos danos ocorram em sequência, a primeira implementação deverá permitir que múltiplos Damage Indicators existam simultaneamente.

Exemplo:

```text
       8
      ↑

          17
         ↑

     32
    ↑
 [UNIT]
```

Não implementar agrupamento ou soma de danos nesta tarefa.

A arquitetura, entretanto, não deve impedir que uma estratégia de agregação seja adicionada posteriormente.

---

## Renderização determinística

O Damage Indicator deve utilizar o mesmo modelo temporal utilizado pelos demais elementos renderizados pelo frontend.

A animação não deve ser implementada através de timers independentes, `task.wait`, sequências imperativas de movimento ou mecanismos equivalentes que introduzam uma linha temporal própria.

O estado do Damage Indicator deve possuir os dados temporais necessários, como:

```text
startTime
duration
```

e sua representação deve ser determinada a partir de:

```text
currentTime
+
DamageIndicatorState
```

Conceitualmente:

```lua
elapsed = currentTime - self.startTime

t = math.clamp(
    elapsed / self.duration,
    0,
    1
)
```

A partir de `t`, o renderer poderá determinar a posição, transparência e demais propriedades visuais do indicador.

O comportamento deve seguir o mesmo princípio utilizado pelo sistema de projéteis:

```text
state + currentTime
        ↓
visual state
```

O Damage Indicator não deve depender do tempo real decorrido por mecanismos externos ao relógio utilizado pelo sistema de renderização.

---

## Fluxo completo

O fluxo esperado é:

```text
SERVER
  │
  │ UnitDamaged
  ▼
Render / Presentation Pipeline
  │
  │ transmite o acontecimento
  ▼
CLIENT
  │
  │ UnitDamaged
  ▼
Damage Indicator System
  │
  │ cria evento derivado
  ▼
DamageIndicatorCreated
  │
  ▼
Damage Indicator Applier
  │
  │ resolve unitId através de UnitBattleView
  │
  ▼
DamageIndicator State
  │
  │ currentTime
  ▼
Render System
  │
  ├── calcula elapsed
  ├── calcula progress
  ├── calcula posição
  ├── calcula visibilidade
  │
  ▼
DamageIndicator
  │
  └── sobe e desaparece
```

---

## Princípios arquiteturais

### 1. O servidor informa acontecimentos, não efeitos visuais

O servidor deve dizer:

```text
UnitDamaged
```

e não:

```text
ShowDamageNumber
```

ou:

```text
CreateDamageIndicator
```

O servidor não deve conhecer a representação visual escolhida pelo client.

### 2. O frontend decide como reagir

Ao receber:

```text
UnitDamaged
```

o frontend pode decidir produzir:

```text
DamageIndicatorCreated
```

O mesmo evento poderá futuramente ser utilizado por outros systems, mas isso está fora do escopo desta implementação.

### 3. Systems produzem eventos relacionados

O Damage Indicator deve ser uma consequência do `UnitDamaged` dentro do frontend, e não uma responsabilidade da pipeline.

### 4. Appliers aplicam efeitos

O applier deve aplicar o evento relacionado ao Damage Indicator no runtime/renderização do próprio sistema.

### 5. O componente é responsável pela apresentação

`DamageIndicator` não deve possuir conhecimento de regras de gameplay.

### 6. O tempo pertence ao renderer

Toda a progressão visual deve ser derivada de `currentTime`.

---

## Estrutura de arquivos

Não é necessário impor caminhos ou nomes exatos de arquivos nesta implementação.

A implementação deve primeiro inspecionar a estrutura existente do projeto e identificar:

* onde os componentes de UI de combate ficam;
* onde ficam os systems do runtime;
* onde ficam os appliers;
* como eventos client-side são definidos;
* como eventos recebidos do servidor são encaminhados;
* como outros elementos temporais, como projéteis, são registrados e renderizados.

Os novos arquivos devem seguir **as convenções já utilizadas pelo projeto**, em vez de introduzir uma nova estrutura.

---

## Critérios de aceitação

A implementação será considerada concluída quando:

* [ ] `UnitDamaged`/`UnitDamageReceived` puder ser recebido pelo client.
* [ ] O evento carregar informações suficientes para representar o dano.
* [ ] A pipeline não criar diretamente eventos específicos do Damage Indicator.
* [ ] O frontend possuir um system que reaja ao evento de dano.
* [ ] O system produzir um evento interno para criação do Damage Indicator.
* [ ] Um applier aplicar esse evento ao runtime.
* [ ] O Damage Indicator aparecer na unit correta.
* [ ] O valor correto do dano for exibido.
* [ ] O indicador subir.
* [ ] O indicador desaparecer após sua duração.
* [ ] Múltiplos danos puderem gerar múltiplos indicadores simultaneamente.
* [ ] O comportamento temporal utilizar `currentTime`.
* [ ] Nenhum timer independente ou animação não determinística for introduzido.
* [ ] `UnitState` e regras de combate não forem modificados pelo Damage Indicator.
* [ ] Nenhuma funcionalidade visual adicional fora do escopo for implementada.

---

## Resultado esperado

Ao uma unit receber, por exemplo, 32 de dano:

```text
Server
  ↓
UnitDamaged {
    unitId = X,
    damage = 32,
    previousHealth = 100,
    newHealth = 68,
    died = false
}
  ↓
Client
  ↓
Damage Indicator System
  ↓
DamageIndicatorCreated {
    unitId = X,
    amount = 32,
    startTime = currentTime,
    ...
}
  ↓
Damage Indicator Applier
  ↓
DamageIndicator State
  ↓
Renderer
  ↓
       32
      ↑
     ↑
    ↑
 [UNIT]
```

O número deve então desaparecer ao final de sua duração.

**Nenhuma outra reação visual deve ser adicionada como parte desta tarefa.**
