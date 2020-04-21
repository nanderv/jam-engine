local f = {}
function f:addFilter(name, rules)
    self.filteredEntities[name] = {}
    self.filteredEntitiesAsLists[name] = {}
    self.registers[name] = {}
    self.unregisters[name] = {}

    self.filters[#self.filters + 1] = { name, rules }
end
function f:removeFilter()
    -- TODO: Implement this properly

end
return f