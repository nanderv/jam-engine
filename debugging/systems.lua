print("II")
local testSystem = {}
testSystem.registers = {}
testSystem.unregisters= {}
testSystem.registers["A"]=function(entity)
    print(entity)
end
testSystem.unregisters["A"]=function(entity)
    print(entity)
end
sys = require("efs/construct")()
sys:addFilter("HOI", {"position"})
j ={name="HENK"}
sys:addEntity(j)



local i = {name="HENK"}
sys:addSystem(testSystem)

sys:removeEntity(j)