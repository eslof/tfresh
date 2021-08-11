local FOLDER_NAME,tfresh=...;

local bars = {
    "Default Bar Page 1", 
    "Default Bar Page 2", 
    "Bottom Left Bar",
    "Bottom Right Bar",
    "Right Bar",
    "Right Bar 2"
};

local keyMap = {1, 13, 61, 49, 25, 37};

local dropDownDisplayDelimeter = ": Button ";

local function slotToBar(actionSlot)
    if actionSlot >= keyMap[3] then return 3;
    elseif actionSlot >= keyMap[4] then return 4;
    elseif actionSlot >= keyMap[6] then return 6;
    elseif actionSlot >= keyMap[5] then return 5;
    elseif actionSlot >= keyMap[2] then return 2;
    else return 1;
    end
end
 
-- Create the dropdown, and configure its appearance

local function newInitFunc(id)
    return function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo();
        if (level or 1) == 1 then
            -- Display the 0-9, 10-19, ... groups
            for i=1,6 do
                info.text = bars[i];
                info.menuList = {i, id};
                info.checked = slotToBar(tfresh.config.slots[info.menuList[2]]) == info.menuList[1];
                info.hasArrow = true;
                UIDropDownMenu_AddButton(info);
            end
        else
            -- Display a nested group of 10 favorite number options
            info.func = self.SetValue
            local n = 1;
            local bar = menuList[1];
            for i=bar*10, bar*10+11 do
                local actionSlot = keyMap[bar]+n-1;
                info.text = tostring(n);
                info.arg1 = {actionSlot, bar};
                info.arg2 = menuList[2];
                info.checked = tfresh.config.slots[menuList[2]] == actionSlot;
                UIDropDownMenu_AddButton(info, level);
                n = n + 1;
            end
        end
    end
end

tfresh.newDropDown = function(id, parentFrame)
    local bar = slotToBar(tfresh.config.slots[id]);
    local dropDown = CreateFrame("FRAME", "ActionSlotDropDown", parentFrame, "UIDropDownMenuTemplate");
    dropDown:SetPoint("CENTER", 0, (24*2)-(id*24));
    UIDropDownMenu_SetWidth(dropDown, 200);
    UIDropDownMenu_SetText(dropDown, bars[bar]..dropDownDisplayDelimeter..tostring(tfresh.config.slots[id] - (keyMap[bar]-1)));
    function dropDown:SetValue(arg1, arg2, checked)
        local actionSlot, bar, ddId = arg1[1], arg1[2], arg2;
        UIDropDownMenu_SetText(dropDown, bars[bar]..dropDownDisplayDelimeter..tostring(actionSlot - (keyMap[bar]-1)));
        tfresh.config.slots[ddId] = actionSlot;
        -- Because this is called from a sub-menu, only that menu level is closed by default.
        -- Close the entire menu with this next call
        CloseDropDownMenus();
    end
    UIDropDownMenu_Initialize(dropDown, newInitFunc(id));
    return dropDown;
end

tfresh.reset = function(dropDownTable)
    for i, v in ipairs(dropDownTable) do
        local bar = slotToBar(tfresh.config.slots[i]);
        UIDropDownMenu_SetText(v, bars[bar]..dropDownDisplayDelimeter..tostring(tfresh.config.slots[i] - (keyMap[slotToBar(tfresh.config.slots[i])]-1)));
    end
end

tfresh.newText = function(frame, name, text, xoff, yoff)
    frame[name] = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    frame[name]:SetPoint("CENTER", xoff, yoff);
    frame[name]:SetText(text);
end