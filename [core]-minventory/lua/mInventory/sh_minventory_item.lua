local ENT = {}
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "mInventory Item"
ENT.Author = "mInventory Development"
ENT.Category = "mInventory"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ItemData")
    self:NetworkVar("String", 1, "ItemName")
    self:NetworkVar("String", 2, "ItemRarity")
    self:NetworkVar("String", 3, "ItemSkin")
end

function ENT:Initialize()
    self.ItemData = self.ItemData or {}
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NOCLIP)
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
    self:SetModel(self.ItemData.model or "models/props_junk/wood_crate001a.mdl")
    self:SetItemName(self.ItemData.name or "Item")
end
function getColor(rarity)
    if rarity == "Common" then
        return Color(125, 125, 125)
    elseif rarity == "Uncommon" then
        return Color(0, 93, 0)
    elseif rarity == "Rare" then
        return Color(0, 0, 150)
    elseif rarity == "Epic" then
        return Color(125, 0, 125)
    elseif rarity == "Legendary" then
        return Color(125, 125, 0)
    elseif rarity == "Mythical" then
        return Color(125, 0, 0)
    elseif rarity == "Glitched" then
        if LocalPlayer().mInventoryRainbowMode then
            return HSVToColor(CurTime() % 6 * 60, 0.5, 0.75, 100)
        else
            return Color(0, 63, 195)
        end
    end
end
function getSkin(skin)
    if skin == "" then
        return "None"
    else
        return skin
    end
end
function ENT:Use(activator, caller)
    if activator:IsPlayer() then
        if not self.ItemData then return end
        net.Start("mInventory.ItemPickedUp")
        net.WriteTable(self.ItemData)
        net.Send(activator)
        self:Remove()
    end
end

function ENT:SetInventoryData(data)
    self.ItemData = data
    self:SetItemData(util.TableToJSON(data))
    self:SetItemName(data.name)
    self:SetItemRarity(data.rarity)
    self:SetItemSkin(data.skin)
    self:SetItemData(util.TableToJSON(data))
end

function ENT:GetItemData()
    return self.ItemData
end

local rarityColors = {
    Common = Color(100, 100, 100),
    Uncommon = Color(0, 75, 0),
    Rare = Color(0, 0, 75),
    Epic = Color(100, 0, 100),
    Legendary = Color(100, 100, 0),
    Mythical = Color(100, 0, 0),
    Glitched = HSVToColor(math.random(0, 360), 1, 1)
}

function ENT:Draw()
    local bgcolor = Color(19, 4, 54, 500)
    local bcolorv2 = Color(0, 0, 0, 150)
    local btcolor = Color(32, 32, 32, 10)
    
    PIXEL.RegisterFont("mInventory.Main", "Roboto Medium", 22)
    PIXEL.RegisterFont("mInventory.WepName", "Roboto Medium", 15)
    PIXEL.RegisterFont("mInventory.InvName", "Roboto Medium", 12)
    if LocalPlayer():GetPos():Distance(self:GetPos()) > 250 then return end
    local ply = LocalPlayer()
    local pos = self:GetPos()
    local eyePos = ply:GetPos()
    local dist = pos:Distance(eyePos)
    local alpha = math.Clamp(2500 - dist * 2.7, 0, 255)
    if alpha <= 0 then return end
    local angle = self:GetAngles()
    local eyeAngle = ply:EyeAngles()
    angle:RotateAroundAxis(angle:Forward(), 90)
    angle:RotateAroundAxis(angle:Right(), -90)
    -- Draw overhead text
    local itemName = self:GetItemName()
    local itemRarity = self:GetItemRarity()
    local itemSkin = self.ItemData.skin or "None"
    cam.Start3D2D(pos + self:GetUp() * 15, Angle(0, eyeAngle.y - 90, 90), 0.04)
    PIXEL.DrawRoundedBox(10, -100, -100, 400, 200, bgcolor)
    PIXEL.DrawRoundedBox(8, -90, -90, 377.5, 176.5, bcolorv2)
    PIXEL.DrawText(itemName, "mInventory.ItemName", ScrW() * 0.05, ScrH() * -0.08, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    PIXEL.DrawText("Rarity: " .. itemRarity, "mInventory.ItemName", ScrW() * 0.05, ScrH() * -0.045, getColor(self:GetItemRarity()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    PIXEL.DrawText("Skin: " .. getSkin(itemSkin), "mInventory.ItemName", ScrW() * 0.05, ScrH() * -0.01, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    PIXEL.DrawText("Press E to pick up", "mInventory.ItemName", ScrW() * 0.05, ScrH() * 0.03, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    cam.End3D2D()
    -- Draw entity model
    self:DrawModel()
end

-- Register entity
scripted_ents.Register(ENT, "minventory_item", true)