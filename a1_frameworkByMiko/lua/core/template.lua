-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Template Module
------------------------------------------------------------*/

--print("template module loaded");

-- UNDER CONSTRUCTION

Template = newclass("Template");

function Template:init(path, filename)
	self.templatePath = path..'/';
	if name == nil then self.templateFilename = 'default.xml';
	else self.templateFilename = filename..'.xml' end;
	self.tmplElements = {}
end;

function Template:load()
	local tmplFile = XML:new();
	tmplFile:open(Utils.getFilename(self.templateFilename, __DIR_GAME_MOD__..self.templatePath));
	local tmplParse = tmplFile:parser('template.layout');
	if tmplParse~=nil then
		for k,v in pairs(tmplParse) do	
			if v.label == 'window' then
				local window = {
					imagePath 		= self.templatePath..v.xarg.imagePath,
					width			= tonumber(v.xarg.width),
					height			= tonumber(v.xarg.height),	
					x_pos 			= tonumber(v.xarg.x),
					y_pos 			= tonumber(v.xarg.y),	
					center			= string.boolean(v.xarg.center),
					disableCursor	= string.boolean(v.xarg.disableCursor),
				}
				-- Create Window
				local windowId = nil;
				if v.xarg.id==nil then windowId = table.getn(self.tmplElements);
				else windowId = v.xarg.id end;
				self.tmplElements[windowId] = GraphicLayout(window);
				addModEventListener(self.tmplElements[windowId]);
			end;
		end;
	end;
end;