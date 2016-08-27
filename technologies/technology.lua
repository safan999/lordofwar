data:extend(
{
    {
        type = "technology",
        name = "lord-of-war1",
        icon = "__lordofwar__/graphics/technology/low.png",
        effects ={
					{
						type = "unlock-recipe",
						recipe = "export-warehouse",
					}
				},
        prerequisites =
        {
            "military",
			"armor-making"
        },
        unit =
        {
            count = 100,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
            },
            time = 30
        },
        order = "c-k-c-a",
    },
	{
        type = "technology",
        name = "lord-of-war2",
        icon = "__lordofwar__/graphics/technology/low.png",
        effects ={},
        prerequisites =
        {
			"lord-of-war1",
            "military-2",
			"flame-thrower"
        },
        unit =
        {
            count = 200,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
            },
            time = 30
        },
        order = "c-k-c-a",
    },
	{
        type = "technology",
        name = "lord-of-war3",
        icon = "__lordofwar__/graphics/technology/low.png",
        effects ={},
        prerequisites =
        {
            "military-3",
			"lord-of-war2",
			"armor-making-2",
			"land-mine",
			"explosives",
			"combat-robotics"
        },
        unit =
        {
            count = 300,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
				{"science-pack-3", 1},
            },
            time = 30
        },
        order = "c-k-c-a",
    },
	{
        type = "technology",
        name = "lord-of-war4",
        icon = "__lordofwar__/graphics/technology/low.png",
        effects ={},
        prerequisites =
        {
			"lord-of-war3",
            "military-4",
			"combat-robotics-2",
			
        },
        unit =
        {
            count = 400,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
				{"science-pack-3", 1},
            },
            time = 30
        },
        order = "c-k-c-a",
    },
	{
        type = "technology",
        name = "lord-of-war5",
        icon = "__lordofwar__/graphics/technology/low.png",
        effects ={},
        prerequisites =
        {
            "combat-robotics-3",
			"lord-of-war1",
			"armor-making-3",
			"cluster-grenade",
			"explosive-rocketry"
        },
        unit =
        {
            count = 500,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
				{"science-pack-3", 1},
            },
            time = 30
        },
        order = "c-k-c-a",
    }
})





