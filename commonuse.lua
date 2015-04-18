function dir(obj,level)
  local s,t = '', type(obj)

  level = level or ' '

  if (t=='nil') or (t=='boolean') or (t=='number') or (t=='string') then
    s = tostring(obj)
    if t=='string' then
      s = '"' .. s .. '"'
    end
  elseif t=='function' then s='function'
  elseif t=='userdata' then
    s='userdata'
    for n,v in pairs(getmetatable(obj)) do  s = s .. " (" .. n .. "," .. dir(v) .. ")" end
  elseif t=='thread' then s='thread'
  elseif t=='table' then
    s = '\n{\n'
    for k,v in pairs(obj) do
      local k_str = '\t"' .. tostring(k) .. '"'
      --if type(k)=='string' then
        --k_str = '\t["' .. k_str .. '"]'
      --end
      s = s .. k_str .. ' : ' .. dir(v,level .. level) .. ', \n'
    end
    s = string.sub(s, 1, -3)
    s = s .. '\n}\n'
  end
  return s
end


function compareFontObject(a, b)
	local subfontmap = { 
		["regular"] = 0, ["book"]=10 ,["medium"]= 20, 
		["italic"] = 100,["mediumitalic"]=120,["oblique"]=110, 
		["bold"] = 200, ["semibold"] = 210, ["semibolditalic"] = 230,
		["bolditalic"] = 300, ["boldoblique"] = 310 
	}
	local subfontA = subfontmap[a["subfamily"]] or 100000;
	local subfontB = subfontmap[b["subfamily"]] or 100000;
	
	local prefmodifiersMap = {
		["thin"]            = -10, ["thinitalic"]           = -10,
		["extralight"]      = -5,  ["extralightitalic"]     = -5 ,
		["light"]           = 0,   ["lightitalic"]          = 0,
		["regular"]         = 5,   ["oblique"]              = 5,  ["book"]             = 5 , ["bold"]                = 5, ["boldoblique"]  = 5,
		["medium"]          = 6,   ["mediumitalic"]         = 6,
		["extrabold"]       = 7,   ["extrabolditalic"]      = 7,
		["semicondregular"] = 10,  ["semiconditalic"]       = 10, ["semicondbold"]     = 10,  ["semicondbolditalic"] = 10,
		["condensed"]       = 20,  ["condregular"]          = 20, ["condensedoblique"] = 20,  
			["condenseditalic"]     = 20, ["conditalic"]           = 20, 
			["condensedbold"]       = 20, ["condensedboldoblique"] =20, 
			["condensedbolditalic"] = 20, ["condbold"] = 20,  
			["condbolditalic"]      = 20,
		["semiexpdregular"] = 30,  ["semiexpditalic"]	    = 30, ["semiexpdbold"]     = 30,  ["semiexpdbolditalic"] = 30,  
		["expdregular"]     = 40,  ["expditalic"]           = 40 ,["expdbold"]         = 40,  ["expdbolditalic"]     = 40,
		["black"]           = 50,  ["blackitalic"]          = 50 
	}
	local prefmodifiersA = prefmodifiersMap[a["prefmodifiers"]] or prefmodifiersMap["regular"];
	local prefmodifiersB = prefmodifiersMap[b["prefmodifiers"]] or prefmodifiersMap["regular"];
	
	--print ("subfontA= " .. subfontA .. " subfontB= " .. subfontB)
	local weightA = a["weight"][1];
	local weightB = b["weight"][1];
	
--[[	
	if prefmodifiersA ~= prefmodifiersB then
		return prefmodifiersA < prefmodifiersB 
	else
		if (weightA ~= weightB) then
			return weightA < weightB;
		else
			if subfontA ~= subfontB then
				return subfontA < subfontB 
			else
				return string.lower(a.fullpath) < string.lower(b.fullpath)
			end
		end
	end
--]]if (weightA ~= weightB) then
		return weightA < weightB;
	else
		if prefmodifiersA ~= prefmodifiersB then
			return prefmodifiersA < prefmodifiersB 
		else
			if subfontA ~= subfontB then
				return subfontA < subfontB 
			else
				return string.lower(a.fullpath) < string.lower(b.fullpath)
			end
		end
	end
end

function escapeTexChar(s)
	return s:gsub("\\%",'-'):gsub("&",'-'):gsub("_","\\_")
end

