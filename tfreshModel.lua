local FOLDER_NAME,tfresh=...;

local validConditions = {"target", "combat", "alt", "shift", "ctrl"};
local resetDelimeter = "/";

tfresh.isValidResetConditions = function(resetParam)
    local resetList, resetCount = tfresh.split(resetParam, resetDelimeter);

    local dupeCheck = tfresh.copy(validConditions);
    dupeCheck["seconds"] = false;
    for _, cond in ipairs(resetList) do
        resetList[cond] = false;
    end

    for _, condition in ipairs(resetList) do
        if not tonumber(condition) then
            local isValid = false;
            for _, vc in pairs(validConditions) do
                if condition == vc then
                    if dupeCheck[vc] == false then
                        isValid, dupeCheck[vc] = true, true;
                    else
                        print("(TFresh) Duplicate reset condition:"..condition);
                        return false;
                    end
                end
            end
            if not isValid then
                print("(TFresh) Bad reset condition: "..condition);
                print("Lis of valid conditions: default, "..table.concat(validConditions, ", ")..", <seconds>.")
                return false;
            end
        else
            local seconds = tonumber(condition)
            if seconds == nil or seconds ~= math.floor(tonumber(condition)) or seconds < 0 then
                print("(TFresh) Bad reset condition: "..condition);
                print("Seconds must be in whole number.");
                return false;
            elseif dupeCheck["seconds"] == true then
                print("(TFresh) Duplicate reset condition:"..condition);
                return false;
            elseif seconds == 0 and resetCount > 1 then
                print("(Tfresh) 0 can't be combined, it's short-hand for no conditions.'")
                return false;
            else
                dupeCheck["seconds"] = true;
            end
        end
    end
    return true;
end

tfresh.validateAndGetParams = function(paramStr)
    if paramStr == "0" then -- shortcut for no reset condition
        return "";
    end

    a, count = string.gsub(paramStr,"%s","");

    if count > 0 then
        print("(TFresh) Bad params: /tfresh "..paramStr);
        print("Reset conditions are separated by forward-slash '/'.");
        return nil;
    end

    if not tfresh.isValidResetConditions(paramStr) then
        return nil;
    end

    return paramStr;
end