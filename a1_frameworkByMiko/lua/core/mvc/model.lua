-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Model module
------------------------------------------------------------*/

print("model module loaded");

Model = newclass("Model");

function Model:setPrefix(value) 
	self.ModelPrefix = value;
end;

function Model:setSurfix(value) 
	self.ModelSurfix = value;
end;