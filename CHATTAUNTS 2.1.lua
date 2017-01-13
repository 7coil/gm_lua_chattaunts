--[[
====================================
ChatTaunts 2.1 by moustacheminer.com
====================================

THIS PIECE OF SOFTWARE IS (PROBABLY) PROTECTED BY INTERNATIONAL LAW

]]--

--reads the taunts.json file
taunts = util.JSONToTable(file.Read("taunts.json","DATA"))


--sets all taunts that need to be downloaded for download
for key1, value1 in pairs(taunts) do
	for key2, value2 in pairs(value1) do
		for key3, value3 in pairs(value2) do
			if key3 == "download" then
				download = value3
			elseif key3 == "location" then
				location = value3
			end
		end
		if download then
			resource.AddFile("sound/" .. location)
			print("Added taunt to fastdl: " .. location)
		end
	end
end

hook.Add( "PlayerSay", "taunt", function( ply, text, team )
	if !ply.cooldown or ply:IsAdmin() then
		text = string.lower(text)
		text = string.gsub(text, '%W','')
		
		if gettaunt(text) then
			local taunt = gettaunt(text)
			for k, v in pairs(taunt) do
				if k == "location" then
					location = v
				elseif k == "timeout" then
					timeout = v
				end
			end
			
			for k, v in pairs ( player.GetAll() ) do
				v:SendLua("surface.PlaySound('" .. location .. "')")
			end
			ply.cooldown = true
			timer.Simple(timeout, function()
					ply.cooldown = false
			end )
		end
	end
end
)

function gettaunt(text)
	for key1, value1 in pairs(taunts) do
		for key2, value2 in pairs(value1) do
			for key3, value3 in pairs(value2) do
				if key3 == "trigger" then
					if value3 == text then
						return value2
					end
				end
			end
		end
	end
	return false
end

