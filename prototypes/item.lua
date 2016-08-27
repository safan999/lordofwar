
data:extend({
	{
		type = "item",
		name = "export-warehouse",
		icon = "__lordofwar__/graphics/icons/export-warehouse.png",
		flags = {"goes-to-quickbar"},
		subgroup = "logistic-network",
		order = "b[storage]-c[logistic-chest-requester]",
		place_result = "export-warehouse",
		stack_size = 15
	}
})