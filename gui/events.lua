--- GUI Events
script.on_event(defines.events.on_gui_click, function(event)

    local index = event.player_index
    local player = game.players[index]

    -- main button click event - show/hide gui
    if event.element.name == "lordofwarbutton" then

        local visible = global.lordofwar.guiVisible[index]

        if visible == 0 then
            showGUI(player, index)
        else
            hideGUI(player, index)
        end

    -- close gui button click event
    elseif event.element.name == "lordofwar-view-close" then

        hideGUI(player, index)
    end

end)
