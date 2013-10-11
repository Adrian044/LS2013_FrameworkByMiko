-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Basic Module
------------------------------------------------------------*/

print("basic module loaded");

--__DIR_MOD__ 		= g_modsDirectory..__BASE_DIR__;
__DIR_MOD__ 		= g_currentModDirectory;
__DIR_GAME__ 		= getAppBasePath();
__DIR_USER__ 		= getUserProfileAppPath();
__DIR_MODS__ 		= g_modsDirectory;
__DIR_GAME_MOD__ 	= __DIR_MODS__..'/';


-- Create directory --
function createDir(dirname)
	createFolder(dirname);
end;

-- Open the text file --
function openFile(name)
	local xmlFile = XML:new();
	xmlFile:open(name);
	return xmlFile:getValue("file.text", "string");
end;

-- Save the text file --
-- ( string [name of file] , string [text of file] ) --

--[[ Example
saveFile("test.txt", "lorem ipsum");
renderText(0.10, 0.30, 0.04, openFile("test/test.txt"));--]]
function saveFile(name, text)
	local xmlFile = XML:new();
	xmlFile:create(name, "file");
	xmlFile:setValue("file.text", text, "string");
	xmlFile:save();
end;


-- XML Operations --
		
--[[ Example
xmlFile = XML:new();
xmlFile:open("modDesc.xml");
renderText(0.10, 0.10, 0.4, xmlFile:getValue("modDesc#descVersion", "string"));

xmlFile:create("test.xml", "Root");
xmlFile:setValue("Root.item1.subitem", "value1", "string");
xmlFile:setValue("Root.item2", 300, "integer");
xmlFile:setValue("Root.item3", true, "boolean");
xmlFile:save();--]]

XML = {
	filename=nil, 
	xmlFile=nil
}

-- Constructor --
function XML:new (o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end;

-- Open the XML file --
function XML:open(name)
	self.filename =  name;
	self.xmlFile = loadXMLFile("xmlDocument", self.filename);
end;

-- Save the XML file --
function XML:save()
	saveXMLFile(self.xmlFile);
end;

-- Create the XML document --
function XML:create(name, rootNode)
	self.filename =  name;
	self.xmlFile = createXMLFile("xmlDocument", self.filename, rootNode);
end;

-- Get value or atribute of XML node --
function XML:getValue(attributePath, variableType)
	if variableType=="string" then return getXMLString(self.xmlFile, attributePath) 
	elseif variableType=="integer" then return getXMLInt(self.xmlFile, attributePath)
	elseif variableType=="float" then return getXMLFloat(self.xmlFile, attributePath)
	elseif variableType=="boolean" then return getXMLBool(self.xmlFile, attributePath) end;	
end;

-- Set value or atribute of XML node --
function XML:setValue(attributePath, value, variableType)
	if variableType=="string" then return setXMLString(self.xmlFile, attributePath, value) 
	elseif variableType=="integer" then return setXMLInt(self.xmlFile, attributePath, value)
	elseif variableType=="float" then return setXMLFloat(self.xmlFile, attributePath, value)
	elseif variableType=="boolean" then return setXMLBool(self.xmlFile, attributePath, value) end;	
end;

-- Check if value exist
function XML:pathExist(attributePath)
	return  hasXMLProperty(self.xmlFile, attributePath);
end;

-- http://lua-users.org/wiki/LuaXml
-- XML Parser Functions
-- author: Roberto Ierusalimschy 
local function parseargs(s)
  local arg = {}
  string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
  end)
  return arg
end
    
local function collect(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[#stack].label)
  end
  return stack[1]
end

-- XML Parser --
function XML:parser(path)
	local str = self:getValue(path, 'string');
	if str ~= '' and str ~= nil then
		return collect(str);
	end;
end;




-- function returns the value if not nil, or default value
local function setValue(value, default, compare)
	if value ~= compare then return value
	else return default end;
end;

-- based php explode
function string.explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

-- check if the string is not empty
function string.empty(value)
	if type(value) == 'string' then
		if string.len(value) > 0 then	
			return false;
		else return true end;
	else return true end;
end;

-- convert string to boolean
function string.boolean(value)
	if type(value) == 'string' then
		if string.lower(value)=='true' then return true;
		elseif string.lower(value)=='false' then return false;
		else return false end;
	else return false end;
end;




-- Table functions
-- reversing the table or array
-- only for indexed tables!
function table.reverse ( tab )
    local size = table.getn(tab);
    local newTable = {}
     
    for i,v in ipairs ( tab ) do
       newTable[size-i] = v
    end
     
    return newTable
end

-- merge table
function table.merge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
                if type(t1[k] or false) == "table" then
                        table.merge(t1[k] or {}, t2[k] or {})
                else
                        t1[k] = v
                end
        else
                t1[k] = v
        end
    end
    return t1
end

-- search in table
FIND_NOCASE = 0
FIND_PATTERN = 1
FIND_PATTERN_NOCASE = 2
 
-- Function by Colandus 
function table.find(t, v, c)
    if type(t) == "table" and v then 
        v = (c==0 or c==2) and v:lower() or v 
        for k, val in pairs(t) do 
            val = (c==0 or c==2) and val:lower() or val
            if (c==1 or c==2) and val:find(v) or v == val then 
                return k
            end 
        end 
    end 
    return false 
end