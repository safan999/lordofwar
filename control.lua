require "gui"
require "goods"
require "contracts"
require "ranks"

--- on_init event
script.on_init(function()
    init()
    -- init player specific globals
    initPlayers()
	for i, player in ipairs(game.players) do player.force.reset_recipes() end
	for i, player in ipairs(game.players) do player.force.reset_technologies() end
end)

--- on_load event
script.on_load(function()
	
end)

--- on_configuration_changed event
script.on_configuration_changed(function(data)
    on_configuration_changed(data)
end)	

--- Player Related Events
script.on_event(defines.events.on_player_created, function(event)
    playerCreated(event)
end)

--- Entity Related Events
script.on_event(defines.events.on_built_entity, function(event)
   entityBuilt(event, event.created_entity)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
    entityBuilt(event, event.created_entity)
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
    entityMined(event, event.entity)
end)

script.on_event(defines.events.on_robot_pre_mined, function(event)
    entityMined(event, event.entity)
end)

script.on_event(defines.events.on_entity_died, function(event)
    entityMined(event, event.entity)
end)

script.on_event(defines.events.on_tick, function(event)
    if event.tick % 60 == 53 then -- every second
--		game.players[1].print("1")
		checkContracts()
--		game.players[1].print("2")
	    for k,v in pairs(global.lordofwar.guiVisible) do
--			game.players[1].print("3")
			if v == 1 then
--				game.players[1].print("4")
				updateGUI(game.players[k])
--				game.players[1].print("5")
			end
		end
    end
end)

--- Research Related Events / Mod Activation
script.on_event(defines.events.on_research_finished, function(event)
    if event.research.name == "lord-of-war1" then
        global.lordofwar.goods = global.lordofwar.goods or {}
		makeGoodsTable1()
		global.lordofwar.maxDueTech = 1
		activateSystem(event)
	elseif event.research.name == "lord-of-war2" then
		global.lordofwar.maxDueTech = 2
		makeGoodsTable2()
	elseif event.research.name == "lord-of-war3" then
		global.lordofwar.maxDueTech = 3
		makeGoodsTable3()
	elseif event.research.name == "lord-of-war4" then
		global.lordofwar.maxDueTech = 4
		makeGoodsTable4()
	elseif event.research.name == "lord-of-war5" then
		makeGoodsTable5()
		global.lordofwar.maxDueTech = 5
    end
end)

--- Initiate default and global values
function init()
	global.lordofwar = global.lordofwar or {}
    global.lordofwar.guiLoaded = global.lordofwar.guiLoaded or {}
    global.lordofwar.guiVisible = global.lordofwar.guiVisible or {}
    global.lordofwar.hasSystem = global.lordofwar.hasSystem or {}
	global.lordofwar.credits = global.lordofwar.credits or {}
	global.lordofwar.lastValue = global.lordofwar.lastValue or 1000
	global.lordofwar.goods = global.lordofwar.goods or {}
	global.lordofwar.contracts = global.lordofwar.contracts or {}
	global.lordofwar.exportWarehouses = global.lordofwar.exportWarehouses or {}
	global.lordofwar.maxDueTech = global.lordofwar.maxDueTech or 0
	global.lordofwar.maxDueEnt = global.lordofwar.maxDueEnt or 0
	global.lordofwar.contractTimes = global.lordofwar.contractTimes or {}
end

--- init all players
function initPlayers()
    for _,player in pairs(game.players) do
        initPlayer(player)
		global.lordofwar.credits[player.force] = 0
    end
end

--- init new players
function playerCreated(event)
    local player = game.players[event.player_index]
    initPlayer(player)
end

--- init player specific global values
function initPlayer(player)
    local force = player.force
    local forceName = force.name
    local index = player.index

    -- gui visibility
    if not global.lordofwar.guiVisible[index] or global.lordofwar.guiVisible[index] == nil then
        global.lordofwar.guiVisible[index] = 0
    end

    -- hasSystem
    if not global.lordofwar.hasSystem[forceName] then
        global.lordofwar.hasSystem[forceName] = nil
    end
    -- gui loaded
    if playerHasSystem(player) and (not global.lordofwar.guiLoaded[index] or not player.gui.top["lordofwarbutton"]) then
        initGUI(player)
    end    
end

--- handles mod updates
function on_configuration_changed(data)
    local modName = "lordofwar"
    
    if data and data.mod_changes and data.mod_changes[modName] then
        local newVersion = data.mod_changes[modName].new_version
        local oldVersion = data.mod_changes[modName].old_version
		
    end
end

--- Checks if the player has the system enabled
function playerHasSystem(player)
    local forceName = player.force.name
    return global.lordofwar.hasSystem[forceName]
end

--- Activate the system for the force players using the on_research_finished event
function activateSystem(event)
    local forceName = event.research.force.name
    local hasSystem = global.lordofwar.hasSystem[forceName]
    if not hasSystem or hasSystem == nil then
        global.lordofwar.hasSystem[forceName] = true
        local players = event.research.force.players
        for index,player in pairs(players) do 
            if (not global.lordofwar.guiLoaded[index]) then
                initGUI(player)
            end
        end
    end
end

function entityBuilt(event, entity)
    local forceName = entity.force.name
	global.lordofwar.exportWarehouses[forceName] = global.lordofwar.exportWarehouses[forceName] or {}
    if entity.name == "export-warehouse" then
		-- add the entity to the exportWarehouses table
		table.insert(global.lordofwar.exportWarehouses[forceName],entity)
		global.lordofwar.maxDueEnt = global.lordofwar.maxDueEnt + 1
		
		-- set requester for existing contracts
		for k,v in pairs(global.lordofwar.contracts) do
			entity.set_request_slot({name = v.good,count = v.quantity}, getFreeRequestSlotIndex(entity))
		end
		
		-- add the new contract, if less then 5
		addContract()
	end
end

function entityMined(event, entity)
    local forceName = entity.force.name
	global.lordofwar.exportWarehouses[forceName] = global.lordofwar.exportWarehouses[forceName] or {}
    if entity.name == "export-warehouse" then
		for k,v in pairs(global.lordofwar.exportWarehouses[forceName]) do
			if v == entity then
				table.remove(global.lordofwar.exportWarehouses[forceName],k)
				global.lordofwar.maxDueEnt = global.lordofwar.maxDueEnt - 1
			end
		end
	end
end
--[[
--- Returns table count
function count(t)
    local count = 0
    if type(t) == "table" then
        for _,item in pairs(t) do
            count = count + 1
        end
    end
    return count
end
]]--




