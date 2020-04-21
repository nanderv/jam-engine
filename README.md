# Jam Engine
The goal of the Jam Engine is to provide an integrated start for making gamejam projects in Love2d.  It should provide standardised sprite loading, entity management, level loading, and more.

# Entity Filter System
One of the core parts of the Jam Engine is the Entity Filter System. It allows for quickly selecting entities in the game for processing.

## Entities
An entity is a table in lua, containing text/number field names, and containing text/number/table as sub-elements. An entity has to be purely data: in the tree of the entity there can only be tables, numbers, strings (so no functions, no imageData, no music).
## Filters
Filters have a name, and a list of string-based properties of entities. Filters can either state something about a path within the structure of the entity, for instance:
```system:addFilter("hasPosition", {"position.x", "position.y", "position.rotation"})```

Also, it could state something about the other filters it's a part of, as follows:
```system:addFilter("hasPosition", {"_position", "hasCollisionShape"})```. It's important to realise for filter-based filter properties that the order in which filters are executed matters: the filters are executed in the order at which they were added to the game.

Negations are also possible in front of filters (using the ```-``` symbol)
## Systems
Systems are a way to allow some more finegrained control over game flow. The normally prefered way within this engine is to handle lists of entities, and work from there (in straightforward procedural code).

However, there are situations where you want to respond to an entity getting added to the game, or other things like this. 