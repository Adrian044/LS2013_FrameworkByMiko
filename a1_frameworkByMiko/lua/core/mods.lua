-------------------------------------------------------------+
-- Copyright © 2012-2013 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Mods module
------------------------------------------------------------*/

print("mods module loaded");

--[[ Moduł obsługi modyfikacji --]]
Mods = {};
Mods.list = {}

-- wczytywanie modów
function Mods:load()
	--[[modListFile = XML:new();
	modListFile:open(Utils.getFilename('mod-list.xml', __DIR_GAME_MOD__));
	for k,v in pairs(modListFile:parser('list')) do	--]]
	for k,v in pairs(Utils.frameworkByMiko.modsCapture) do
		--[[local name = v.xarg.name;
		local enable = v.xarg.enable;--]]
		local name 		= v.name;
		local enable 	= v.enable;
		local events 	= v.events;
		
		if enable then
			source(Utils.getFilename('/app/'..name..__EXT__, __DIR_GAME_MOD__..name));
			local f = assert(loadstring("return "..name.."_Mod('"..name.."')"));
			self.list[name] = f(name);
			self.list[name].modName = name;
				
			-- plik z informacjami o modzie
			local modInfo = XML:new();
			modInfo:open(Utils.getFilename('/mod_info.xml', __DIR_GAME_MOD__..name));
			Mods:setRegistry(name, 'mod_info', modInfo);
			self.list[name].modInfo = modInfo;								
			
			local requiredCore = modInfo:getValue('info.requiredCore', 'float');
			if (requiredCore ~= nil and requiredCore<=__CORE_VERSION__) then
				-- plik konfiguracyjny
				local config = XML:new();
				config:open(Utils.getFilename('/config.xml', __DIR_GAME_MOD__..name));
				Mods:setRegistry(name, 'config', config);
				self.list[name].Config = config;
					
				-- plik z klawiszami
				local inputXml = XML:new();
				inputXml:open(Utils.getFilename('/input.xml', __DIR_GAME_MOD__..name));	
				local input = ModInput(inputXml);
				Mods:setRegistry(name, 'input', input);
				self.list[name].input = input;
				
				-- tablica z eventami
				Mods:setRegistry(name, 'events', events);
				self.list[name].events = events;
				
				-- ładowanie modyfikacji
				self.list[name]:load();
				print('Mod '..name..' Loaded');
			else
				print('Warning: '..name..' Mod required '..modInfo:getValue('info.requiredCore', 'string')..' core version');
			end;
		end;
		
		v = nil; -- usuwanie z listy przechwytywanych modów
	end;
end;

-- Get the mod
function Mods:get(name)
	return self.list[name];
end;

-- Set var to registry
function Mods:setRegistry(modName, key, value, attribute)
	if attribute == nil then return Registry:set('Mods.'..modName..'.'..key, value) 
	else Registry:set('Mods.'..modName..'.'..key, value, attribute) end;
end;

-- Get var from registry
function Mods:getRegistry(modName, key)
	return Registry:get('Mods.'..modName..'.'..key);	
end;



-- [[ moduł przechwytujący listę modów do załadowania --]]
ModsCapture = {}

function ModsCapture:load()	
end;

function ModsCapture:loadMap(name)	
	if Utils ~= nil and Utils.frameworkByMiko ~= nil then 
		if type(Utils.frameworkByMiko.modsCapture) == 'table' then
			if table.getn(Utils.frameworkByMiko.modsCapture)>0 then
				Mods:load();
			end;
		end;
	end;	
end;

function ModsCapture:deleteMap()	
end;

function ModsCapture:mouseEvent(posX, posY, isDown, isUp, button)
end;

function ModsCapture:keyEvent(unicode, sym, modifier, isDown)
end;

function ModsCapture:update(dt)
end;

function ModsCapture:draw()
end;

addModEventListener(ModsCapture);




--[[ Obsługa klawiszy w modach --]]
print("mods input module loaded");

ModInput = newclass("ModInput");
ModInputGlobal = {}
ModInputGlobal["SpecialKeys"] = {
      [1] = {
         ["input"] = "KEY_tab";
         ["sym"] = 9;
         ["name"] = "Tab";
         ["unicode"] = 9;
      };
      [2] = {
         ["input"] = "KEY_return";
         ["sym"] = 13;
         ["name"] = "Enter";
         ["unicode"] = 13;
      };
      [3] = {
         ["input"] = "KEY_space";
         ["sym"] = 32;
         ["name"] = "Space";
         ["unicode"] = 32;
      };
      [4] = {
         ["input"] = "KEY_delete";
         ["sym"] = 127;
         ["name"] = "Delete";
         ["unicode"] = 0;
      };
      [5] = {
         ["input"] = "KEY_esc";
         ["sym"] = 27;
         ["name"] = "Escape";
         ["unicode"] = 27;
      };
      [6] = {
         ["input"] = "KEY_backspace";
         ["sym"] = 8;
         ["name"] = "Backspace";
         ["unicode"] = 8;
      };
      [7] = {
         ["input"] = "KEY_KP_0";
         ["sym"] = 256;
         ["name"] = "NumPad 0";
         ["unicode"] = 0;
      };
      [8] = {
         ["input"] = "KEY_KP_1";
         ["sym"] = 257;
         ["name"] = "NumPad 1";
         ["unicode"] = 0;
      };
      [9] = {
         ["input"] = "KEY_KP_2";
         ["sym"] = 258;
         ["name"] = "NumPad 2";
         ["unicode"] = 0;
      };
      [10] = {
         ["input"] = "KEY_KP_3";
         ["sym"] = 259;
         ["name"] = "NumPad 3";
         ["unicode"] = 0;
      };
      [11] = {
         ["input"] = "KEY_KP_4";
         ["sym"] = 260;
         ["name"] = "NumPad 4";
         ["unicode"] = 0;
      };
      [12] = {
         ["input"] = "KEY_KP_5";
         ["sym"] = 261;
         ["name"] = "NumPad 5";
         ["unicode"] = 0;
      };
      [13] = {
         ["input"] = "KEY_KP_6";
         ["sym"] = 262;
         ["name"] = "NumPad 6";
         ["unicode"] = 0;
      };
      [14] = {
         ["input"] = "KEY_KP_7";
         ["sym"] = 263;
         ["name"] = "NumPad 7";
         ["unicode"] = 0;
      };
      [15] = {
         ["input"] = "KEY_KP_8";
         ["sym"] = 264;
         ["name"] = "NumPad 8";
         ["unicode"] = 0;
      };
      [16] = {
         ["input"] = "KEY_KP_9";
         ["sym"] = 265;
         ["name"] = "NumPad 9";
         ["unicode"] = 0;
      };
      [17] = {
         ["input"] = "KEY_KP_period";
         ["sym"] = 266;
         ["name"] = "NumPad .";
         ["unicode"] = 0;
      };
      [18] = {
         ["input"] = "KEY_KP_minus";
         ["sym"] = 269;
         ["name"] = "NumPad -";
         ["unicode"] = 45;
      };
      [19] = {
         ["input"] = "KEY_KP_plus";
         ["sym"] = 270;
         ["name"] = "NumPad +";
         ["unicode"] = 43;
      };
      [20] = {
         ["input"] = "KEY_up";
         ["sym"] = 273;
         ["name"] = "Up";
         ["unicode"] = 0;
      };
      [21] = {
         ["input"] = "KEY_down";
         ["sym"] = 274;
         ["name"] = "Down";
         ["unicode"] = 0;
      };
      [22] = {
         ["input"] = "KEY_right";
         ["sym"] = 275;
         ["name"] = "Right";
         ["unicode"] = 0;
      };
      [23] = {
         ["input"] = "KEY_left";
         ["sym"] = 276;
         ["name"] = "Left";
         ["unicode"] = 0;
      };
      [24] = {
         ["input"] = "KEY_insert";
         ["sym"] = 277;
         ["name"] = "Insert";
         ["unicode"] = 0;
      };
      [25] = {
         ["input"] = "KEY_home";
         ["sym"] = 278;
         ["name"] = "Home";
         ["unicode"] = 0;
      };
      [26] = {
         ["input"] = "KEY_end";
         ["sym"] = 279;
         ["name"] = "End";
         ["unicode"] = 0;
      };
      [27] = {
         ["input"] = "KEY_pageup";
         ["sym"] = 280;
         ["name"] = "Page Up";
         ["unicode"] = 0;
      };
      [28] = {
         ["input"] = "KEY_pagedown";
         ["sym"] = 281;
         ["name"] = "Page Down";
         ["unicode"] = 0;
      };
      [29] = {
         ["input"] = "KEY_f1";
         ["sym"] = 282;
         ["name"] = "F1";
         ["unicode"] = 0;
      };
      [30] = {
         ["input"] = "KEY_f2";
         ["sym"] = 283;
         ["name"] = "F2";
         ["unicode"] = 0;
      };
      [31] = {
         ["input"] = "KEY_f3";
         ["sym"] = 284;
         ["name"] = "F3";
         ["unicode"] = 0;
      };
      [32] = {
         ["input"] = "KEY_f4";
         ["sym"] = 285;
         ["name"] = "F4";
         ["unicode"] = 0;
      };
      [33] = {
         ["input"] = "KEY_f5";
         ["sym"] = 286;
         ["name"] = "F5";
         ["unicode"] = 0;
      };
      [34] = {
         ["input"] = "KEY_f6";
         ["sym"] = 287;
         ["name"] = "F6";
         ["unicode"] = 0;
      };
      [35] = {
         ["input"] = "KEY_f7";
         ["sym"] = 288;
         ["name"] = "F7";
         ["unicode"] = 0;
      };
      [36] = {
         ["input"] = "KEY_f8";
         ["sym"] = 289;
         ["name"] = "F8";
         ["unicode"] = 0;
      };
      [37] = {
         ["input"] = "KEY_f9";
         ["sym"] = 290;
         ["name"] = "F9";
         ["unicode"] = 0;
      };
      [38] = {
         ["input"] = "KEY_f10";
         ["sym"] = 291;
         ["name"] = "F10";
         ["unicode"] = 0;
      };
      [39] = {
         ["input"] = "KEY_f11";
         ["sym"] = 292;
         ["name"] = "F11";
         ["unicode"] = 0;
      };
      [40] = {
         ["input"] = "KEY_f12";
         ["sym"] = 293;
         ["name"] = "F12";
         ["unicode"] = 0;
      };
      [41] = {
         ["input"] = "KEY_rshift";
         ["sym"] = 303;
         ["name"] = "Right Shift";
         ["unicode"] = 0;
      };
      [42] = {
         ["input"] = "KEY_lshift";
         ["sym"] = 304;
         ["name"] = "Left Shift";
         ["unicode"] = 0;
      };
      [43] = {
         ["input"] = "KEY_rctrl";
         ["sym"] = 305;
         ["name"] = "Right Ctrl";
         ["unicode"] = 0;
      };
      [44] = {
         ["input"] = "KEY_lctrl";
         ["sym"] = 306;
         ["name"] = "Left Ctrl";
         ["unicode"] = 0;
      };
      [45] = {
         ["input"] = "KEY_ralt";
         ["sym"] = 307;
         ["name"] = "Right Alt";
         ["unicode"] = 0;
      };
      [46] = {
         ["input"] = "KEY_lalt";
         ["sym"] = 308;
         ["name"] = "Left Alt";
         ["unicode"] = 0;
      };
      [47] = {
         ["input"] = "MOUSE_BUTTON_LEFT";
         ["mouseButton"] = 1;
         ["name"] = "Left Button";
      };
      [48] = {
         ["input"] = "MOUSE_BUTTON_MIDDLE";
         ["mouseButton"] = 2;
         ["name"] = "Middle Button";
      };
      [49] = {
         ["input"] = "MOUSE_BUTTON_RIGHT";
         ["mouseButton"] = 3;
         ["name"] = "Right Button";
      };
      [50] = {
         ["input"] = "MOUSE_BUTTON_WHEEL_UP";
         ["mouseButton"] = 4;
         ["name"] = "Wheel Up";
      };
      [51] = {
         ["input"] = "MOUSE_BUTTON_WHEEL_DOWN";
         ["mouseButton"] = 5;
         ["name"] = "Wheel Down";
      };
      [52] = {
         ["input"] = "KEY_dollar";
         ["sym"] = 92;
         ["name"] = "$";
         ["unicode"] = 36;
      };
      [53] = {
         ["input"] = "KEY_ampersand";
         ["sym"] = 0;
         ["name"] = "&";
         ["unicode"] = 38;
      };
      [54] = {
         ["input"] = "KEY_quote";
         ["sym"] = 45;
         ["name"] = "'";
         ["unicode"] = 39;
      };
      [55] = {
         ["input"] = "KEY_leftparen";
         ["sym"] = 0;
         ["name"] = "(";
         ["unicode"] = 40;
      };
      [56] = {
         ["input"] = "KEY_rightparen";
         ["sym"] = 0;
         ["name"] = ")";
         ["unicode"] = 41;
      };
      [57] = {
         ["input"] = "KEY_asterisk";
         ["sym"] = 0;
         ["name"] = "*";
         ["unicode"] = 42;
      };
      [58] = {
         ["input"] = "KEY_plus";
         ["sym"] = 0;
         ["name"] = "+";
         ["unicode"] = 43;
      };
      [59] = {
         ["input"] = "KEY_comma";
         ["sym"] = 44;
         ["name"] = ",";
         ["unicode"] = 44;
      };
      [60] = {
         ["input"] = "KEY_minus";
         ["sym"] = 47;
         ["name"] = "-";
         ["unicode"] = 45;
      };
      [61] = {
         ["input"] = "KEY_period";
         ["sym"] = 46;
         ["name"] = ".";
         ["unicode"] = 46;
      };
      [62] = {
         ["input"] = "KEY_slash";
         ["sym"] = 0;
         ["name"] = "/";
         ["unicode"] = 47;
      };
      [63] = {
         ["input"] = "KEY_colon";
         ["sym"] = 0;
         ["name"] = ":";
         ["unicode"] = 58;
      };
      [64] = {
         ["input"] = "KEY_semicolon";
         ["sym"] = 59;
         ["name"] = ";";
         ["unicode"] = 246;
      };
      [65] = {
         ["input"] = "KEY_less";
         ["sym"] = 60;
         ["name"] = "<";
         ["unicode"] = 60;
      };
      [66] = {
         ["input"] = "KEY_equals";
         ["sym"] = 0;
         ["name"] = "=";
         ["unicode"] = 61;
      };
      [67] = {
         ["input"] = "KEY_greater";
         ["sym"] = 0;
         ["name"] = ">";
         ["unicode"] = 62;
      };
      [68] = {
         ["input"] = "KEY_greater";
         ["sym"] = 0;
         ["name"] = "?";
         ["unicode"] = 63;
      };
      [69] = {
         ["input"] = "KEY_at";
         ["sym"] = 0;
         ["name"] = "@";
         ["unicode"] = 64;
      };
      [70] = {
         ["input"] = "KEY_leftbracket";
         ["sym"] = 91;
         ["name"] = "[";
         ["unicode"] = 252;
      };
      [71] = {
         ["input"] = "KEY_backslash";
         ["sym"] = 0;
         ["name"] = "\\";
         ["unicode"] = 92;
      };
      [72] = {
         ["input"] = "KEY_rightbracket";
         ["sym"] = 93;
         ["name"] = "]";
         ["unicode"] = 168;
      };
      [73] = {
         ["input"] = "KEY_caret";
         ["sym"] = 61;
         ["name"] = "^";
         ["unicode"] = 94;
      };
      [74] = {
         ["input"] = "KEY_underscore";
         ["sym"] = 0;
         ["name"] = "_";
         ["unicode"] = 95;
      };
      [75] = {
         ["input"] = "KEY_backquote";
         ["sym"] = 39;
         ["name"] = "`";
         ["unicode"] = 228;
      };
      [76] = {
         ["input"] = "KEY_KP_divide";
         ["sym"] = 267;
         ["name"] = "NumPad %";
         ["unicode"] = 47;
      };
      [77] = {
         ["input"] = "KEY_KP_multiply";
         ["sym"] = 268;
         ["name"] = "NumPad *";
         ["unicode"] = 42;
      };
      [78] = {
         ["input"] = "KEY_KP_equals";
         ["sym"] = 272;
         ["name"] = "NumPad =";
         ["unicode"] = 0;
      };
      [79] = {
         ["input"] = "KEY_KP_enter";
         ["sym"] = 271;
         ["name"] = "NumPad Enter";
         ["unicode"] = 13;
      };
      [80] = {
         ["input"] = "KEY_scrolllock";
         ["sym"] = 302;
         ["name"] = "Scroll Lock";
         ["unicode"] = 0;
      };
      [81] = {
         ["input"] = "KEY_lwin";
         ["sym"] = 311;
         ["name"] = "Left Win";
         ["unicode"] = 0;
      };
      [82] = {
         ["input"] = "KEY_rwin";
         ["sym"] = 312;
         ["name"] = "Right Win";
         ["unicode"] = 0;
      };
      [83] = {
         ["input"] = "KEY_menu";
         ["sym"] = 319;
         ["name"] = "Menu";
         ["unicode"] = 0;
      };
      [84] = {
         ["input"] = "KEY_print";
         ["sym"] = 316;
         ["name"] = "Print";
         ["unicode"] = 0;
      };
   };

function ModInput:init(inputXml)
	self.inputXml = inputXml;
	self.inputAction = {}
	self.inputActionKeyName = {}
	addModEventListener(self);	
end;

function ModInput:getAction(name, pressed)
	if self.inputAction[name] == nil then
		local key = self.inputXml:getValue(name..'#key', "string");
		local button = self.inputXml:getValue(name..'#button', "string");
		if key~=nil or button~=nil then
			self.inputAction[name] = {}
			self.inputAction[name].key 				= false;
			self.inputAction[name].button 			= false;
			self.inputAction[name].buttonPressed 	= false;
		end;
	end;
	
	if self.inputAction[name].key or self.inputAction[name].button then 
		if not pressed then 
			self.inputAction[name].key 				= false;
			self.inputAction[name].button 			= false;
			self.inputAction[name].buttonPressed 	= false;
		else
			self.inputAction[name].buttonPressed 	= true;
		end;
		return true;
	else return false end;
end;

function ModInput:getKeyName(sym)
	sym = tonumber(sym);
	local name = '';
	for k,v in pairs(ModInputGlobal.SpecialKeys) do
		if v.sym == sym then 
			name = v.name;
			break;
		end;
	end;
	if name == '' then name = string.char(sym) end;
	return name;
end;

function ModInput:getActionKeyName(name)
	if self.inputActionKeyName[name] == nil then
		local key = self.inputXml:getValue(name..'#key', "string");
		key = string.explode(' ', key);
		-- Converted string key to integer
		for k3,v3 in pairs(key) do
			if tonumber(v3) == nil then 
				key[k3] = Input[v3];
			end;
		end;		
		local keyName = '';
		for k,v in pairs(key) do
			if table.getn(key) == k then
				keyName = keyName..self:getKeyName(v);
			else
				keyName = keyName..self:getKeyName(v)..' + ';
			end;
		end;
		self.inputActionKeyName[name] = keyName;
	end;
	return self.inputActionKeyName[name];
end;

function ModInput:loadMap(name)
end;

function ModInput:deleteMap()	
end;

function ModInput:mouseEvent(posX, posY, isDown, isUp, button)
end;

function ModInput:keyEvent(unicode, sym, modifier, isDown)
	--renderText(0.2, 0.2, 0.04, tostring(sym));
	for k,v in pairs(self.inputAction) do
		local key = self.inputXml:getValue(k..'#key', "string");
		key = string.explode(' ', key);
		-- Converted string key to integer
		for k3,v3 in pairs(key) do
			if tonumber(v3) == nil then 
				key[k3] = Input[v3];
			end;
		end;
		if table.getn(key)>0 then
			if table.getn(key)==1 then
				if isDown and sym == tonumber(key[1]) then v.key = true
				else v.key = false end;			
			else 
				for k2,v2 in pairs(key) do
					if table.getn(key) ~= k2 then
						if not Input.isKeyPressed(tonumber(v2)) then break end;
					end;
					if table.getn(key) == k2 then
						if isDown and sym == tonumber(v2) then v.key = true
						else v.key = false end;							
					end;
				end;
			end;
		end;		
	end;
end;

function ModInput:update(dt)
	for k,v in pairs(self.inputAction) do
		local button = self.inputXml:getValue(k..'#button', "string");	
		if button ~= '' then
			if not v.buttonPressed then 
				if InputBinding.hasEvent(InputBinding[button]) then v.button = true
				else v.button = false end;
			else
				if InputBinding.isPressed(InputBinding[button]) then v.button = true
				else v.button = false end;
			end;
		end;
	end;
end;

function ModInput:draw()
end;