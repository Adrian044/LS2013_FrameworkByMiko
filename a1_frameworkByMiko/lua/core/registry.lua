-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Registry module
------------------------------------------------------------*/

print("registry module loaded");

Registry = {}

Registry.entries = {}
Registry.specialKey = {
	value		= "___value___",
	['type']	= "___type___",	
	attribute	= "___attribute___",
}
Registry.attr = {
	['read']		= 0,
	['write']		= 1,
	['execute'] 	= 2
}

function Registry:set(regpath, value, attribute)
	if attribute == nil then attribute = Registry.attr.read end;
	if (regpath ~= nil and value ~= nil) then
		local p = string.explode('.', regpath);
		local r = table.reverse(p);
		local newEntry = self:setRecursive(r, table.getn(r), value, attribute);
		local oldEntry = self:get(regpath, true);
		if oldEntry == nil then 
			self.entries = table.merge(self.entries, newEntry);
		else
			if (oldEntry[self.specialKey.attribute] == self.attr.write or oldEntry[self.specialKey.attribute] == self.attr.execute) then
				self.entries = table.merge(self.entries, newEntry);
			else error("do not have permission to overwrite the key "..regpath.." ") end;
		end;
	else error('regpath or value is nil ') end;
	
	return self:get(regpath);
end;

function Registry:setRecursive(t, i, value, attribute)
	local k = {};
	if i>=0 then
		if table.find(self.specialKey, t[i]) then error("unexpected word '"..t[i].."' in variable regpath ") end;
		k[t[i]] = self:setRecursive(t, i-1, value, attribute)
		return k;
	else
		return {[self.specialKey.type]=type(value), [self.specialKey.attribute]=attribute, [self.specialKey.value]=value};
	end;
end;

function Registry:get(regpath, allKeys)
	if (regpath ~= nil) then
		local p = string.explode('.', regpath);
		local r = table.reverse(p);
		local v = self:getRecursive(r, table.getn(r), self.entries);
		if v ~= nil then
			if allKeys ~= nil then return v
			else return v[self.specialKey.value] end;
		else return nil end;
	else return nil end;
end;

function Registry:getRecursive(t, i, entries)
	if i>=0 then
		if table.find(self.specialKey, t[i]) then error("unexpected word '"..t[i].."' in variable regpath ") end;
		if entries[t[i]] ~= nil then return self:getRecursive(t, i-1, entries[t[i]])
		else return nil end;	
	else
		if entries[self.specialKey.type] ~= nil then return entries;
		else return nil end;
	end;
end;