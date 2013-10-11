-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- MVC module
------------------------------------------------------------*/

print("mvc module loaded");

MVC = newclass("MVC");
MVC_ = {}
MVC_.instances = {}
Registry:set('mvc', MVC_.instances);

function MVC:init()
end;

-- Return instance of MVC
function MVC_:getInstance(prefix, ControllerName)
	local index = prefix.."_"..ControllerName;
	if self.instances[index] == nil then
		self.instances[index] = MVC();
		self.instances[index]:setPrefix(prefix);
		self.instances[index]:setControllerName(ControllerName);
		self.instances[index]:initController();
	end;
	return self.instances[index];
end;

function  MVC:setPrefix(value) 
	self.prefix = value;
end;

function  MVC:setControllerName(value) 
	self.ControllerName = value;
end;

-- controller initialization
function MVC:initController() 
	source(Utils.getFilename('/app/controller/'..self.ControllerName..__EXT__, __DIR_GAME_MOD__..self.prefix));
	local f = assert(loadstring("return "..self.prefix.."_Controller_"..self.ControllerName.."()"));
	self.ControllerInstance = f();
	self.ControllerInstance:setPrefix(self.prefix);
	self.ControllerInstance:setSurfix(self.ControllerName);
	self.ControllerInstance.super.ControllerInstance = self.ControllerInstance;
	self.ControllerInstance.i18n = i18n(self.prefix..'/app/i18n/');
	self.ControllerInstance:load();
	return self.ControllerInstance;
end;

-- return controller instance
function MVC:getController()
	return self.ControllerInstance;
end;


source(Utils.getFilename('lua/core/mvc/model'..__EXT__, __DIR_MOD__));
source(Utils.getFilename('lua/core/mvc/view'..__EXT__, __DIR_MOD__));
source(Utils.getFilename('lua/core/mvc/contoller'..__EXT__, __DIR_MOD__));