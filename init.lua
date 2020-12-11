minetest.register_globalstep(function(dtime)
	local player = minetest.localplayer
	if not player then return end
	local control = player:get_control()
	if minetest.settings:get_bool("killaura") or minetest.settings:get_bool("forcefield") and control.dig then
		local friendlist = minetest.settings:get("friendlist"):split(",")
		for _, obj in ipairs(minetest.get_objects_inside_radius(player:get_pos(), 5)) do
			local do_attack = true
			if obj:is_local_player() then
				do_attack = false
			else
				for _, friend in ipairs(friendlist) do
					if obj:get_name() == friend or obj:get_nametag() == friend then
						do_attack = false
						break
					end
				end
			end
			if do_attack then
				obj:punch()
			end
		end
	end
end)
 
minetest.register_list_command("friend", "Configure Friend List (friends dont get attacked by Killaura or Forcefield)", "friendlist")

minetest.register_cheat("Killaura", "Combat", "killaura")
minetest.register_cheat("ForceField", "Combat", "forcefield")
