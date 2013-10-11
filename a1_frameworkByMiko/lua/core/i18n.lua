-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- i18n module
------------------------------------------------------------*/

print("i18n module loaded");

i18n = newclass("i18n");
i18n_ = {}

function i18n:init(path)
	self.path = path;
	self.langTag = g_languageShort;
	self.langXML = self:load();
end;

function i18n:load()
	local path = nil;
	local function fileExist(path)
		file = XML:new();
		file:open(path);
		return file:pathExist('lang');
	end;
	
	if ( fileExist(Utils.getFilename(self.langTag..".xml", __DIR_GAME_MOD__..self.path)) ) then
		path = Utils.getFilename(self.langTag..".xml", __DIR_GAME_MOD__..self.path);
	elseif ( fileExist(Utils.getFilename("en.xml", __DIR_GAME_MOD__..self.path)) ) then
		path = Utils.getFilename("en.xml", __DIR_GAME_MOD__..self.path);
	end;
	
	if path ~= nil then
		if i18n_[self.path] == nil then
			local langFile = XML:new();
			langFile:open(path);	
			i18n_[self.path] = langFile;	
		end;	
	end;
	return i18n_[self.path];
end;

function i18n:get(name) 
	if self.langXML ~= nil then 
		local value = self.langXML:getValue("lang."..name, "string");
		if value == nil then value = name end;
		return value;
	else return name end;
end;