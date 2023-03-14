mInventory = mInventory or {}
mInventory.Config = mInventory.Config or {}

mInventory.Config.AdminGroups = {
    ["superadmin"] = true,
    ["Owner"] = true,
    ["Founder"] = true
}

mInventory.Config.EntitesWhitelist = {
    ["ent_lightsaber"] = true
}

mInventory.Config.ChatCommand = {
    ["/inv"] = true,
    ["!inv"] = true,
}

mInventory.Config.HolsterCommand = {
    ["/holster"] = true,
    ["!holster"] = true,
    ["/invholster"] = true,
    ["!invholster"] = true
}

mInventory.Config.AdminCommand = {
    ["/invadmin"] = true,
    ["!invadmin"] = true,
}

mInventory.Config.VipGroups = {
    ["vip"] = true,
    ["Server Backer"] = true,
}

mInventory.Config.RefreshTime = 20

mInventory.Config.MaxItems = {
    ["user"] = 300,
    ["vip"] = 400,
    ["superadmin"] = 500,
}

mInventory.Config.Rarties = {
    ["Common"] = true,
    ["Uncommon"] = true,
    ["Rare"] = true,
    ["Epic"] = true,
    ["Legendary"] = true,
    ["Mythical"] = true,
    ["Glitched"] = true,
}

mInventory.InventoryBlacklist = {
    ["keys"] = true,
    ["stunstick"] = true,
    ["unarrest_stick"] = true,
    ["arrest_stick"] = true,
    ["door_ram"] = true,
    ["gmod_tool"] = true,
    ["weapon_physgun"] = true,
    ["weapon_fists"] = true,
    ["weapon_physcannon"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_keypadchecker"] = true
}

mInventory.Config.Rarities2Rarities = {
    ["Common"] = "Uncommon",
    ["Uncommon"] = "Rare",
    ["Rare"] = "Epic",
    ["Epic"] = "Legendary",
    ["Legendary"] = "Mythical",
    ["Mythical"] = "Glitched",
}