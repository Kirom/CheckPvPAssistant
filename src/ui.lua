local _, ns = ...

-- UI module
ns.ui = {}

-- Show copy URL dialog
function ns.ui.ShowCopyURLDialog(url)
    if not url then return end

    -- Create a simple frame to display the URL
    local frame = CreateFrame("Frame", "CheckPvPCopyFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(500, 150)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- Set high frame strata to appear above LFG windows
    frame:SetFrameStrata(ns.config.FRAME_STRATA)
    frame:SetFrameLevel(ns.config.FRAME_LEVEL)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", frame.TitleBg, "TOP", 0, -5)
    frame.title:SetText(ns.config.DIALOG_TITLE)

    local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox:SetSize(460, 30)
    editBox:SetPoint("CENTER", frame, "CENTER", 0, 10)
    editBox:SetText(url)
    editBox:SetAutoFocus(true)
    editBox:HighlightText()
    editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
    editBox:SetScript("OnEnterPressed", function() frame:Hide() end)

    local instruction = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    instruction:SetPoint("BOTTOM", frame, "BOTTOM", 0, 20)
    instruction:SetText("Press Ctrl+C to copy, then press Enter or Escape to close")

    frame:Show()
end