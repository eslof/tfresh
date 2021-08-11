local FOLDER_NAME,tfresh=...;

if TFreshConfig == nil then
    TFreshConfig = {slots = {13, 14, 15, 16}};
end

tfresh.config = tfresh.copy(TFreshConfig);

local sequencePrefix = "/castsequence";
local resetTag = " reset=";

local helpText = [[
(TFresh) Usage: /tfresh condition/s
Short-hand for no condition is 0.

Ex.: /tfresh 0 -> no reset condition.
/tfresh 8/combat -> reset at 8sec or combat end.
]];


SLASH_TFRESH1 = "/tfresh";
SlashCmdList["TFRESH"] = function(paramStr)
    paramStr = string.lower(paramStr);

    if not paramStr or paramStr:match("^%s*$") then -- no params given, act on defaults
        print(helpText);
        do return end;
    end

    local resetStr = tfresh.validateAndGetParams(paramStr);
    if resetStr == nil then
        do return end;
    end

    local spellList, tCount = tfresh.getSpells(tfresh.config.slots);

    if tCount == 0 then
       totemMacro = "";
    else
        local tStr = " "..(tCount > 1 and table.concat(spellList, ", ") or spellList[1]);
        totemMacro = sequencePrefix..(resetStr ~= "" and resetTag..resetStr or "")..tStr;
    end

    if #totemMacro > 255 then
        print("(TFresh) Macro too long.")
        do return end;
    end

    tfresh.saveMacro(totemMacro);
end