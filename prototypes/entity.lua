data:extend({
{
		type = "logistic-container",
		name = "export-warehouse",
		icon = "__lordofwar__/graphics/icons/export-warehouse.png",
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "export-warehouse"},
		max_health = 350,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
		close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
		vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		logistic_mode = "requester",
		resistances =
		{
			{
				type = "fire",
				percent = 90
			}
		},
		collision_box = {{-2.7, -2.7}, {2.7, 2.7}},
		selection_box = {{-3.0, -3.0}, {3.0, 3.0}},
		fast_replaceable_group = "container",
		inventory_size = 800,
		picture =
		{
			filename = "__lordofwar__/graphics/entity/export-warehouse-shadow.png",
			priority = "high",
			width = 260,
			height = 240,
			shift = {1.0, -0.3},
		}
}
})

	
