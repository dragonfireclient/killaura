local etime = 0

minetest.register_globalstep(function(dtime)
	local player = minetest.localplayer
	if not player then return end
	etime = etime + dtime
	local control = player:get_control()
	if minetest.settings:get_bool("killaura") or minetest.settings:get_bool("forcefield") and control.dig then
		local interval_str = minetest.settings:get("killaura_interval") or "auto"
		local interval
		if interval_str == "auto" then
			interval = player:get_wielded_item():get_tool_capabilities().full_punch_interval
		else
			interval = tonumber(interval_str) or 0
		end
		if etime < interval then
			return
		end
		local punched_anything = false
		local friendlist = (minetest.settings:get("friendlist") or ""):split(",")
		local only_players = minetest.settings:get_bool("killaura_only_players")
		for _, obj in ipairs(minetest.get_objects_inside_radius(player:get_pos(), 5)) do
			local do_attack = true
			if obj:is_local_player() or only_players and not obj:is_player() then
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
				punched_anything = true
			end
		end
		if punched_anything then
			etime = 0
		end
	end
end)

minetest.register_list_command("friend", "Configure Friend List (friends dont get attacked by Killaura or Forcefield)", "friendlist")

minetest.register_cheat("Killaura", "Combat", "killaura")
minetest.register_cheat("ForceField", "Combat", "forcefield")
