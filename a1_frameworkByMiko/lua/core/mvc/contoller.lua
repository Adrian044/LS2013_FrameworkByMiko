-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Controller module
------------------------------------------------------------*/

print("cotrnoller module loaded");

Controller = newclass("Controller");

function Controller:init()
	self.ModelInstances = {}
	self.ViewInstances = {}
end;

function Controller:setPrefix(value) 
	self.ControllerPrefix = value;
end;

function Controller:setSurfix(value) 
	self.ControllerSurfix = value;
end;

-- set the model
function Controller:setModel(name)
	if self.ModelInstances[name] == nil then
		source(Utils.getFilename('/app/model/'..name..__EXT__, __DIR_GAME_MOD__..self.ControllerPrefix));
		local f = assert(loadstring("return "..self.ControllerPrefix.."_Model_"..name.."()"));
		--return self:setVar('model.'..string.gsub(name, "_", "."), f());
		self.ModelInstances[name] = f();
		self.ModelInstances[name]:setPrefix(self.ControllerPrefix);
		self.ModelInstances[name]:setSurfix(name);
		self.ModelInstances[name].i18n = self.ControllerInstance.i18n;
		self.ModelInstances[name]:load();	
	end;
	return self.ModelInstances[name];
end;

-- set the view
function Controller:setView(name)
	if name == nil then 
		local index = self.ControllerSurfix;
		if self.ViewInstances[index] == nil then
			source(Utils.getFilename('/app/view/'..self.ControllerSurfix..'/default'..__EXT__, __DIR_GAME_MOD__..self.ControllerPrefix));
			local f = assert(loadstring("return "..self.ControllerPrefix.."_View_"..self.ControllerSurfix.."()"));
			self.ViewInstances[index] = f();
			self.ViewInstances[index]:setPrefix(self.ControllerPrefix);
			self.ViewInstances[index]:setSurfix(self.ControllerSurfix);
			self.ViewInstances[index]:setController(self.ControllerInstance);
			self.ViewInstances[index].i18n = self.ControllerInstance.i18n;
			self.ViewInstances[index]:load();
		end;
		return self.ViewInstances[index];
	else 
		local index = self.ControllerSurfix.."_"..name;
		if self.ViewInstances[index] == nil then
			source(Utils.getFilename('/app/view/'..self.ControllerSurfix..'/'..name..__EXT__, __DIR_GAME_MOD__..self.ControllerPrefix));
			local f = assert(loadstring("return "..self.ControllerPrefix.."_View_"..self.ControllerSurfix.."_"..name.."()"));
			self.ViewInstances[index] = f();
			self.ViewInstances[index]:setPrefix(self.ControllerPrefix);
			self.ViewInstances[index]:setSurfix(self.ControllerSurfix.."_"..name);
			self.ViewInstances[index]:setController(self.ControllerInstance);
			self.ViewInstances[index].i18n = self.ControllerInstance.i18n;
			self.ViewInstances[index]:load();
		end;
		return self.ViewInstances[index];
	end;	
end;