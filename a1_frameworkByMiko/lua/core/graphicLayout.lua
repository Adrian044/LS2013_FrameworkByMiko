-------------------------------------------------------------+
-- Copyright © 2012 Rafał Mikołajun (MIKO) | rafal@mikoweb.pl
-- license: GNU General Public License version 3 or later; see LICENSE.txt
-- Inspired FsIX - Farming Shop Inventory Fixer by Decker
--
-- www.mikoweb.pl
-- www.swiat-ls.pl
--
-- LS 2013 Framework by Miko
-- Graphic layout module
------------------------------------------------------------*/

print("graphic layout module loaded");

GraphicLayoutGlobal = {}
GraphicLayoutGlobal.windowInstance = {}

function GraphicLayoutGlobal:hideAllCursorWindow()
	for k,v in pairs(GraphicLayoutGlobal.windowInstance) do
		if not v.Window.disableCursor then v:hide(); end;
	end;
end;

-- Text schemes
TextSchemes = {
	button = {
		color 			= {0.156, 0.235, 0.074, 1.0},
		colorShadow		= {0.788, 0.823, 0.768, 1.0},
		size			= 0.024
	},
	textInput = {
		color 			= {0.0, 0.0, 0.0, 1.0},
		colorShadow		= nil,
		size			= 0.024		
	}
}

-- Button definitions
Buttons = {
	default = {
		normal		= "dataS2/menu/button_normal.png",
		pressed		= "dataS2/menu/button_pressed.png",
		focused		= "dataS2/menu/button_focused.png",
		width 	= 0.170,
		height  = 0.060,
		text	= TextSchemes.button
	},
	large = {
		normal		= "dataS2/menu/button_large_normal.png",
		pressed		= "dataS2/menu/button_large_pressed.png",
		focused		= "dataS2/menu/button_large_focused.png",
		width 	= 0.240,
		height  = 0.060,
		text	= TextSchemes.button
	},	
	xlarge = {
		normal		= "dataS2/menu/button_xlarge_normal.png",
		pressed		= "dataS2/menu/button_xlarge_pressed.png",
		focused		= "dataS2/menu/button_xlarge_focused.png",
		width 	= 0.340,
		height  = 0.060,
		text	= TextSchemes.button
	},		
	up = {
		normal		= "dataS2/menu/button_up_normal.png",
		pressed		= "dataS2/menu/button_up_pressed.png",
		focused		= "dataS2/menu/button_up_focused.png",
		width 	= 0.170,
		height  = 0.060,
		text	= TextSchemes.button
	},
	down = {
		normal		= "dataS2/menu/button_down_normal.png",
		pressed		= "dataS2/menu/button_down_pressed.png",
		focused		= "dataS2/menu/button_down_focused.png",
		width 	= 0.170,
		height  = 0.060,
		text	= TextSchemes.button
	},
	left = {
		normal		= "dataS2/menu/button_left_normal.png",
		pressed		= "dataS2/menu/button_left_pressed.png",
		focused		= "dataS2/menu/button_left_focused.png",
		width 	= 0.170,
		height  = 0.060,
		text	= TextSchemes.button
	},
	right = {
		normal		= "dataS2/menu/button_right_normal.png",
		pressed		= "dataS2/menu/button_right_pressed.png",
		focused		= "dataS2/menu/button_right_focused.png",
		width 	= 0.170,
		height  = 0.060,
		text	= TextSchemes.button
	}	
}
btn = Buttons

-- Text Input definitions
TextInputs = {
	default = {
		normal		= "dataS2/menu/text_input_bg_normal.png",
		pressed		= "dataS2/menu/text_input_bg_pressed.png",
		focused		= "dataS2/menu/text_input_bg_focused.png",
		width 	= 0.340,
		height  = 0.060,
		text	= TextSchemes.textInput
	}
}
txtInput = TextInputs;

-- Backgrounds definitions
Backgrounds = {
	dialog 		= 'dataS2/menu/dialog_bg.png';
	classic 	= 'dataS2/menu/slot_normal.png';
}



-- Render shading text
function renderTextWithShade(x,y, textSize, text, color, colorShadow)
	if type(colorShadow) ~= 'table' then 
		setTextColor(0.0, 0.0, 0.0, 1.0);   -- black
		renderText(x, y - (textSize/10), textSize, text);
	else
		setTextColor(colorShadow[1], colorShadow[2], colorShadow[3], colorShadow[4]);
		renderText(x, y - (textSize/10), textSize, text);	
	end;
	if type(color) ~= 'table' then 
		setTextColor(1.0, 1.0, 1.0, 1.0);   -- white
		renderText(x, y, textSize, text);
	else 
		setTextColor(color[1], color[2], color[3], color[4]);
		renderText(x, y, textSize, text);
	end;	
end;

-- Set text to default config
function setTextToDefault()
	setTextAlignment(RenderText.ALIGN_LEFT);
	setTextColor(1.0, 1.0, 1.0, 1.0);
	setTextWrapWidth(1.0);	
	setTextBold(false);	
end;

function cutTextByHeight(fontSize, text, height)
	local i = string.len(text);
	while i > 0 do
		if getTextHeight(fontSize, string.sub(text, 0, i)) <= height then return string.sub(text, 0, i) end;
		i=i-1;
    end;	
end;


-- Graphic Layout Class
GraphicLayout = newclass("GraphicLayout");

-- Constructor --
function GraphicLayout:init(window)
	self.MouseButton_Left          = 0x01;
	self.MouseButton_Right         = 0x02;
	self.MouseButton_Middle        = 0x04;
	self.MouseButton_ScrollUp      = 0x08;
	self.MouseButton_ScrollDown    = 0x10;
	self.MouseButton_Scroll        = bitOR(self.MouseButton_ScrollUp, self.MouseButton_ScrollDown);
		
	self.scale 		= 1.0;
	self.offsetX 	= 0.0;
	self.offsetY 	= 0.0;		
		
	self.Window = {
		wrap			= nil,
		imagePath 		= nil,
		width			= 0.0,
		height			= 0.0,
		x_pos 			= 0.0,
		y_pos 			= 0.0,
		center			= false,
		disableCursor	= false,
	};
	if window ~= nil then
		for k,v in pairs(window) do self.Window[k] = v end;
	end;
	if self.Window.imagePath == 'dialog' then self.Window.wrap = createImageOverlay(Backgrounds.dialog);
	elseif self.Window.imagePath == 'classic' then self.Window.wrap = createImageOverlay(Backgrounds.classic);
	elseif self.Window.imagePath ~= nil then self.Window.wrap = createImageOverlay(__DIR_GAME_MOD__..self.Window.imagePath) end;
	if self.Window.center then self:WindowCenter() end;
	
	self.visible 			= false;
	self.overlayButtons 	= {};
	self.overlayTextInputs 	= {};
	self.overlayCaptions	= {};
	self.overlayImages	= {};
	
	table.insert(GraphicLayoutGlobal.windowInstance, self);
end

-- Render the layout --
function GraphicLayout:render()
	if self.visible then
		-- Render Window
		renderOverlay(self.Window.wrap, self:sox(self.Window.x_pos), self:soy(self.Window.y_pos), self:s(self.Window.width), self:s(self.Window.height));
		-- Render Buttons
		self:renderButtons();
		-- Render Text Inputs
		self:renderTextInputs();
		-- Render Captions
		self:renderCaptions();
		-- Render Images
		self:renderImages();
		-- Display cursor
		if not self.Window.disableCursor then 
			InputBinding.setShowMouseCursor(true);
			--g_currentMission.player.isEntered = false;
		end;
	end;
end;

-- Showing the layout --
function GraphicLayout:show()
	if not self.visible then
		if not self.Window.disableCursor then GraphicLayoutGlobal:hideAllCursorWindow() end;
		self.visible = true;
		-- Display cursor
		if not self.Window.disableCursor then
			InputBinding.setShowMouseCursor(true);
			--g_currentMission.player.isEntered = false;
		end;
	end;
end;

-- Hidding the layout --
function GraphicLayout:hide()
	if self.visible then
		self.visible = false;
		-- Hide cursor
		if not self.Window.disableCursor then
			InputBinding.setShowMouseCursor(false);
			--g_currentMission.player.isEntered = true;
		end;
	end;
end;



-- Scale
function GraphicLayout:s(z)
    return z * self.scale;
end;
-- Scale & Offset X
function GraphicLayout:sox(x)
    return self:s(x)+self.offsetX;
end;
-- Scale & Offset Y
function GraphicLayout:soy(y)
    return self:s(y)+self.offsetY;
end;    

-- Relative positioning
function GraphicLayout:relative_x(x)
	return self:sox(self.Window.x_pos+x);
end;

function GraphicLayout:relative_y(y, height)
	return self:soy(self.Window.y_pos+self.Window.height-y-height);
end;




-- Centering the window
function GraphicLayout:WindowCenter()
	self.Window.x_pos = (1.0-self:s(self.Window.width))*0.5;
	self.Window.y_pos = (1.0-self:s(self.Window.height))*0.5;
end;

-- Add new image
function GraphicLayout:addImage(imgPath, x, y, width, height)
	if width ~= nil then local 		width = 	self:s(width) end;
	if height ~= nil then local 	height = 	self:s(height) end;
	local x = 		self:relative_x(x);
	local y = 		self:relative_y(y, height);
	if (imgPath ~= nil) then
        overlay = createImageOverlay(__DIR_GAME_MOD__..imgPath);
    end;
    local image = {visible=(overlay ~= nil), enabled=true, overlay=overlay, imgPath=imgPath, x=x, y=y, width=width, height=height};
    table.insert(self.overlayImages, image);
    return image;
end;

-- Render images
function GraphicLayout:renderImages()
    for _,image in pairs(self.overlayImages) do
        if (image.visible) then
            -- TODO - Normal, Focus, Pressed
            if (image.overlay ~= nil) then
				renderOverlay(image.overlay, image.x, image.y, image.width, image.height);
            end;
        end;
    end;
end;



-- Add new caption
function GraphicLayout:addCaption(text, x, y, size, color, shadow, width, align, bold, colorShadow)
	if size ~= nil then local 	size = 		self:s(size) end;
	if width ~= nil then local 	width = 	self:s(width) end;
	local x = 		self:relative_x(x);
	local y = 		self:relative_y(y, size);
    local caption = {enabled=true, text=text, x=x, y=y, size=size, color=color, shadow=shadow, width=width, align=align, bold=bold, colorShadow=colorShadow};
    table.insert(self.overlayCaptions, caption);
    return caption;
end;

-- Render captions
function GraphicLayout:renderCaptions()
	for _,caption in pairs(self.overlayCaptions) do
		-- Set text color
		if type(caption.color) ~= 'table' then setTextColor(1.0, 1.0, 1.0, 1.0)   -- white
		else setTextColor(caption.color[1], caption.color[2], caption.color[3], caption.color[4]) end;
		-- Set text width
		if caption.width==nil then 
			caption.width = self.Window.width;
			setTextWrapWidth(caption.width);
		else 
			if caption.width>self.Window.width then caption.width = self.Window.width end;
			setTextWrapWidth(caption.width);
		end;
		-- Set text weight
		if caption.bold==true then setTextBold(true)
		else setTextBold(false) end;
		-- Set text align
		if type(caption.align) == 'string' then
			if string.lower(caption.align) == 'left' then setTextAlignment(RenderText.ALIGN_LEFT)
			elseif string.lower(caption.align) == 'center' then 
				caption.x = (self.Window.x_pos*2+caption.width)*0.5;
				setTextAlignment(RenderText.ALIGN_CENTER);
			elseif string.lower(caption.align) == 'right' then 
				caption.x = self.Window.x_pos+caption.width;
				setTextAlignment(RenderText.ALIGN_RIGHT) 
			end;
		else setTextAlignment(RenderText.ALIGN_LEFT) end;
		
		-- Render text
		if caption.shadow == true then 
			renderTextWithShade(caption.x, caption.y, caption.size, caption.text, caption.color, caption.colorShadow);
		else renderText(caption.x, caption.y, caption.size, caption.text) end;
    end;
	
	setTextToDefault();
end;


-- Add new button
function GraphicLayout:addButton(buttonText, imgFilename, imgFilenameMouseOver, imgFilenameClick, callback, callbackData, x,y, width,height, mouseButtons, textScheme)
    if (mouseButtons == nil) then mouseButtons = self.MouseButton_Left; end;
    local overlay 	= nil;
	local width = 	self:s(width);
	local height = 	self:s(height);
	local x = 		self:relative_x(x);
	local y = 		self:relative_y(y, height);
    if (imgFilename ~= nil) then
        overlay = Overlay:new(buttonText, imgFilename, x, y, width, height);
    end;
    local button = {visible=(overlay ~= nil), enabled=true, buttonText=buttonText, overlay=overlay, rect={x,y, x+width,y+height}, onClick=callback, callbackData=callbackData, mouseButtons=mouseButtons, imgFilename=imgFilename, imgFilenameMouseOver=imgFilenameMouseOver, imgFilenameClick=imgFilenameClick, pressed=false, textScheme=textScheme};
    table.insert(self.overlayButtons, button);
    return button;
end;

-- Render all buttons
function GraphicLayout:renderButtons()
    setTextAlignment(RenderText.ALIGN_LEFT);
    setTextBold(true);

    for _,button in pairs(self.overlayButtons) do
        if (button.visible) then
            -- TODO - Normal, Focus, Pressed
            if (button.overlay ~= nil) then
                button.overlay:render();
            end;
            if (button.buttonText ~= nil) then
				setTextAlignment(RenderText.ALIGN_CENTER);
				local x = ((self:s(button.rect[1])*2)+(self:s(button.rect[3])-self:s(button.rect[1])))*0.5;
				local textSize = 0.024;
				local color = nil;
				local colorShadow = nil;
				if type(button.textScheme) == 'table' then 
					if button.textScheme.size ~= nil then textSize=button.textScheme.size end;
					if button.textScheme.color ~= nil then color=button.textScheme.color end;
					if button.textScheme.colorShadow ~= nil then colorShadow=button.textScheme.colorShadow end;
				end;
				if (not button.enabled) then
					color = {1.0, 1.0, 1.0, 0.3};   -- gray'ish
					colorShadow = {0.0, 0.0, 0.0, 1.0}
				end;
				renderTextWithShade(x, self:s(button.rect[2])+self:s(0.019), self:s(textSize), button.buttonText, color, colorShadow);
            end;
        end;
    end;
	
	setTextToDefault();
end;

-- Add new text input
function GraphicLayout:addTextInput(name, value, maxlength, x, y, password, layScheme)
	if type(value) ~= 'string' then value = '' end;
	local width = 	self:s(TextInputs.default.width);
	local height = 	self:s(TextInputs.default.height);
	local x = 		self:relative_x(x);
	local y = 		self:relative_y(y, height);
	local imgFilename 				= TextInputs.default.normal;
	local imgFilenameMouseOver		= TextInputs.default.focused;
	local imgFilenameClick			= TextInputs.default.pressed;
	local textScheme				= TextInputs.default.text;
	local overlay 					= Overlay:new(name, imgFilename, x, y, width, height);
	
	if type(layScheme) == 'table' then 
		if layScheme.width ~= nil then width = layScheme.width end;
		if layScheme.height ~= nil then height = layScheme.height end;
		if layScheme.normal ~= nil then imgFilename = layScheme.normal end;
		if layScheme.pressed ~= nil then imgFilenameClick = layScheme.pressed end;
		if layScheme.focused ~= nil then imgFilenameMouseOver = layScheme.focused end;	
		if layScheme.text ~= nil then textScheme = layScheme.text end;	 
	end;
	
    local input 					= {name=name, value=string.sub(value, 0, maxlength), visible=(overlay ~= nil), enabled=true, overlay=overlay, rect={x,y, x+width,y+height}, mouseButtons=self.MouseButton_Left, imgFilename=imgFilename, imgFilenameMouseOver=imgFilenameMouseOver, imgFilenameClick=imgFilenameClick, focused=false, maxlength=maxlength, password=password, textScheme=textScheme};
    table.insert(self.overlayTextInputs, input);
    return input;	
end;

-- Render all text inputs
function GraphicLayout:renderTextInputs()
    for _,input in pairs(self.overlayTextInputs) do
        if (input.visible) then
            -- TODO - Normal, Focus, Pressed
            if (input.overlay ~= nil) then
                input.overlay:render();
            end;
            if (input.value ~= nil) then
                setTextWrapWidth(self:s(input.overlay.width-0.084));
				local text = cutTextByHeight(self:s(0.028), input.value, self:s(input.overlay.height-0.016));
				if text==nil then text = '' end;
				
				local textSize = 0.024;
				local color = nil;
				if type(input.textScheme) == 'table' then 
					if input.textScheme.size ~= nil then textSize=input.textScheme.size end;
					if input.textScheme.color ~= nil then color=input.textScheme.color end;
				end;
				if (not input.enabled) then
					color = {1.0, 1.0, 1.0, 0.3};   -- gray'ish
				end;
								
				setTextColor(color[1], color[2], color[3], color[4]);   
				
				if input.password == true then renderText(input.rect[1]+self:s(0.010), input.rect[2]+self:s(0.018), self:s(0.024), string.gsub(text, "(.)", "*"))
				else renderText(input.rect[1]+self:s(0.010), input.rect[2]+self:s(0.018), self:s(0.024), text) end;
				setTextWrapWidth(1.0);
            end;			
        end;
    end;

	setTextToDefault();
end;

-- Get input value
function GraphicLayout:getInputValue(name)
	for _,input in pairs(self.overlayTextInputs) do
        if (input.visible) then
			if input.name == name then
				return input.value;
			end;
		end;
	end;
end;



-- Events --
function GraphicLayout:loadMap(name)
end;

function GraphicLayout:deleteMap()
	self.visible = false;
end;

function GraphicLayout:mouseEvent(posX, posY, isDown, isUp, button)
	if self.visible then
		-- Convert mouse-button to other value, so it can be AND-masked.
		if      (button == 1) then button = self.MouseButton_Left; 
		elseif  (button == 2) then button = self.MouseButton_Right;
		elseif  (button == 3) then button = self.MouseButton_Middle;
		elseif  (button == 4) then button = self.MouseButton_ScrollUp;
		elseif  (button == 5) then button = self.MouseButton_ScrollDown;
		end;		
		
		-- Button events
			for _,overlayButton in pairs(self.overlayButtons) do
				if (overlayButton.enabled) then
					if (overlayButton.rect[1] <= posX and posX <= overlayButton.rect[3] and overlayButton.rect[2] <= posY and posY <= overlayButton.rect[4]) then
						if (isDown) then
							-- Button OnClick
							-- print('OnClick');
							overlayButton.pressed = true;
							if overlayButton.imgFilenameClick ~= nil then
								overlayButton.overlay = Overlay:new(overlayButton.buttonText, overlayButton.imgFilenameClick, overlayButton.overlay.x, overlayButton.overlay.y, overlayButton.overlay.width, overlayButton.overlay.height);							
							end;
							if (bitAND(overlayButton.mouseButtons, button) > 0 and overlayButton.onClick ~= nil) then
								overlayButton.onClick(self, overlayButton, overlayButton.callbackData);
								break;
							end;
						elseif (isUp) then
							-- Button OnUnClick
							-- print('OnUnClick');
							overlayButton.pressed = false;
							overlayButton.overlay = Overlay:new(overlayButton.buttonText, overlayButton.imgFilename, overlayButton.overlay.x, overlayButton.overlay.y, overlayButton.overlay.width, overlayButton.overlay.height);			
						elseif (overlayButton.pressed) then
							-- Button OnPressed
							-- print('OnPressed');
							if overlayButton.imgFilenameClick ~= nil then
								overlayButton.overlay = Overlay:new(overlayButton.buttonText, overlayButton.imgFilenameClick, overlayButton.overlay.x, overlayButton.overlay.y, overlayButton.overlay.width, overlayButton.overlay.height);					
							end;
						else
							-- Button OnMouseOver
							-- print('OnMouseOver');
							if overlayButton.imgFilenameMouseOver ~= nil and not overlayButton.pressed then
								overlayButton.overlay = Overlay:new(overlayButton.buttonText, overlayButton.imgFilenameMouseOver, overlayButton.overlay.x, overlayButton.overlay.y, overlayButton.overlay.width, overlayButton.overlay.height);
							end;							
						end;
					else
						overlayButton.overlay = Overlay:new(overlayButton.buttonText, overlayButton.imgFilename, overlayButton.overlay.x, overlayButton.overlay.y, overlayButton.overlay.width, overlayButton.overlay.height);
					end;
				end;
			end;
		
		-- Input Events
			for _,overlayInput in pairs(self.overlayTextInputs) do
				if (overlayInput.enabled) then
					if (overlayInput.rect[1] <= posX and posX <= overlayInput.rect[3] and overlayInput.rect[2] <= posY and posY <= overlayInput.rect[4]) then
						if (isDown) then
							-- Input OnClick
							-- print('OnClick');
							overlayInput.focused = true;
							if overlayInput.imgFilenameClick ~= nil then
								overlayInput.overlay = Overlay:new(overlayInput.name, overlayInput.imgFilenameClick, overlayInput.overlay.x, overlayInput.overlay.y, overlayInput.overlay.width, overlayInput.overlay.height);
							end;
						elseif (isUp) then
							-- Input OnUnClick
							-- print('OnUnClick');
						elseif (overlayInput.focused) then
							-- Input OnFocused
							-- print('OnFocused');
							if overlayInput.imgFilenameClick ~= nil then
								overlayInput.overlay = Overlay:new(overlayInput.name, overlayInput.imgFilenameClick, overlayInput.overlay.x, overlayInput.overlay.y, overlayInput.overlay.width, overlayInput.overlay.height);
							end;
						else
							-- Input OnMouseOver
							-- print('OnMouseOver');
							if overlayInput.imgFilenameMouseOver ~= nil and not overlayInput.focused then
								overlayInput.overlay = Overlay:new(overlayInput.name, overlayInput.imgFilenameMouseOver, overlayInput.overlay.x, overlayInput.overlay.y, overlayInput.overlay.width, overlayInput.overlay.height);
							end;							
						end;					
					else
						if (isDown) then
							overlayInput.focused = false;
							overlayInput.overlay = Overlay:new(overlayInput.name, overlayInput.imgFilename, overlayInput.overlay.x, overlayInput.overlay.y, overlayInput.overlay.width, overlayInput.overlay.height);
						elseif overlayInput.focused then
							if overlayInput.imgFilenameClick ~= nil then
								overlayInput.overlay = Overlay:new(overlayInput.name, overlayInput.imgFilenameClick, overlayInput.overlay.x, overlayInput.overlay.y, overlayInput.overlay.width, overlayInput.overlay.height);
							end;						
						else
							overlayInput.overlay = Overlay:new(overlayInput.name, overlayInput.imgFilename, overlayInput.overlay.x, overlayInput.overlay.y, overlayInput.overlay.width, overlayInput.overlay.height);
						end;
					end;
				end;
			end;
	end;
end;

function GraphicLayout:keyEvent(unicode, sym, modifier, isDown)	
	if self.visible then
		-- Text Input Keyboard Events
		for _,overlayInput in pairs(self.overlayTextInputs) do
			if (overlayInput.enabled) then
				if overlayInput.focused then
					if isDown and sym == 8 then
						-- Backspace
						--overlayInput.value = string.sub(overlayInput.value, 0, string.len(overlayInput.value)-1);
						overlayInput.value = '';
					elseif isDown then
						-- Other keys
						--local newChar = Keyboard.getChar(sym, Input.isKeyPressed(Input.KEY_shift));
						local newChar = utf8dec(unicode);
						if newChar ~= nil and unicode>0 then overlayInput.value = string.sub(overlayInput.value..newChar, 0, overlayInput.maxlength) end;
					end;
					break;
				end;
			end;
		end;
	end;
end;

function GraphicLayout:update(dt)
end;

function GraphicLayout:draw()
	self:render();
end;