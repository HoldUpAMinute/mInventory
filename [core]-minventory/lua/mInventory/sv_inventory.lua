mInventory = mInventory or {}
mInventory.Inventories = mInventory.Inventories or {}
mInventory.Config = mInventory.Config or {}
ENT = {}

function mInventory.GetPlayerInventory(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    local steamID = ply:SteamID64()

    if file.Exists("mInventory/" .. steamID .. ".json", "DATA") then
        local inventory = util.JSONToTable(file.Read("mInventory/" .. steamID .. ".json", "DATA"))
        ply.mInventory = inventory
        mInventory.UpdatePlayer(ply)

        return inventory
    end

    return {}
end

hook.Add("PlayerSay", "mInventory.OpenInventorsy", function(ply, text)
    if mInventory.Config.HolsterCommand[string.lower(text)] then
        mInventory.InventoryWeapon(ply, ply:GetActiveWeapon())
    end
end)

local InventoryBlacklist = {
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

print("[mInventory] Loaded!")
print("[mInventory] Created by: YoWaitAMinute#6897")
print("[mInventory] Version: 1.0.0")

function GetWeaponDamage(weaponName)
    local damage = 0
    local weapon = weapons.Get(weaponName)

    if weapon then
        local primary = weapon.Primary or {}
        local secondary = weapon.Secondary or {}
        damage = primary.Damage or secondary.Damage or 0
    end

    return damage
end

function mInventory.InventoryWeapon(ply, weapon)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    if not IsValid(weapon) then return end

    if not weapon:IsWeapon() then
        type = "entity"
    end

    local steamID = ply:SteamID64()
    local inventory = mInventory.GetPlayerInventory(ply)

    if not inventory then
        inventory = {}
    end

    if InventoryBlacklist[weapon:GetClass()] then
        ply:ChatPrint("[mInventory] You can't inventory this item!")

        return
    end

    print(weapon:GetItemData())
    print("Weapon: " .. weapon:GetClass() .. " | " .. weapon:GetPrintName())

    if not weapon:GetItemData() then
        weapon = {
            ["name"] = weapon:GetPrintName(),
            ["amount"] = 1,
            ["skin"] = "",
            ["type"] = "weapon",
            ["signed"] = "weapon",
            ["rarity"] = "Common",
            ["UID"] = "weapon_" .. math.random(1, 9999999999),
            ["model"] = weapon:GetModel(),
            ["class"] = weapon:GetClass(),
            ["damage"] = GetWeaponDamage(weapon:GetClass()),
            ["clipsize"] = weapon:GetMaxClip1(),
            ["favorite"] = false
        }

        table.insert(inventory, weapon)
        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(inventory))
        ply.mInventory = inventory
        ply:StripWeapon(weapon.class)
        mInventory.UpdatePlayer(ply)
    else
        if InventoryBlacklist[weapon:GetClass()] then
            ply:ChatPrint("[mInventory] You can't inventory this item!")

            return
        end

        weaponData = weapon:GetItemData()

        for k, v in pairs(inventory) do
            if v.UID == weaponData.UID then
                for k, v in pairs(player.GetAll()) do
                    if v:IsAdmin() then
                        v:ChatPrint("[mInventory] " .. ply:Nick() .. " tried to dupe an item!")
                    end
                end

                ply:StripWeapon(weaponData.class)
                mInventory.UpdatePlayer(ply)

                return
            end
        end

        table.insert(inventory, weaponData)
        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(inventory))
        ply.mInventory = inventory
        ply:StripWeapon(weaponData.class)
        mInventory.UpdatePlayer(ply)
    end
end

function mInventory.CanBeDropped(item)
    if not item then return false end
    if InventoryBlacklist[item] then return false end
end

function mInventory.PlayerPickedUp(ply, item)
    if not IsValid(ply) then return end

    if not ply:IsPlayer() then
        print("[mInventory] Player is not a player!")

        return
    end
    if not item then return end
    local steamID = ply:SteamID64()
    local inventory = ply.mInventory
    table.insert(inventory, item)
    file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(inventory))
    ply.mInventory = inventory
    ply:ChatPrint("[mInventory] Picked up " .. item.name)
    mInventory.UpdatePlayer(ply)
end

function mInventory.UpdatePlayer(ply)
    net.Start("mInventory.SendInventory")
    print("Sending Inventory to " .. ply:Nick())
    net.WriteTable(ply.mInventory)
    net.WriteString(ply.mInventoryMode)
    net.Send(ply)
end

function mInventory.CreatePlayerInventory(ply)
    if not IsValid(pl) then return end
    if not pl:IsPlayer() then return end
    local steamID = pl:SteamID64()

    if not file.Exists("mInventory/" .. steamID .. ".json", "DATA") then
        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON({}))
    end
end

hook.Add("PlayerSay", "mInventory.CreatePssssayerInventory", function(p, t)
    if t == "!createinv" then
        mInventory.PlayerLoaded(p)
    end
end)

function mInventory.PlayerHasItem(ply, item)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    local steamID = ply:SteamID64()
    local inventory = ply.mInventory

    for k, v in pairs(inventory) do
        if v.UID == item.UID then return true end
    end

    return false
end

local WEAPON = FindMetaTable("Weapon")

function WEAPON:SetItemData(data)
    self.mItemData = data
    print("Set Item Data for " .. self:GetClass())
    PrintTable(data)
end

function WEAPON:GetItemData()
    return self.mItemData
end

function mInventory.EquipItem(playerEquip, item)
    if not item then
        print("[mInventory] No item to equip for " .. playerEquip:Nick() .. " (" .. steamID .. ")")

        return
    end

    if not IsValid(playerEquip) then return end
    if not playerEquip:IsPlayer() then return end
    local steamID = playerEquip:SteamID64()
    local inventory = playerEquip.mInventory

    if not mInventory.PlayerHasItem(playerEquip, item) then
        playerEquip:ChatPrint("[mInventory] You don't have this item!")

        return
    end

    if item.type == "weapon" then
        print("[mInventory] Equipping " .. item.name .. " for " .. playerEquip:Nick() .. " (" .. steamID .. ")")

        if playerEquip:HasWeapon(item.name) then
            playerEquip:ChatPrint("[mInventory] You already have this weapon!")

            return
        end

        local playerWeapon = playerEquip:GetActiveWeapon()
        playerEquip:Give(item.class)
        playerEquip:SelectWeapon(item.class)
        playerEquip:GetWeapon(item.class)
        playerEquip:GetActiveWeapon():SetItemData(item)

        for k, v in pairs(inventory) do
            if v.UID == item.UID then
                table.remove(inventory, k)
            end
        end

        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(inventory))
        playerEquip.mInventory = inventory
        mInventory.UpdatePlayer(playerEquip)
    else
        print("[mInventory] Equipping " .. item.name .. " for " .. playerEquip:Nick() .. " (" .. steamID .. ")")
    end
end

function mInventory.PlayerLoaded(ply)
    if not IsValid(ply) then return end
    local steamID = ply:SteamID64()

    if not file.Exists("mInventory/" .. steamID .. ".json", "DATA") then
        print("[mInventory] Creating inventory for " .. ply:Nick() .. " (" .. steamID .. ")")
        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON({}))
        local inventory = util.JSONToTable(file.Read("mInventory/" .. steamID .. ".json", "DATA"))
        ply.mInventory = inventory
    else
        print("[mInventory] Loading inventory for " .. ply:Nick() .. " (" .. steamID .. ")")
        local inventory = util.JSONToTable(file.Read("mInventory/" .. steamID .. ".json", "DATA"))
        ply.mInventory = inventory
    end
    -- if not file.Exists("mInventory/preferences/", "DATA"    ) then
    --     file.CreateDir("mInventory/preferences/")
    -- end
    -- if file.Exists("mInventory/preferences/" .. steamID .. ".json", "DATA") then
    --     local preferences = util.JSONToTable(file.Read("mInventory/preferences/" .. steamID .. ".json", "DATA"))
    --     ply.mInventoryPreference = preferences
    -- else
    --     file.Write("mInventory/preferences/" .. steamID .. ".json", util.TableToJSON({}))
    --     local preferences = util.JSONToTable(file.Read("mInventory/preferences/" .. steamID .. ".json", "DATA"))
    --     ply.mInventoryPreference = preferences
    -- end
end

hook.Add("PlayerInitialSpawn", "mInventory.PlayerLoadDatas", function(ply)
    mInventory.PlayerLoaded(ply)
    ply.mInventoryMode = "pages"
end)

function mInventory.GetFavoritedItems(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    for k, v in pairs(ply.mInventory) do
        if v.favorite then return v end
    end
end

function mInventory.FavoriteItem(ply, k, item)
    local steamID = ply:SteamID64()
    local inventory = ply.mInventory
    if not mInventory.PlayerHasItem(ply, item) then return end

    if ply.mInventory[k].favorite then
        ply.mInventory[k].favorite = false
        ply.mInventory = inventory
        ply:ChatPrint("[mInventory] Unfavorited " .. item.name)
        print("[mInventory] Unfavoriting " .. item.name .. " for " .. ply:Nick() .. " (" .. steamID .. ")")
        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(ply.mInventory))
        mInventory.UpdatePlayer(ply)

        return
    end

    ply.mInventory[k].favorite = true
    ply.mInventory = inventory
    ply:ChatPrint("[mInventory] Favorited " .. item.name)
    print("[mInventory] Favoriting " .. item.name .. " for " .. ply:Nick() .. " (" .. steamID .. ")")
    file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(ply.mInventory))
    mInventory.UpdatePlayer(ply)
end

function mInventory.DropItem(ply, item)
    if not item then
        print("[mInventory] No item to drop for " .. ply:Nick() .. " (" .. steamID .. ")")

        return
    end

    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    local steamID = ply:SteamID64()
    local inventory = ply.mInventory

    for k, v in pairs(inventory) do
        if v.UID == item.UID then
            f = true
        end
    end

    if item.type == "weapon" and f then
        print("[mInventory] Dropping " .. item.class .. " for " .. ply:Nick() .. " (" .. steamID .. ")")
        local weapon = ents.Create("minventory_item")
        weapon:SetPos(ply:EyePos() + ply:GetAimVector() * 50)
        weapon:SetInventoryData(item)
        weapon:Spawn()
        item.amount = item.amount - 1

        if item.amount <= 0 then
            table.remove(inventory, tonumber(item.UID))
        end

        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(inventory))
        ply.mInventory = inventory
        mInventory.UpdatePlayer(ply)
    else
        print("[mInventory] Dropping " .. item.name .. " for " .. ply:Nick() .. " (" .. steamID .. ")1")
    end
end

function mInventory.UpgradeItem(ply, k, itemData)
    if not ply then return end
    if not itemData then return end
    if itemData.rarity == "Glitched" then return end

    for k, v in pairs(mInventory.Config.Rarities2Rarities) do
        if itemData.rarity == k then
            itemData.rarity = v
            ply:ChatPrint("[mInventory] Upgraded " .. itemData.name .. " to " .. v)
        end
    end

    table.remove(ply.mInventory, k)
    table.insert(ply.mInventory, itemData)
    ply.mInventory = ply.mInventory
    file.Write("mInventory/" .. ply:SteamID64() .. ".json", util.TableToJSON(ply.mInventory))
    mInventory.UpdatePlayer(ply)
end

hook.Add("PlayerSay", "mInventory_Set_Preference", function(ply, text)
    if text == "/invmode" then
        if ply.mInventoryMode == "pages" then
            ply.mInventoryMode = "scroll"
            net.Start("mInventory.SetInventoryMode")
            net.WriteString("scroll")
            net.SendToServer()
            ply:ChatPrint("[mInventory] Inventory mode set to Scroll")
        else
            ply.mInventoryMode = "pages"
            net.Start("mInventory.SetInventoryMode")
            net.WriteString("pages")
            net.SendToServer()
            ply:ChatPrint("[mInventory] Inventory mode set to Pages")
        end
    end
end)

concommand.Add("mInventory.SetMode", function(ply, cmd, args)
    if ply.mInventoryMode == "pages" then
        ply.mInventoryMode = "scroll"
        ply:ChatPrint("[mInventory] Inventory mode set to Scroll")
    else
        ply.mInventoryMode = "pages"
        ply:ChatPrint("[mInventory] Inventory mode set to Pages")
    end
end)

concommand.Add("mInventory.WipePlayerInventory", function(ply, cmd, args)
    if not ply:IsSuperAdmin() then return end
    if not args[1] then return end
    local target = player.GetBySteamID64(args[1])
    if not IsValid(target) then return end
    file.Write("mInventory/" .. target:SteamID64() .. ".json", util.TableToJSON({}))
    target.mInventory = {}
    mInventory.UpdatePlayer(target)
    ply:ChatPrint("[mInventory] Wiped " .. target:Nick() .. "'s inventory")
end)

concommand.Add("mInventory.ItemData", function(ply, cmd, args)
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end
    local itemData = wep:GetItemData()
    if not itemData then return end
    print(util.TableToJSON(itemData))
end)

concommand.Add("mInventory.QuickEquip", function(ply, cmd, args)
    if not args[1] then return end
    local itemid = args[1]
    ply:ChatPrint("[mInventory] Equipping Weapon in 2 seconds")

    timer.Simple(2, function()
        for k, v in pairs(ply.mInventory) do
            if v.UID == itemid then
                if v.type == "weapon" then
                    mInventory.EquipItem(ply, v)
                    ply:ChatPrint("[mInventory] Equipped " .. v.name)
                    table.remove(ply.mInventory, k)
                    ply.mInventory = ply.mInventory
                    file.Write("mInventory/" .. ply:SteamID64() .. ".json", util.TableToJSON(ply.mInventory))
                    mInventory.UpdatePlayer(ply)
                end
            end
        end
    end)
end)

local rarityammo = {
    ["Legendary"] = "1.25",
    ["Epic"] = "1.2",
    ["Rare"] = "1.15",
    ["Uncommon"] = "1.1",
    ["Glitched"] = "2.5",
}

hook.Add("WeaponEquip", "mInventoryApplyRarity", function(weapon, ply)
    timer.Simple(0.1, function()
        itemData = weapon:GetItemData()
        if not itemData then return end
        if rarityammo[itemData.rarity] then
            ply:ChatPrint("[mInventory] Glitched Weapon Equipped")
            weapon.Primary.Damage = weapon.Primary.Damage * rarityammo[weapon:GetItemData().rarity]
            weapon.Primary.ClipSize = weapon.Primary.ClipSize * rarityammo[weapon:GetItemData().rarity]

            return
        end
    end)
end)

local ENTITY = FindMetaTable("Entity")

function ENTITY:GetEntItemData(ent)
    if not IsValid(ent) then return end
    local itemData = self:GetItemData()
    if not itemData then return end

    return itemData
end

function ENTITY:SetEntItemData(data)
    if not IsValid(ent) then return end
    local itemData = data
    if not itemData then return end

    return util.JSONToTable(itemData)
end

function mInventory.InventoryEntity(ply, ent)
    if not IsValid(ply) then return end
    if not IsValid(ent) then return end
    if not ply:IsPlayer() then return end
    local steamID = ply:SteamID64()
    local inventory = ply.mInventory
    local inventory2 = ent.mInventory
    local itemData = ent:GetEntItemData()
    if not mInventory.Config.EntitesWhitelist[ent:GetClass()] then return end
    if not itemData then
        itemData = {
            name = ent:GetClass(),
            type = "entity",
            class = ent:GetClass(),
            amount = 1,
            rarity = "Common",
            model = ent:GetModel(),
            UID = "entity_" .. math.random(1, 999999999)
        }

        table.insert(inventory, itemData)
        ply.mInventory = inventory
        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(inventory))
        mInventory.UpdatePlayer(ply)
        ent:Remove()
    else
        table.insert(inventory, itemData)
        ply.mInventory = inventory
        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(inventory))
        mInventory.UpdatePlayer(ply)
        ent:Remove()
    end
end
hook.Add("KeyPress", "mInventory_hook_1", function(ply, key)
    if key == IN_DUCK then
        local tr = ply:GetEyeTrace()
        local ent = tr.Entity

        if IsValid(ent) then
            if not mInventory.Config.EntitesWhitelist[ent:GetClass()] then return end
            mInventory.InventoryEntity(ply, ent)
        end
    end
end)

function mInventory.DropEntity(ply, k, itemData)
    if not IsValid(ply) then return end
    if not itemData then return end
    local steamID = ply:SteamID64()
    local inventory = ply.mInventory
    local itemData = itemData

    if mInventory.Config.EntitesWhitelist[itemData.class] then
        local ent = ents.Create(itemData.class)
        ent:SetEntItemData(itemData)
        ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0, 0, 10))
        ent:SetModel(itemData.model)
        ent:SetOwner(ply)
        ent:Spawn()
        ent:Activate()
        inventory[k] = nil
        file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(ply.mInventory))
        mInventory.UpdatePlayer(ply)
    end
end

function mInventory.DestroyItem(ply, k)
    if not IsValid(ply) then return end
    local steamID = ply:SteamID64()
    local inventory = ply.mInventory
    table.remove(inventory, k)
    file.Write("mInventory/" .. steamID .. ".json", util.TableToJSON(ply.mInventory))
    mInventory.UpdatePlayer(ply)
end

