local start_depth = {}
local timer = {}
local timing = 1
local factor = 0.1 -- 1/10, 1 hp per 10 nodes of depth

minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest:get_connected_players()) do
        local player_pos = player:get_pos()
	    player_pos.y = player_pos.y + player:get_properties().eye_height
	    local node = minetest.get_node(player_pos)
        if minetest.get_item_group(node.name, "liquid") > 0 then
            if timer[player] then timer[player] = timer[player] + dtime
            else timer[player] = 0 end
            if timer[player] >= timing then
                if start_depth[player] then
                    local cur_depth = start_depth[player].y - player_pos.y
                    player:set_hp(player:get_hp() - math.max(0, math.floor(factor * cur_depth)))
                else
                    start_depth[player] = player_pos
                end
                timer[player] = 0
            end
        else
            start_depth[player] = nil
            timer[player] = nil
        end
    end
end)
