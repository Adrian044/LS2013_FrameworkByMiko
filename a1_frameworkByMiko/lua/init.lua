-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Initialization
------------------------------------------------------------*/

__CORE_VERSION__ = 1.5;

InitFramework = {};

function InitFramework:load()
	if __FRAMEWORK_BY_MIKO_INIT__ == nil then
		-- External libraries --
		source(Utils.getFilename('lua/libraries/TableSerialization'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/libraries/YaciCode12'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/libraries/utf8'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/libraries/base64'..__EXT__, g_modsDirectory..__BASE_DIR__));
		
		-- Core the application --
		source(Utils.getFilename('lua/core/basic'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/core/i18n'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/core/registry'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/core/mvc'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/core/graphicLayout'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/core/controls'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/core/template'..__EXT__, g_modsDirectory..__BASE_DIR__));
		source(Utils.getFilename('lua/core/mods'..__EXT__, g_modsDirectory..__BASE_DIR__));
		
		-- Load the mods --
		--Mods:load();		
		if Utils ~= nil then
			Utils.frameworkByMiko = {}
			Utils.frameworkByMiko.modsCapture 	= {}
			Utils.frameworkByMiko.modsModule  	= Mods;
		end;	
		
		__FRAMEWORK_BY_MIKO_INIT__ = true;
		print('framework by miko init');
	end;
end;