local player_pos = {}
local player_speeds = {}

minetest.register_globalstep(function(dtime)
	player_speeds = {}
	-- Update player positions
	for _, p in ipairs(minetest.get_connected_players()) do
		local name = p:get_player_name()
		-- Calculate player's velocity if last position is known
		if player_pos[name] ~= nil then
			player_speeds[name] = vector.distance(player_pos[name], p:getpos()) / dtime
			if player_speeds[name] ~= 0 then
				minetest.chat_send_all(player_speeds[name])
			end
		else
			print("Cannot calculate player speed on first server step.")
		end
		-- Set new pos
		player_pos[name] = p:getpos()
	end
end)

function player_getvelocity(player)
	local name = player:get_player_name()
	return player_speeds[name]
end