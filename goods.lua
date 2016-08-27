function makeGoodsTable1()
	addGoods("pistol",10)						
	addGoods("shotgun",35)
	addGoods("shotgun-shell",4)
	addGoods("light-armor",40)
	addGoods("firearm-magazine",2)
end

function makeGoodsTable2()
	addGoods("grenade",15)						
	addGoods("piercing-rounds-magazine",11)
	addGoods("submachine-gun",45)
	addGoods("flame-thrower",90)
	addGoods("flame-thrower-ammo",20)
end

function makeGoodsTable3()
	addGoods("defender-capsule",38)						
	addGoods("explosives",10)
	addGoods("poison-capsule",46)
	addGoods("heavy-armor",400)
	addGoods("land-mine",26)
end

function makeGoodsTable4()
	addGoods("distractor-capsule",150)						
	addGoods("rocket-launcher",70)
	addGoods("rocket",28)
	addGoods("slowdown-capsule",32)
	addGoods("combat-shotgun",125)
end

function makeGoodsTable5()
	addGoods("destroyer-capsule",700)						
	addGoods("modular-armor",1500)
	addGoods("cluster-grenade",185)
	addGoods("explosive-rocket",78)
	addGoods("piercing-shotgun-shell",14)
end

function addGoods(good,value)
--	game.players[1].print("Adding " .. good .. value)
	global.lordofwar.goods[good] = value	
end

function choseRandomGood()
	local keyset = {}
	for k,v in pairs(global.lordofwar.goods) do
		table.insert(keyset, k)
--		game.players[1].print (k .. " added to keyset")
	end
	random_elem = math.random(#keyset)
--	game.players[1].print ("returning" .. keyset[random_elem])
	return keyset[random_elem]
end