-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Controls Loader Module
------------------------------------------------------------*/

Controls.Progress = newclass("Controls.Progress");

-- ( float [target value] , float [increment speed], object [progressed object] ,  string [name of object field] ) --
function Controls.Progress:init(targetValue, progressSpeed, object, objectProperty)
	self.targetValue 		= targetValue;
	self.progressSpeed		= progressSpeed;
	self.object				= object;
	self.objectProperty		= objectProperty;
	self.startValue			= self.object[self.objectProperty];
	self.lastValue			= self.startValue;
	self.started			= false;
end;

function Controls.Progress:start()
	self.started = true;
	self.timer = addTimer(1, 'onTimer', self);	
end;

function Controls.Progress:stop()
	self.started = false;
	--if tonumber(self.timer) ~= nil then removeTimer(self.timer) end;
	self.timer = nil;
end;

function Controls.Progress:onTimer()
	if self.started then
		if self.targetValue>self.startValue and self.object[self.objectProperty]<self.targetValue then
			self.object[self.objectProperty] = self.object[self.objectProperty]+self.progressSpeed;
			self.timer = addTimer(1, 'onTimer', self);
		elseif self.targetValue>self.startValue and self.object[self.objectProperty]>self.targetValue then
			self.object[self.objectProperty] = self.targetValue;
		elseif self.targetValue<self.startValue and self.object[self.objectProperty]>self.targetValue then
			self.object[self.objectProperty] = self.object[self.objectProperty]-self.progressSpeed;
			self.timer = addTimer(1, 'onTimer', self);	
		elseif self.targetValue<self.startValue and self.object[self.objectProperty]<self.targetValue then
			self.object[self.objectProperty] = self.targetValue;
		end;
		self.lastValue = self.object[self.objectProperty];
	end;
end;

function Controls.Progress:setTargetValue(value)
	self.targetValue = value;
end;

function Controls.Progress:setProgressSpeed(speed)
	self.progressSpeed = speed;
end;

function Controls.Progress:getLastValue()
	return self.lastValue;
end;