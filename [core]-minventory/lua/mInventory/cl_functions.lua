local mInventory = mInventory or {}

function mInventory.GetPlayerInventory( ply )
    if not IsValid( ply ) then return end
    if not ply:IsPlayer() then return end
    net.Start("mInventory.RequestInventory")
    net.SendToServer()
    net.Receive("mInventory.SendInventory", function(len, ply)
        local steamID = net.ReadString()
        local inventory = net.ReadTable()
        local favorites = net.ReadTable()
        LocalPlayer().mInventory = inventory
        mInventory.Inventory[steamID] = inventory
        return inventory
    end)
end


hook.Add("OnContextMenuOpen", "mInventory.OpenInventory", function()
    mInventory.DrawInventory()
end)

hook.Add("OnContextMenuClose", "mInventory.CloseInventory", function()
    inv:Remove()
    if itemPopUP then
        itemPopUP:Remove()
    end
    if itemtooltip then
        itemtooltip:Remove()
    end
    if _Menu_mInventory_frame then
        _Menu_mInventory_frame:Remove()
    end
    if ItemInformationWindow then
        ItemInformationWindow:Remove()
    end
    if contextmenuframe then
        contextmenuframe:Remove()
    end
end)

concommand.Add("mInventory.OpenInventory", function( ply, cmd, args )
    mInventory.DrawInventory()
end)

net.Receive("mInventory.SendInventory", function(len, ply)
    print("Received Inventory from " .. "Server")
    local inventory = net.ReadTable()
    LocalPlayer().mInventory = inventory
    LocalPlayer().mInventoryMode = net.ReadString()
    return inventory
end)

net.Receive("mInventory.ItemPickedUp", function(len, ply)
    local itemData = net.ReadTable()
    print("Picked up Item: " .. itemData.name)
    net.Start("mInventory.ItemPickedUp")
    net.WriteTable(itemData)
    net.SendToServer()
end)

hook.Add("OnKeyPress", "mInventory.KeyPressRemoveAll", function(ply, key)
    if key == KEY_F then
        if inv then
            inv:Remove()
        end
        if itemPopUP then
            itemPopUP:Remove()
        end
        if itemtooltip then
            itemtooltip:Remove()
        end
        if _Menu_mInventory_frame then
            _Menu_mInventory_frame:Remove()
        end
        if contextmenuframe then 
            contextmenuframe:Remove()
        end
    end
end)

concommand.Add("mInventory.RemoveInventory", function( ply, cmd, args )
    if inv then
        inv:Remove()
    end
    if itemPopUP then
        itemPopUP:Remove()
    end
    if itemtooltip then
        itemtooltip:Remove()
    end
    if _Menu_mInventory_frame then
        _Menu_mInventory_frame:Remove()
    end
    if ItemInformationWindow then
        ItemInformationWindow:Remove()
    end
end)

net.Receive("mInventory.DrawSettingsUI", function(len, ply)
    mInventory.OpenSettings()
end)