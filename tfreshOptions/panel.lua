local FOLDER_NAME,tfresh=...;

local f = CreateFrame("frame", "TFreshInterfaceOptionsPanel", UIParent, "BackdropTemplate");
f.name = "TFresh";

tfresh.newText(f, "sequenceText", "Castsequence these buttons:", 0, (24*2));

local dropDownTable = {};
for i = 1, 4 do
    local dropDown = tfresh.newDropDown(i, f);
    f["dropDown"..tostring(i)] = dropDown;
    dropDownTable[i] = dropDown;
end

f.okay = function (self) 
    TFreshConfig.slots = tfresh.copy(tfresh.config.slots); 
end

f.cancel = function (self) 
    tfresh.config.slots = tfresh.copy(TFreshConfig.slots); 
    tfresh.reset(dropDownTable); 
end

InterfaceOptions_AddCategory(f);