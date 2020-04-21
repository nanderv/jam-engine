local s = {}

function s:add(system)
    self.systems[system] = system
    if system.registers then
        -- k is the name of a filter
        for k, v in pairs(system.registers) do
            self.registers[k][system] = system
            if self.filteredEntities[k] then
                for _, w in pairs(self.registers[k]) do
                    system.registers[k](w)
                end
            end
        end
    end

    if system.unregisters then
        for k, v in pairs(system.unregisters) do
            self.unregisters[k][system] = system
        end
    end
end

function s:remove(system)
    for k, _ in pairs(system.registers) do
        self.registers[k][system] = nil
    end
    for k, _ in pairs(system.unregisters) do
        if self.filteredEntities[k] then
            for _, w in pairs(self.filteredEntities[k]) do
                system.unregisters[k](w)
            end
        end
        self.unregisters[k][system] = nil
    end
    self.systems[system] = nil
end
return s