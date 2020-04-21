-- This file is used to construct a new EFS system.
local filters = require("efs/filters")
local systems = require("efs/systems")
local entities = require("efs/entities")
return function()
    local system = {}

    system.addFilter = filters.addFilter
    system.removeFilter = filters.removeFilter

    system.addSystem = systems.add
    system.removeSystem = systems.remove

    system.addEntity = entities.addEntity
    system.removeEntity = entities.removeEntity
    system.updateEntity = entities.updateEntity
    system.getEntityByFilter = entities.getFilterByName
    system.pushEntityStack = entities.pushStack
    system.updateEntityForFilter = entities.updateEntityForFilter
    system.popEntityStack = entities.popStack

    system.filters = {}
    system.filteredEntities = {}

    system.filteredEntitiesAsLists = {}

    system.entityStack = {{}}

    system.systems = {}
    system.registers = {}
    system.unregisters = {}
    system:addFilter("A", {})

    return system
end