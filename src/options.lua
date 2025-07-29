local _, ns = ...

-- Options module for settings UI
ns.options = {}

-- Constants for styling
local PADDING = 20

-- Create the main options panel
local function CreateOptionsPanel()
    local panel = CreateFrame("Frame", "CheckPvPAssistantOptionsPanel", InterfaceOptionsFramePanelContainer)
    panel.name = "Check-PvP Assistant"
    panel:Hide()

    -- Background
    panel:SetAllPoints()

    -- Title
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", panel, "TOPLEFT", PADDING, -PADDING)
    title:SetText("Check-PvP Assistant")

    local yOffset = -50

    -- Copy Mode Label
    local copyModeLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    copyModeLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", PADDING, yOffset)
    copyModeLabel:SetText("Copy Mode")

    yOffset = yOffset - 25

    -- Copy Mode Dropdown
    local copyModeDropdown = CreateFrame("Frame", "CheckPvPCopyModeDropdown", panel, "UIDropDownMenuTemplate")
    copyModeDropdown:SetPoint("TOPLEFT", panel, "TOPLEFT", PADDING - 15, yOffset)
    UIDropDownMenu_SetWidth(copyModeDropdown, 200)
    UIDropDownMenu_SetText(copyModeDropdown, "")

    -- Dropdown initialization function
    UIDropDownMenu_Initialize(copyModeDropdown, function()
        -- Full URL option
        local info1 = UIDropDownMenu_CreateInfo()
        info1.text = "Full URL"
        info1.value = "url"
        info1.func = function()
            ns.SetConfig("COPY_MODE", "url")
            UIDropDownMenu_SetSelectedValue(copyModeDropdown, "url")
        end
        info1.checked = (ns.config.COPY_MODE == "url")
        UIDropDownMenu_AddButton(info1)

        -- Name-realm option
        local info2 = UIDropDownMenu_CreateInfo()
        info2.text = "Name-Realm"
        info2.value = "name"
        info2.func = function()
            ns.SetConfig("COPY_MODE", "name")
            UIDropDownMenu_SetSelectedValue(copyModeDropdown, "name")
        end
        info2.checked = (ns.config.COPY_MODE == "name")
        UIDropDownMenu_AddButton(info2)
    end)

    yOffset = yOffset - 50

    -- Auto-close checkbox
    local autoCloseCheck = CreateFrame(
        "CheckButton", "CheckPvPAutoCloseCheck", panel,"InterfaceOptionsCheckButtonTemplate"
    )
    autoCloseCheck:SetPoint("TOPLEFT", panel, "TOPLEFT", PADDING, yOffset)
    autoCloseCheck.Text:SetText("Auto-close dialog after copying")
    autoCloseCheck:SetScript("OnClick", function(self)
        ns.SetConfig("AUTO_CLOSE_DIALOG", self:GetChecked())
    end)

    -- Footer with author information
    local footer = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    footer:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -PADDING, PADDING)
    footer:SetText("Made by Kirom")
    footer:SetTextColor(0.7, 0.7, 0.7)

    -- Store controls for easy access
    panel.controls = {
        copyModeDropdown = copyModeDropdown,
        autoCloseCheck = autoCloseCheck
    }

    -- Function to refresh the panel with current settings
    panel.refresh = function()
        local copyMode = ns.config.COPY_MODE
        UIDropDownMenu_SetSelectedValue(copyModeDropdown, copyMode)
        if copyMode == "url" then
            UIDropDownMenu_SetText(copyModeDropdown, "Full URL")
        else
            UIDropDownMenu_SetText(copyModeDropdown, "Name-Realm")
        end
        autoCloseCheck:SetChecked(ns.config.AUTO_CLOSE_DIALOG)
    end

    return panel
end

-- Function to refresh options panel if it exists
function ns.options.RefreshOptionsPanel()
    if ns.options and ns.options.panel and ns.options.panel.refresh then
        ns.options.panel.refresh()
    end
end

-- Create and register the options panel
function ns.options.Initialize()
    local panel = CreateOptionsPanel()

    -- Register with WoW's interface options
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)
    ns.options.category = category

    -- Store reference
    ns.options.panel = panel

    -- Refresh panel when it's shown
    panel:SetScript("OnShow", function(self)
        if self.refresh then
            self.refresh()
        end
    end)
end

-- Function to open the options panel
function ns.options.Open()
    if ns.options.category then
        Settings.OpenToCategory(ns.options.category:GetID())
    else
        Settings.OpenToCategory(ns.options.panel.name)
    end
end