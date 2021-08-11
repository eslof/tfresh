local FOLDER_NAME,tfresh=...;

local totemMacroName = "TotemSequence";
local defaultIcon = "INV_Misc_QuestionMark";

tfresh.copy = function(t)
  local r = { }
  for k, v in pairs(t) do r[k] = v end
  return setmetatable(r, getmetatable(t))
end

tfresh.saveMacro = function(body)
    local mIndex = GetMacroIndexByName(totemMacroName);
    if mIndex == 0 then
        CreateMacro(totemMacroName, defaultIcon, body, 1);
    else
        EditMacro(mIndex, nil, nil, body, 1, 1);
    end

    if MacroFrame_Update ~= nil then
        MacroFrame_Update();
    end
end

tfresh.split = function(s, delimiter)
    result = {};
    count = 0;
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
        count = count + 1;
    end
    return result, count;
end

tfresh.getSpells = function(slots)
    local spellTable = {};
    local spellCount = 0;
    for i=1,4 do
        local aType, id = GetActionInfo(slots[i]);
        local aName = GetSpellInfo(id);
	    if aName ~= nil and aName ~= "" then
            table.insert(spellTable, aName);
            spellCount = spellCount + 1;
        end
    end
    return spellTable, spellCount;
end