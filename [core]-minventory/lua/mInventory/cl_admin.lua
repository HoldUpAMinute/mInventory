function drawAdminMenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(PIXEL.Scale(500), PIXEL.Scale(500))
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton(true)
    frame:SetDraggable(false)
    frame:SetTitle("Admin Menu")
    frame.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 150))
    end
    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)
    scroll:DockMargin(0, 0, 0, 0)
    scroll.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 150))
    end
    local list = vgui.Create("DIconLayout", scroll)
    list:Dock(FILL)
    list:DockMargin(0, 0, 0, 0)
    list:SetSpaceX(5)
    list:SetSpaceY(5)
    list.Paint = function(self, w, h)
        PIXEL.DrawRoundedBox(0, 0, 0, w, h, Color(28, 28, 28, 150))
    end
    local button = list:Add("DButton")
    button:SetSize(PIXEL.Scale(100), PIXEL.Scale(20))
    button:SetPos(PIXEL.Scale(100), PIXEL.Scale(100))
    button:SetText("Spawn Item")
end