--[[
Most of the gui is taken from the advanced logistics mod.
I have actually no idea how it works, so thank you.
]]--


--- Init GUI and add Logistics View main button
function initGUI(player)
    if not player.gui.top["lordofwarbutton"] then
        player.gui.top.add({type = "button", name = "lordofwarbutton", style = "lv_button_main_icon"})
        global.lordofwar.guiLoaded[player.index] = true
    end
end

--- Create the GUI
function createGUI(player, index)
    
--    local guiPos = global.lordofwar.settings[index].guiPos
	local guiPos = "center"
	local force = player.force
    if player.gui[guiPos].lordofwarFrame ~= nil then
        player.gui[guiPos].lordofwarFrame.destroy()
    end
    if global.lordofwar.guiVisible[index] == 0 and player.gui[guiPos].lordofwarFrame == nil then
--        local currentTab = global.currentTab[index] or "logistics"
--        local buttonStyle = currentTab == 'logistics' and "_selected" or ""

        -- main frame
        local lordofwarFrame = player.gui[guiPos].add({type = "frame", name = "lordofwarFrame", direction = "vertical", style = "lv_frame"})        
        local titleFlow = lordofwarFrame.add({type = "flow", name = "titleFlow", direction = "horizontal"})
--		global.lordofwar.credits[player.force] = global.lordofwar.credits[player.force] or 0
        titleFlow.add({type = "button", name = "lordofwar-view-close", caption = "X" , style = "lv_button_close"})
        titleFlow.add({type = "label", name="titleLabel", style = "lv_title_label", caption = "Contracts Overview"})        

		local informationFlow = lordofwarFrame.add({type = "flow", name = "informationFlow", direction = "horizontal"})
		informationFlow.add({type = "label", name="creditHeader", style = "lv_info_label", caption = "credits: "})
		informationFlow.add({type = "label", name="creditField", style = "lv_info_label", caption = global.lordofwar.credits[player.force.name] or "0"})
		informationFlow.add({type = "label", name="rankHeader", style = "lv_info_label", caption = "Rank: "})
		informationFlow.add({type = "label", name="rankField", style = "lv_info_label", caption = {getRank(global.lordofwar.credits[player.force.name])}})
		
		
        -- content frame
--        local contentFrame = lordofwarFrame.add({type = "frame", name = "contentFrame", style = "lv_items_frame", direction = "vertical"})
--        local infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "lv_info_flow", direction = "horizontal"})
		local contentTable = player.gui[guiPos].lordofwarFrame.add({type = "table", name = "contentTable", colspan = 5, style = "lv_items_table"})
			contentTable.add({type = "label", name = "goodsHeader", caption = "goods"})
			contentTable.add({type = "label", name = "availableHeader", caption = "available"})
			contentTable.add({type = "label", name = "requestedHeader", caption = "requested"})
			contentTable.add({type = "label", name = "valueHeader", caption = "total value"})
			contentTable.add({type = "label", name = "cancelHeader", caption = ""})
			for i=1,5 do
				contentTable.add({type = "label", name = "good".. i}) --goods
				contentTable.add({type = "label", name = "available" .. i}) --available
				contentTable.add({type = "label", name = "requested" .. i}) -- requested
				contentTable.add({type = "label", name = "value" .. i}) -- value
				contentTable.add({type = "label", name = "time" .. i}) --time in seconds
			end
		
        updateGUI(player)
    end
end

--- Show the GUI
function showGUI(player, index)
    if global.lordofwar.guiVisible[index] == 0 then
        createGUI(player, index)

        -- hide settings gui
        -- hideSettings(player, index)

        global.lordofwar.guiVisible[index] = 1
    end
end

--- Hide the GUI
function hideGUI(player, index)
--    local guiPos = global.lordofwar.settings[index].guiPos
	local guiPos = "center"
    if player.gui[guiPos].lordofwarFrame ~= nil then
        player.gui[guiPos].lordofwarFrame.style = "lv_frame_hidden"
        global.lordofwar.guiVisible[index] = 0
    end
end

--- Destroy the GUI
function destroyGUI(player, index)    
    if player.gui.top["lordofwar-view-button"] ~= nil then
        hideGUI(player, index)
        player.gui.top["lordofwar-view-button"].destroy()
        global.lordofwar.guiLoaded[player.index] = false
    end
end

--- Update main gui content
function updateGUI(player)
--    local currentTab = tab or global.currentTab[index]
    local force = player.force
--	local guiPos = global.lordofwar.settings[index].guiPos
	local guiPos = "center"
	local contentTable = player.gui[guiPos].lordofwarFrame.contentTable
	for k,v in pairs(global.lordofwar.contracts) do
		contentTable["good"..k].caption = getLocalisedName(v.good) --goods
		contentTable["available" .. k].caption = getInventory(force.name,v.good) --available
		contentTable["time" .. k].caption = timeCount((v.timer - game.tick)/60) --time in seconds
		contentTable["requested" .. k].caption = v.quantity -- requested
		contentTable["value" .. k].caption = v.value -- value
	end
	
	
end

function getLocalisedName(name)
    local locName = game.item_prototypes[name].localised_name
    if not locName then
        locName = game.entity_prototypes[name].localised_name
    end 
    return locName
end

--- Get inventory of a good from export warehouses
function getInventory(force,goods)
	local warehouses = global.lordofwar.exportWarehouses[force]
	local itemCount = 0
	if warehouses == nil then
	else
		for k,v in pairs(warehouses) do
			itemCount = itemCount + v.get_item_count(goods)
		end
	end
--	game.players[1].print("getInventory returns" .. itemCount)
	return itemCount
end


function timeCount(numSec)
	local nSeconds = numSec
	if nSeconds <= 0 then
		return "00:00";
	else
		local nMins = string.format("%02.f", math.floor(nSeconds/60));
		local nSecs = string.format("%02.f", math.floor(nSeconds - nMins *60));
		return nMins..":"..nSecs
	end
end

--- Clear main content gui
function clearGUI(player, index)
--    local guiPos = global.settings[index].guiPos
	local guiPos = "center"
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

    if contentFrame and contentFrame.children_names ~= nil then
        for _,child in pairs(contentFrame.children_names) do
            if contentFrame[child] ~= nil then
                contentFrame[child].destroy()
            end
        end
    end

end

