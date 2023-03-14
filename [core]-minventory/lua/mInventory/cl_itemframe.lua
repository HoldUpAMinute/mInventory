function getSkin(skin)
    if skin == "" then
        return "None"
    else
        return skin
    end
end
function mInventory.GetMaxTableValue(tbl)
    local max = 0

    for k, v in pairs(tbl) do
        if k > max then
            max = k
        end
    end

    return tonumber(max)
end
ply = LocalPlayer()


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

function createEmptyGrid(pnl)
    for i=1, 60 do 
        local item = pnl:Add("mInventory.Slot")
        item:SetItem("none")
        item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
        item:SetPos(0, 0)
    end
end

function mInventory.DrawInventory(stat)
    if not stat then
        net.Start("mInventory.RequestInventory")
        net.SendToServer()
    end
    local bgcolor = Color(52, 52, 52, 500)
    local bcolorv2 = Color(0, 0, 0, 150)
    local btcolor = Color(32, 32, 32, 10)
    
    PIXEL.RegisterFont("mInventory.Main", "Roboto Medium", 22)
    PIXEL.RegisterFont("mInventory.WepName", "Roboto Medium", 15)
    PIXEL.RegisterFont("mInventory.InvName", "Roboto Medium", 12)
    mInventory.Inventory = mInventory.Inventory or {}
    contextmenuframe = vgui.Create("DFrame")
    contextmenuframe:SetSize(ScrW(), ScrH())

    contextmenuframe.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
    end

    if not LocalPlayer().mInventoryMode then
        LocalPlayer().mInventoryMode = "pages"
    end

    if not LocalPlayer().mInventoryPage then
        LocalPlayer().mInventoryPage = 1
    end

    inv = vgui.Create("PIXEL.Frame")
    inv:SetSize(ScrW() * 0.421, ScrH() * 0.331)
    inv:SetPos(ScrW() * 0.285, ScrH() * 0.645)
    inv:MakePopup()
    inv:SetTitle("")
    inv:SetDraggable(false)
    inv.CloseButton:SetVisible(false)

    inv.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(22, 22, 22, 450))
        PIXEL.DrawSimpleText("Inventory", "mInventory.Main", w / 2, h * 0.04, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end
    local settingsbutton = vgui.Create("DButton", inv)
        settingsbutton:SetText("")
        settingsbutton:SetSize(ScrW() * 0.05, ScrH() * 0.02)
        settingsbutton:SetPos(ScrW() * 0.365, ScrH() * 0.0075)

        settingsbutton.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, btcolor)
            PIXEL.DrawSimpleText("Settings", "mInventory.Main", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        settingsbutton.DoClick = function()
            print("Settings")
            if inv then
                inv:Remove()
            end
            if contextmenuframe then
                contextmenuframe:Remove()
            end
            mInventory.OpenSettings()
        end
        local favoritesbuttons = vgui.Create("DButton", inv)
        favoritesbuttons:SetText("")
        favoritesbuttons:SetSize(ScrW() * 0.05, ScrH() * 0.02)
        favoritesbuttons:SetPos(ScrW() * 0.31, ScrH() * 0.0075)

        favoritesbuttons.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, btcolor)
            PIXEL.DrawSimpleText("Favorites", "mInventory.Main", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.SetDrawColor(255, 255, 255, 255)
        end
        favoritesbuttons.DoClick = function()
            LocalPlayer().mFavorites = true
            if inv then
                inv:Remove()
            end
            if contextmenuframe then
                contextmenuframe:Remove()
            end
            mInventory.DrawInventory(stat)
        end
    if LocalPlayer().mInventoryMode == "pages" then

        local page1button = vgui.Create("DButton", inv)
        page1button:SetText("")
        page1button:SetWide(ScrW() * 0.01)
        page1button:SetPos(ScrW() * 0.006, ScrH() * 0.0075)

        page1button.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(22, 22, 22, 250))
            PIXEL.DrawSimpleText("1", "mInventory.Main", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        page1button.DoClick = function()
            LocalPlayer().mFavorites = false
            LocalPlayer():ChatPrint("Page 1")
            LocalPlayer().mInventoryPage = 1
            if inv then
                inv:Remove()
            end
            if contextmenuframe then
                contextmenuframe:Remove()
            end
            mInventory.DrawInventory(stat)
        end

        local page2button = vgui.Create("DButton", inv)
        page2button:SetText("")
        page2button:SetWide(ScrW() * 0.01)
        page2button:SetPos(ScrW() * 0.0175, ScrH() * 0.0075)

        page2button.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(22, 22, 22, 250))
            PIXEL.DrawSimpleText("2", "mInventory.Main", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        page2button.DoClick = function()
            LocalPlayer().mFavorites = false
            LocalPlayer():ChatPrint("Page 2")
            LocalPlayer().mInventoryPage = 2
            if inv then
                inv:Remove()
            end
            if contextmenuframe then
                contextmenuframe:Remove()
            end
            mInventory.DrawInventory(stat)
        end

        local page3button = vgui.Create("DButton", inv)
        page3button:SetText("")
        page3button:SetWide(ScrW() * 0.01)
        page3button:SetPos(ScrW() * 0.0295, ScrH() * 0.0075)

        page3button.Paint = function(self, w, h)
            PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(22, 22, 22, 250))
            PIXEL.DrawSimpleText("3", "mInventory.Main", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        page3button.DoClick = function()
            LocalPlayer().mFavorites = false
            LocalPlayer():ChatPrint("Page 3")
            LocalPlayer().mInventoryPage = 3
            if inv then
                inv:Remove()
            end
            if contextmenuframe then
                contextmenuframe:Remove()
            end
            mInventory.DrawInventory(stat)
        end
    end
    local scroll = vgui.Create("PIXEL.ScrollPanel", inv)
    scroll:Dock(FILL)
    scroll:DockMargin(0, 0, 0, 0)
    function getMode()
        if LocalPlayer().mInventoryMode == "pages" then
            return false
        elseif LocalPlayer().mInventoryMode == "scroll" then
            return true
        end
    end
    if not getMode() then
        invlist = vgui.Create("DIconLayout", inv)
        invlist:Dock(FILL)
        invlist:DockMargin(0, 0, 0, 0)
        invlist:SetSpaceX(5)
        invlist:SetSpaceY(5)
    else
        invlist = vgui.Create("DIconLayout", scroll)
        invlist:Dock(FILL)
        invlist:DockMargin(0, 0, 0, 0)
        invlist:SetSpaceX(5)
        invlist:SetSpaceY(5)
    end

    invlist.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 0))
        
    end

    // if not LocalPlayer().mInventory or table.IsEmpty(LocalPlayer().mInventory) then
    //     mInventory.PopulateLayout(invlist, mInventory.Config.MaxItems[LocalPlayer():GetUserGroup()])
    // end

    print(mInventory.GetMaxTableValue(LocalPlayer().mInventory))

    for k, v in pairs(LocalPlayer().mInventory) do
        PrintTable(v)
        print("status" .. tostring(LocalPlayer().mFavorites))
        if LocalPlayer().mInventoryMode == "pages" and not LocalPlayer().mFavorites then
            if LocalPlayer().mInventoryPage == 1 then
                if k <= 40 and not v.favorite then
                    local item = invlist:Add("mInventory.Slot")
                    item:SetItem(v)
                    item:SetKey(k)
                    item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
                    item:SetPos(0, 0)
                end
            elseif LocalPlayer().mInventoryPage == 2 then
                if k > 40 and k <= 80 and not v.favorite then
                    local item = invlist:Add("mInventory.Slot")
                    item:SetItem(v)
                    item:SetKey(k)
                    item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
                    item:SetPos(0, 0)
                end 
            elseif LocalPlayer().mInventoryPage == 3 then
                if k > 80 and k <= 120 and not v.favorite then
                    local item = invlist:Add("mInventory.Slot")
                    item:SetItem(v)
                    item:SetKey(k)
                    item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
                    item:SetPos(0, 0)
                end
            end
        end
        if LocalPlayer().mInventoryMode == "scroll" then
            local item = invlist:Add("mInventory.Slot")
            item:SetItem(v)
            item:SetKey(k)
            item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
            item:SetPos(0, 0)
        end
        if LocalPlayer().mFavorites then
            PrintTable(LocalPlayer().mInventory)
            if v.favorite then
                print("Item : " .. v.name .. " is a favorite")
                local item = invlist:Add("mInventory.Slot")
                item:SetItem(v)
                item:SetKey(k)
                item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
                item:SetPos(0, 0)
            end
        end
    end
    function createEmptyGridScroll(pnl)
        for i = 1, mInventory.Config.MaxItems[LocalPlayer():GetUserGroup()] - mInventory.GetMaxTableValue(LocalPlayer().mInventory) do
            local item = pnl:Add("mInventory.Slot")
            item:SetItem("none")
            item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
            item:SetPos(0, 0)
        end
    end
    if LocalPlayer().mInventoryMode == "pages" then
        createEmptyGrid(invlist)
    end

    if LocalPlayer().mInventoryMode == "scroll" then
        createEmptyGridScroll(invlist)
    end

    function mInventory.IsMouseHovering(pnl)
        if not pnl then return false end
        local x, y = pnl:LocalToScreen(0, 0)
        local w, h = pnl:GetSize()
        local mx, my = gui.MousePos()

        return mx >= x and mx <= x + w and my >= y and my <= y + h
    end

    function mInventory.GetMaxItems()
        return mInventory.Config.MaxItems[LocalPlayer():GetUserGroup()]
    end

    function mInventory.PopulateLayout(pnl, am)
        print("Populating" .. am)
        -- for i = 1, am do
        --     local item = pnl:Add("DPanel")
        --     item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
        --     item.Paint = function(self, w, h)
        --         PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(40, 40, 40, 250))
        --     end
        -- end
    end

    function createEmptyGrid(pnl)
        for i=1, 60 do 
            local item = pnl:Add("mInventory.Slot")
            item:SetItem("none")
            item:SetSize(PIXEL.Scale(75), PIXEL.Scale(75))
            item:SetPos(0, 0)
        end
    end

    function redrawInventory()
        if inv then
            inv:Remove()
        end

        mInventory.OpenInventory()
    end
end

function mInventory.OpenSettings()
        
    PIXEL.RegisterFont("mInventory.Main", "Roboto Medium", 22)
    PIXEL.RegisterFont("mInventory.WepName", "Roboto Medium", 15)
    PIXEL.RegisterFont("mInventory.InvName", "Roboto Medium", 12)
    local settings = vgui.Create("DFrame")
    settings:SetSize(PIXEL.Scale(500), PIXEL.Scale(500))
    settings:Center()
    settings:SetTitle("")
    settings:ShowCloseButton(false)
    settings:MakePopup()
    settings.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(10, 0, 0, w, h, Color(22, 22, 22, 500))
        PIXEL.DrawSimpleText("Settings", "mInventory.Main", w / 2, PIXEL.Scale(25), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local closebutton = vgui.Create("DButton", settings)
    closebutton:SetSize(PIXEL.Scale(25), PIXEL.Scale(25))
    closebutton:SetPos(settings:GetWide() - PIXEL.Scale(25), 0)
    closebutton:SetColor(Color(255, 0, 0))
    closebutton:SetText("")
    closebutton.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 250))
        PIXEL.DrawSimpleText("X", "mInventory.Main", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closebutton.DoClick = function()
        settings:Remove()
    end
    function getRainbowStatus()
        if tostring(LocalPlayer().mInventoryRainbowMode) == "true" then
            return "Enabled"
        else
            return "Disabled"
        end
    end
    function getScrollStatus()
        if LocalPlayer().mInventoryMode == "pages" then 
            return "Pages"
        elseif LocalPlayer().mInventoryMode == "scroll" then
            return "Scroll"
        end
    end
    local rainbowoption = vgui.Create("DButton", settings)
    rainbowoption:SetPos(PIXEL.Scale(25), PIXEL.Scale(50))
    rainbowoption:SetSize(PIXEL.Scale(450), PIXEL.Scale(25))
    rainbowoption:SetText("")
    rainbowoption.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(0, 0, 0, w, h, Color(32, 32, 32, 500))
        PIXEL.DrawSimpleText("Rainbow Mode " .. getRainbowStatus(), "mInventory.Main", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    rainbowoption.DoClick = function()
        if LocalPlayer().mInventoryRainbowMode == true then
            LocalPlayer().mInventoryRainbowMode = false
        else
            LocalPlayer().mInventoryRainbowMode = true
        end
    end
    local scrollmode = vgui.Create("DButton", settings)
    scrollmode:SetPos(ScrW() * 0.0135, ScrH() * 0.08)
    scrollmode:SetSize(PIXEL.Scale(450), PIXEL.Scale(25))
    scrollmode:SetText("")
    scrollmode.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(0, 0, 0, w, h, Color(32, 32, 32, 500))
        PIXEL.DrawSimpleText("Inventory Mode : " .. getScrollStatus(), "mInventory.Main", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    scrollmode.DoClick = function()
        if LocalPlayer().mInventoryMode == "pages" then
            LocalPlayer().mInventoryMode = "scroll"
            LocalPlayer():ConCommand("mInventory.SetMode")
        else
            LocalPlayer().mInventoryMode = "pages"
            LocalPlayer():ConCommand("mInventory.SetMode")
        end
    end
    // rainbowoption.OnChange = function(self, val)
    // if val == true then
    //     LocalPlayer().mInventoryRainbowMode = true
    // else 
    //     LocalPlayer().mInventoryRainbowMode = false
    // end
    // end
end


