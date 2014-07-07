--[[
	Parachute for skydiving
]]
dofile(minetest.get_modpath("parachute") .. "/physHelpers.lua")
dofile(minetest.get_modpath("parachute") .. "/getplayervelocity.lua")

minetest.register_craftitem("parachute:parachute_item", {
	inventory_image = "parachute_inv.png",
	wield_image = "parachute_inv.png",
	on_use = function(itemstack, user, pointed_thing)
		local pos = user:getpos()
		local on = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
		if on.name == "air" then
			-- Spawn parachute
			pos.y = pos.y + 3
			local ent = minetest.add_entity(pos, "parachute:parachute")
			-- Copy watcher velocity to parachute
			-- Disabled because user:getvelocity() isn't implemented, workaround needed
			minetest.chat_send_all(player_getvelocity(user))
			ent:setvelocity({x = 0, y = -player_getvelocity(user), z = 0})
			-- Attach user
			user:set_attach(ent, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
			-- Tell it who is attached
			ent = ent:get_luaentity()
			ent.attached = user:get_player_name()
		else
			minetest.chat_send_player(user:get_player_name(), "Cannot open parachute on ground!")
		end
	end
})

local parachute = {
	initial_properties = {
		visual = "wielditem",
		visual_size = {x=1,y=1},
		textures = {"wool_red.png"},
		collisionbox = {-0.5,-0.5,-0.5,0.5,0.5,0.5},
	},
	attached = nil
}

function parachute:on_step(dtime)
	if self.attached ~= nil then
		self.object:setacceleration({x = 0, y = a(self.object:getvelocity().y), z = 0})
	end
	local pos = self.object:getpos()
	local under = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	if under.name ~= "air" then
		self.object:set_detach()
		self.object:remove()
	end
end

minetest.register_entity("parachute:parachute", parachute)
