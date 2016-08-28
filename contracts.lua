--[[
global.lordofwar.contracts
	key
	good
	timer
	quantity
	value
]]--

function addContract()
--	game.players[1].print("Addcontracts start")
	local contractNumber = #global.lordofwar.contracts
	if contractNumber < global.lordofwar.maxDueTech then -- max 5
		if contractNumber < global.lordofwar.maxDueEnt then -- unlimited
			-- already ordered goods
			local goodOrdered = {} 
			for k,v in pairs (global.lordofwar.contracts)do
				goodOrdered[v.good]=1
			end
			-- get a random good
			local goodToOrder = choseRandomGood()
			while goodOrdered[goodToOrder] == 1 do
				goodToOrder = choseRandomGood()
			end
			--game.players[1].print (good .. " chosen")
			--get a semi random quantity
			--local quantityToOrder = 1 + math.floor(global.lordofwar.lastValue/global.lordofwar.goods[goodToOrder])
			--global.lordofwar.lastValue = global.lordofwar.lastValue * (1 + math.random()/5) -- LastValue increased with 0 - 20 %
			local quantityToOrder = 1 + math.floor(1000/global.lordofwar.goods[goodToOrder]*(1 + math.random()/5)*global.lordofwar.quantityMultiplier)
						
			-- set the timer
			local timerToOrder=game.tick + 36000 -- 10 minutes 36000 = 10
			
			-- set the value
			local valueToOrder= math.floor(global.lordofwar.goods[goodToOrder]*quantityToOrder*global.lordofwar.valueMultiplier)
			
			-- add the contract
			table.insert(global.lordofwar.contracts, {good=goodToOrder,quantity=quantityToOrder,timer=timerToOrder,value=valueToOrder})
			-- set requester slots
			for k,forceName in pairs(global.lordofwar.exportWarehouses) do
				for i,entity in pairs(global.lordofwar.exportWarehouses[k]) do
					entity.set_request_slot({name = goodToOrder,count = quantityToOrder}, getFreeRequestSlotIndex(entity))
				end
			end
			
		end
	end	
--	game.players[1].print("add contracts end")
end

function getFreeRequestSlotIndex(entity)
	total = entity.request_slot_count
	i = 1
	while entity.get_request_slot(i) ~= nil do	
		i = i + 1
	end
	return i
end

function getMatchingRequestSlotIndex(entity,good)
	for i=1,entity.request_slot_count do
		if entity.get_request_slot(i) ~= nil then
			if entity.get_request_slot(i).name == good then
				return i
			end
		end
		i = i + 1
	end
	return 0
end

function checkContracts() -- executed every second!
	-- first check if any contract can be completed
	local orderCompleted = 0
	local orderExpired = 0
	for k,v in pairs(global.lordofwar.exportWarehouses) do -- check all forces with warehouses
		for i,j in pairs(global.lordofwar.contracts) do -- check all contracts (max 5)
			if getInventory(k,j.good) >= j.quantity then -- check inventory for force k and j.good 
				orderCompleted = i
				-- then check if a new contract can be added
				-- addContract()
			end
		end
		if orderCompleted ~= 0 then
			completeContract(k,orderCompleted) -- k has won the contract with key orderCompleted
		end
	end
--	game.players[1].print("expired contracts control start")
	-- then check if any contract is expired
	for k,v in pairs(global.lordofwar.contracts) do
		if v.timer < game.tick then
			orderExpired = k
		end
	end
--	game.players[1].print("expired contracts control end")
		if orderExpired ~=0 then
			expireContract(orderExpired)--orderExpired is the key of the expired contract
		end
	addContract()
		
end
	
function completeContract(forceName,key)
	--game.players[1].print("completeContract begin")
	-- remove the contract
	local quantity = global.lordofwar.contracts[key].quantity -- store quantity before destroying
	local good = global.lordofwar.contracts[key].good
	local value = global.lordofwar.contracts[key].value
    table.remove( global.lordofwar.contracts, key)
	--game.players[1].print(quantity)
	-- increase credits
	global.lordofwar.credits[forceName] = global.lordofwar.credits[forceName] or 0
	global.lordofwar.credits[forceName] = global.lordofwar.credits[forceName] + value
	-- remove the items
	for k,v in pairs(global.lordofwar.exportWarehouses[forceName])do -- all exportWarehouses
		if quantity > 0 then
			quantity = quantity - v.remove_item({name = good,count = quantity })
		end
	end
	-- remove requester slots
	for k,v in pairs(global.lordofwar.exportWarehouses) do --for every force with warehouses
		for i,entity in pairs(global.lordofwar.exportWarehouses[k]) do --for every entity
			entity.clear_request_slot(getMatchingRequestSlotIndex(entity,good))			
		end
	end
	-- bonus for completing
	global.lordofwar.valueMultiplier = global.lordofwar.valueMultiplier*1.01
	global.lordofwar.quantityMultiplier = global.lordofwar.quantityMultiplier*1.05
	--game.players[1].print("completeContract end")
end

function expireContract(key)
--	game.players[1].print("expired contracts start")
	-- delete contract out of tables
	local good = global.lordofwar.contracts[key].good
    table.remove( global.lordofwar.contracts, key)
    -- lower next value but keep a minimum of 100
    global.lordofwar.lastValue = math.max(global.lordofwar.lastValue * math.random(),100)
    -- remove the requester slots
	for k,v in pairs(global.lordofwar.exportWarehouses) do --for every force with warehouses
		for i,entity in pairs(global.lordofwar.exportWarehouses[k]) do --for every entity
			entity.clear_request_slot(getMatchingRequestSlotIndex(entity,good))			
		end
	end
	-- punish for not completing
	global.lordofwar.valueMultiplier = global.lordofwar.valueMultiplier*0.99
	global.lordofwar.quantityMultiplier = global.lordofwar.quantityMultiplier*0.95
	
--	game.players[1].print("expired contracts end")
end
