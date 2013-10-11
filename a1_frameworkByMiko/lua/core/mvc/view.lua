-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- View module
------------------------------------------------------------*/

print("view module loaded");

View = newclass("View");

function View:setPrefix(value) 
	self.ViewPrefix = value;
end;

function View:setSurfix(value) 
	self.ViewSurfix = value;
end;

function View:passVar(name, value)
	if name ~= 'super' then
		self[name] = value;
	end;
end;

function View:setController(ref)
	self.ControllerInstance = ref;
end;

function View:getController()
	return self.ControllerInstance;
end;