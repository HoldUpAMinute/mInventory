mInventory = mInventory or {}
local rootDirectory = "mInventory"

local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if SERVER and prefix == "sv_" then
		include( directory .. File )	  
		print("[mInventory] Loaded " .. directory .. File .. ".")
	elseif prefix == "sh_" then
		if SERVER then
			print("[mInventory] Added " .. directory .. File .. " to download list.")
			AddCSLuaFile( directory .. File )
		end
		include( directory .. File )
	elseif prefix == "cl_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			print("[mInventory] Added " .. directory .. File .. " to download list.")
		elseif CLIENT then
			include( directory .. File )
			print("[mInventory] Loaded " .. directory .. File .. ".")
		end
	end
end

local function IncludeDir( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )

	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		IncludeDir( directory .. v )
	end
end

IncludeDir( rootDirectory )

if not file.Exists( "mInventory", "DATA" ) then
	file.CreateDir( "mInventory" )
end