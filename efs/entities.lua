local e = {}

function e:addEntity(entity)

    local frame = self.entityStack[#self.entityStack]
    frame[entity] = entity

    self:updateEntity(entity)
end

function e:updateEntityForFilter(entity, filter)
    local name, rule = filter[1], filter[2]
    local all = true
    local filteredEntities = self.filteredEntities
    print(name)
    for _, ruleWord in ipairs(rule) do
        if string.sub(ruleWord, 1, 1) == "-" then

            -- NOT
            if string.sub(ruleWord, 2, 2) == "_" then
                local s = string.sub(ruleWord, 3)
                if filteredEntities[s][entity] then
                    all = false
                    break
                end
            else
                -- try recursive lookup
                local ruleWord = string.sub(ruleWord, 2)
                local found = true
                local entity_rec = entity
                -- Field names can now contain letters, numbers and spaces
                for da in string.gmatch(ruleWord, "[%a%s%d]+") do
                    if not entity_rec[da] then
                        found = false
                        break
                    end
                    entity_rec = entity_rec[da]
                end
                all = all and not found
                if not all then
                    break
                end
            end

        else
            -- NORMAL CASE
            if string.sub(ruleWord, 1, 1) == "_" then
                local s = string.sub(ruleWord, 2)
                if not filteredEntities[s][entity] then
                    all = false
                    break
                end
            else
                -- try recursive lookup
                local entity_rec = entity
                -- Field names can now contain letters, numbers and spaces
                for da in string.gmatch(ruleWord, "[%a%s%d]+") do
                    if not entity_rec[da] then
                        all = false
                        break
                    end
                    entity_rec = entity_rec[da]
                end
                if not all then
                    break
                end
            end
        end
    end

    -- if the state of this entity changes with respect of this filter; update tables
    if not all and self.filteredEntities[name][entity] then
        -- entity was part of filter, but now not anymore
        local index = self.filteredEntities[name][entity]
        self.filteredEntities[name][entity] = nil

        local mover = self.filteredEntitiesAsLists[name][#self.filteredEntitiesAsLists[name]]

        self.filteredEntitiesAsLists[name][index] = mover
        self.filteredEntitiesAsLists[name][#self.filteredEntitiesAsLists[name]] = nil

        self.filteredEntities[name][mover] = index

        if self.unregisters[name] then
            for _, v in pairs(self.unregisters[name]) do
                v.unregisters[name](entity)
            end
        end
    end

    if all and not self.filteredEntities[name][entity] then
        -- entity not was part of filter, but will now be
        self.filteredEntitiesAsLists[name][#self.filteredEntitiesAsLists[name] + 1] = entity
        self.filteredEntities[name][entity] = #self.filteredEntitiesAsLists[name]

        if self.registers[name] then
            for _, v in pairs(self.registers[name]) do
                v.registers[name](entity)
            end
        end
    end
end

function e:getFilterByName(filterName)
    for _, v in ipairs(self.filteredEntitiesAsLists[name]) do
        return v
    end
    return nil
end

function e:runOnEntitiesByFilter(filterName, functionToApply, data)
    for _, v in ipairs(self.filteredEntitiesAsLists[filterName]) do
        functionToApply(v, data)
    end
end

function e:updateEntity(entity)
    for _, filter in pairs(self.filters) do
        self:updateEntityForFilter(entity, filter)
    end
end

function e:removeEntity(entity)
    for i = #self.entityStack, 1, -1 do
        local frame = self.entityStack[i]
        frame[entity] = nil
    end

    for _, name_rules in pairs(self.filters) do
        local name = name_rules[1]
        local index = self.filteredEntities[name][entity]
        if index ~= nil then
            self.filteredEntities[name][entity] = nil

            local mover = self.filteredEntitiesAsLists[name][#self.filteredEntitiesAsLists[name]]

            self.filteredEntitiesAsLists[name][index] = mover
            self.filteredEntitiesAsLists[name][#self.filteredEntitiesAsLists[name]] = nil

            self.filteredEntities[name][mover] = index

            if self.unregisters[name] then
                for _, v in pairs(self.unregisters[name]) do
                    v.unregisters[name](entity)
                end
            end
        end
    end
end

function e:pushStack()
    self.entityStack[#self.entityStack + 1] = {}
end

function e:popStack()
    for k, v in pairs(self.entityStack[#self.entityStack]) do
        core.entity.remove(v, k)
    end
    self.entityStack[#self.entityStack] = nil
end

return e