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
	local subfontmap = { ["regular"] = 0, ["italic"] = 1, ["bold"] = 2, ["bolditalic"] = 3 }
	local subfontA = subfontmap[a["subfamily"]] or 100000;
	local subfontB = subfontmap[b["subfamily"]] or 100000;
	--print ("subfontA= " .. subfontA .. " subfontB= " .. subfontB)

	if (subfontA ~= subfontB) then
		return subfontA < subfontB ;
	else
		local weightA = a["weight"][1];
		local weightB = b["weight"][1];
		return weightA < weightB;
	end
end

function escapeTexChar(s)
	return s:gsub("\\%",'-'):gsub("&",'-'):gsub("_","\\_")
end

