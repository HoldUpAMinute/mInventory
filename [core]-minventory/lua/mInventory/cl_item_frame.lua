local PANEL = {}
local Lerp = Lerp

function PANEL:Init()
    PIXEL.RegisterFont("mInventory.WepName", "Roboto Medium", 15)
    self.ItemData = {}
    local bgcolor = Color(52, 52, 52, 500)
    local bcolorv2 = Color(0, 0, 0, 150)
    local btcolor = Color(32, 32, 32, 10)

    itemframe = self:Add("DPanel")
    itemframe:SetTall(ScrH() * 0.07)
    itemframe:SetWide(ScrW() * 0.04)
    itemframe.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(10, 0, 0, w, h, bgcolor)
        PIXEL.DrawRoundedBox(10, w * 0.02, h * 0.02, w * 0.94, h * 0.95, bcolorv2)
    end
    self.itemmodel = itemframe:Add("SpawnIcon") -- make itemmodel a member variable -- increase size by 100%
    self.itembutton = itemframe:Add("DButton")
    self.itembutton:SetSize(itemframe:GetWide(), itemframe:GetTall())
    self.itembutton:SetText("")
    self.itembutton.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(10, 0, 0, w, h, btcolor)
    end
    self.itembutton.DoRightClick = function()
        local mInventory_Item_Popup = itemframe:Add("PIXEL.Menu")
        mInventory_Item_Popup:SetPos(gui.MouseX(), gui.MouseY())
        mInventory_Item_Popup:SetSize(100, 100)
    if self.ItemData.type == "weapon" then
        mInventory_Item_Popup:AddOption("Equip", function()
            if self.ItemData  == "none" then 
                mInventory_Item_Popup:Remove()    
               return
            end 
            net.Start("mInventory.ItemEquipped")
            net.WriteTable(self.ItemData)
            net.SendToServer()
            mInventory_Item_Popup:Remove()
        end)
        mInventory_Item_Popup:AddOption("Copy Weapon ID", function()
            if self.ItemData  == "none" then 
                mInventory_Item_Popup:Remove()    
               return
            end 
            SetClipboardText(self.ItemData.UID)
            mInventory_Item_Popup:Remove()
        end)
        mInventory_Item_Popup:AddOption("Drop", function()
            net.Start("mInventory.ItemDropped")
            net.WriteTable(self.ItemData)
            net.SendToServer()
            mInventory_Item_Popup:Remove()    
            mInventory_Item_Popup:Remove()
        end)
        mInventory_Item_Popup:AddOption("Destroy", function()
            if not self.ItemData then 
                mInventory_Item_Popup:Remove()    
               return
            end 
            net.Start("mInventory.DestroyItem")
            net.WriteInt(self:GetKey(), 32)
            net.SendToServer()
            mInventory_Item_Popup:Remove()
        end)
        mInventory_Item_Popup:AddOption("Information", function()
            self:DrawInformation(self.ItemData)
        end)
        mInventory_Item_Popup:AddOption("Favorite", function()
            if not self.ItemData then 
                mInventory_Item_Popup:Remove()    
               return
            end 
            net.Start("mInventory.FavoriteItem")
            net.WriteTable(self.ItemData)
            net.WriteUInt(self:GetKey(), 32)
            net.SendToServer()
            mInventory_Item_Popup:Remove()
        end)
        mInventory_Item_Popup:AddOption("Upgrade", function()
            if not self.ItemData then 
                mInventory_Item_Popup:Remove()    
               return
            end 
            net.Start("mInventory.UpgradeItem")
            net.WriteTable(self.ItemData)
            net.WriteUInt(self:GetKey(), 32)
            net.SendToServer()
            mInventory_Item_Popup:Remove()
        timer.Simple(0.1, function()
            if inv then
                inv:Remove()
            end
            if contextmenuframe then
                contextmenuframe:Remove()
            end
            mInventory.DrawInventory(stat)
        end)
        end)
    elseif self.ItemData.type == "entity" then
        mInventory_Item_Popup:AddOption("Drop", function()
            net.Start("mInventory.DropEntity")
            net.WriteUInt(self:GetKey(), 32)
            net.WriteTable(self.ItemData)
            net.SendToServer()
            mInventory_Item_Popup:Remove()    
        end)
        mInventory_Item_Popup:AddOption("Destroy", function()
            if not self.ItemData then 
                mInventory_Item_Popup:Remove()    
               return
            end 
            net.Start("mInventory.DestroyItem")
            net.WriteInt(self:GetKey(), 32)
            net.SendToServer()
            mInventory_Item_Popup:Remove()
        end)
    end
        mInventory_Item_Popup:Open()
        mInventory_Item_Popup.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(52, 52, 52, 500))
        end
    end
    self.itembutton.OnCursorEntered = function()
        self.itembutton.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 150))
        end
        self:DrawInformation(self.ItemData)
        // local mInventory_Item_Information = itemframe:Add("DModelPanel")
        // mInventory_Item_Information:SetPos(gui.MouseX(), gui.MouseY())
        // mInventory_Item_Information:SetSize(100, 100)
        // mInventory_Item_Information.Paint = function(self, w, h)
        //     PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(52, 52, 52, 500))
        //     PIXEL.DrawText(self.ItemData.name, "mInventory.ItemName", w * 0.5, h * 0.1, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        // end
    end
    self.itembutton.OnCursorExited = function()
        print("Tes2t")
        if ItemInformationWindow then 
            ItemInformationWindow:Remove()
        end
        self.itembutton.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(32, 32, 32, 10))
        end
        if mInventory_Item_Information then
            mInventory_Item_Information:Destroy()
        end
    end

end
    
function PANEL:SetSlot(slot)
    self.Slot = slot
end



function getColor(rarity)
    if rarity == "Common" then
        return Color(125, 125, 125)
    elseif rarity == "Uncommon" then
        return Color(0, 93, 0)
    elseif rarity == "Rare" then
        return Color(25, 126, 194)
    elseif rarity == "Epic" then
        return Color(125, 0, 125)
    elseif rarity == "Legendary" then
        return Color(199, 142, 8)
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

function PANEL:SetItem(data)
    if data == "none" then 
        self.ItemData = "none"
    else
        data = data or {}
        self.itemmodel:SetModel(data.model or "models/props_c17/canister_propane01a.mdl")
        self.ItemData = data

        itemframe.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, getColor(data.rarity))
            PIXEL.DrawRoundedBox(10, w * 0.02, h * 0.02, w * 0.94, h * 0.95, Color(0, 0, 0, 150))
            // PIXEL.DrawText(data.name, "mInventory.WepName", w * 0.5, h * 0.1, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        print("data sent")
    end
end

function PANEL:SetKey(key)
    self.Key = key
    print("key set")
end

function PANEL:GetKey()
    return self.Key
end

function PANEL:GetItem()
    PrintTable(self.ItemData)
    return self.ItemData
end

function PANEL:Paint(w, h)
    if self.ItemData == "none" then
        self.itemmodel:Remove()
        self.itembutton:Remove()
    else
    self.itemmodel:SetSize(itemframe:GetWide() * 1, itemframe:GetTall() * 1) 
    self.itemmodel:PaintManual()
    end
end

function PANEL:OnStartDragging()
    self:GetItem()
    self:MouseCapture(true)
    self.Dragging = true

end

function PANEL:DrawInformation(data)
    local bgcolor = Color(52, 52, 52, 500)
    local bcolorv2 = Color(0, 0, 0, 150)
    local btcolor = Color(32, 32, 32, 10)
    PIXEL.RegisterFont("mInventory.WepNameBig", "Roboto Medium", 30)
    PIXEL.RegisterFont("mInventory.ItemName", "Roboto Medium", 30)
    local ItemInformationWindow = vgui.Create("DFrame", contextmenuframe)
    local mx, my = gui.MousePos()
    ItemInformationWindow:SetSize(ScrW() * 0.421, ScrH() * 0.35)
    ItemInformationWindow:SetPos(ScrW() * 0.285, ScrH() * 0.25)
    ItemInformationWindow:SetTitle("")
    ItemInformationWindow:ShowCloseButton(false)
    ItemInformationWindow.Paint = function(self, w, h)
        // PIXEL.DrawRoundedBox(10, 0, 0, w * 0.01, h * 0.1, bgcolor)
        // PIXEL.DrawRoundedBox(10, w * 0.02, h * 0.02, w * 0.5, h * 0.1, bcolorv2)
        if data.type == "weapon" then
        PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(22, 22, 22, 500))
        PIXEL.DrawRoundedBox(10, w * 0.04, h * 0.12, w * 0.35, h * 0.75, getColor(data.rarity))
        PIXEL.DrawRoundedBox(10, w * 0.045, h * 0.13, w * 0.34, h * 0.7295, bcolorv2)
        local modelpanel = vgui.Create("SpawnIcon", ItemInformationWindow)
        modelpanel:SetPos(w * 0.045, h * 0.13)
        modelpanel:SetSize(w * 0.34, h * 0.7295)
        modelpanel:SetModel(data.model)
        modelpanel:SetToolTip()
        PIXEL.DrawText(data.name, "mInventory.WepNameBig", w * 0.7, h * 0.1, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        PIXEL.DrawText("Skin: " .. getSkin(data.skin), "mInventory.ItemName", w * 0.7, h * 0.3, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        PIXEL.DrawText("Rarity: " .. data.rarity, "mInventory.ItemName", w * 0.7, h * 0.4, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        PIXEL.DrawText("ID: " .. data.UID, "mInventory.ItemName", w * 0.7, h * 0.5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        PIXEL.DrawText("Favorite: " .. tostring(data.favorite), "mInventory.ItemName", w * 0.7, h * 0.6, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return
    end
    end
end

vgui.Register("mInventory.Slot", PANEL, "Panel")


local cmd =[[
    bind "t" if ply:HasWeapon("weapon_gblaster") then use weapon_gblaster; LocalPlayer():Say("/invholster") elseif ply:HasWeapon("weapon_glock2") then use weapon_glock2; ply:Say("/invholster") end
]]