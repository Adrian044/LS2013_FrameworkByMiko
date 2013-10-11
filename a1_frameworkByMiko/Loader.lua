-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko 
-- Loader
------------------------------------------------------------*/

local function explode(div,str)
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

local folder = explode('/', string.gsub(g_currentModDirectory, '\\', '/'));
local modDir = folder[table.getn(folder)];
if modDir == nil or modDir == '' then modDir = folder[table.getn(folder)-1] end;

__BASE_DIR__ = '/'..modDir..'/';
__EXT__	= '.lua';

source(Utils.getFilename("lua/init"..__EXT__, g_modsDirectory..__BASE_DIR__));
InitFramework:load();