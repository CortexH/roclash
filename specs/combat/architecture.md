# Roclash Architecture

## Overview

Roclash is a deterministic event-driven battle simulation.

The architecture is designed to make every battle reproducible from the same
sequence of Commands and Events.

The system separates decision making from state mutation.

---

# Core Principles

- Server authoritative
- Deterministic simulation
- Event-driven
- Replayable
- Separation of responsibilities

---

# Battle Context

BattleContext is the source of truth during a battle.

It stores every mutable state related to the simulation.

Examples:

- active units
- reserved units
- positions
- timers
- combat state

No other system should own battle state.

---

# Commands

Commands represent requests coming from outside the simulation.

Examples:

- MoveCommand
- AttackCommand
- SpawnCommand

Commands NEVER modify state.

Commands only request actions.

---

# Intents

Intents represent decisions that may or may not happen.

Every intent must be validated.

Examples:

- AttackIntent
- MoveIntent
- AggroIntent

An intent may be:

- accepted
- rejected

Intents NEVER modify state.

---

# Events

Events represent facts.

Events are immutable.

Examples:

- UnitSpawnedEvent
- AttackStartedEvent
- AggroStartedEvent

Events describe something that happened.

They do not execute logic.

---

# Appliers

Appliers are responsible for mutating BattleContext.

Every state mutation should happen here.

If state changes outside an Applier, it is probably an architectural violation.

---

# UnitModule

UnitModule is responsible for executing actions.

It applies changes to the simulation state.

UnitModule does not make gameplay decisions.

## Owns

- Units in UnitsBC

## Responsibilities

- update unit state
- move units
- update targets
- update health
- update combat state

Only UnitModule may modify Units in UnitsBC.

---

# NPCModule

NPCModule is responsible for decision making.

It evaluates the current battle state and produces Intents.

NPCModule never modifies the simulation state directly.

## Owns

- Brain

## Responsibilities

- choose targets
- evaluate aggro
- maintain NPC memory
- maintain NPC knowledge
- maintain current intentions

NPCModule may freely modify Brain.

NPCModule must never modify UnitsBC directly.

# OTHER

NPCModule may request state changes by generating Intents.

UnitModule executes accepted Intents by mutating UnitsBC.

---

# Systems

Systems react to Events.

Their responsibility is to transform one or more Events into new Events.

Systems represent the business rules of the simulation.

Examples:

UnitSpawnedEvent
↓

AggroSystem

↓

AggroStartedEvent

↓

MovementRequestedEvent

Another example:

AttackStartedEvent
↓

DamageSystem

↓

ImpactEvent / DamageAppliedEvent

↓

DeathEvent

Systems should never mutate BattleContext directly.

They only observe events, evaluate business rules and produce new events.

State mutation is delegated to Appliers.

---

# Simulation Flow

External Request

↓

Command

↓

Intent

↓

Validation

↓

Accepted / Rejected

↓

Events

↓

Appliers / Systems

↓

BattleContext Updated / New events

---

# Ownership

BattleContext is the source of truth for the battle simulation.

Each module owns its own internal state.

A module may freely modify the state it owns.

A module must never modify the internal state owned by another module.

BattleContext
→ simulation state

UnitService
→ execution

NPCService
→ decision making

Commands
→ external requests

Intents
→ desired actions

Events
→ immutable facts

Appliers
→ state mutation

Systems
→ new events generation

---

# Architectural Constraints

Only UnitModule may modify UnitState.

NpcModule never modifies state.

Commands never mutate BattleContext.

Events are immutable.

BattleContext is the source of truth.

Every state mutation should happen through an Applier.

---

# AI Rules

When implementing a feature:

- Read this document first.
- Never assume architecture.
- Never introduce new architectural patterns.
- Do not create new Events without justification.
- Do not bypass the Event pipeline.
- If architecture changes are required, stop and explain why.
