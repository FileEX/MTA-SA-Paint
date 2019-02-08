--[[
	Author: FileEX
]]

local screenX, screenY = guiGetScreenSize();
local zoom = (1280 / screenX);

local paint = {};
setmetatable(paint, {__call = function(o, ...) return o:constructor(...) end, __index = paint});

local win,clbtn,svbtn,tpcmb,nmedt,nlbl,tlbl,lastact;

local tex = {};
local textures = {'bucket', 'pipette', 'pencil', 'brush', 'text', 'line', 'rubber', 'save'};

function paint:constructor()
	self.__init = function()
		self.surface = false;
		self.colorTable = {0xFF000000, 0xFFC0C0C0, 0xFF808080, 0xFFFFFFFF, 0xFFFF0000, 0xFF800000, 0xFFFF6600, 0xFFCC3300, 0xFFFFFF00, 0xFF808000, 0xFF00FF00, 0xFF008000, 0xFFFF00FF, 0xFF800080, 0xFF0000FF, 0xFF000080, 0xFF00FFFF, 0xFF008080, 0xFF993300, 0xFF663300, 0xFF70DB93, 0xFF9F5F9F, 0xFFB5A642, 0xFF5C3317, 0xFFD9D919, 0xFFA62A2A, 0xFF8C7853, 0xFFFFCC99, 0xFFCC9966, 0xFFA67D3D, 0xFF5F9F9F, 0xFF5C4033, 0xFF2F4F2F, 0xFF4A766E, 0xFF4F4F2F, 0xFF9932CD, 0xFF871F78, 0xFF6B238E, 0xFF2F4F4F, 0xFF96694F, 0xFF7093DB, 0xFF93DB70, 0xFFEAEAAE};
		self.colorStringTable = {'0xFF000000', '0xFFC0C0C0', '0xFF808080', '0xFFFFFFFF', '0xFFFF0000', '0xFF800000', '0xFFFF6600', '0xFFCC3300', '0xFFFFFF00', '0xFF808000', '0xFF00FF00', '0xFF008000', '0xFFFF00FF', '0xFF800080', '0xFF0000FF', '0xFF000080', '0xFF00FFFF', '0xFF008080', '0xFF993300', '0xFF663300', '0xFF70DB93', '0xFF9F5F9F', '0xFFB5A642', '0xFF5C3317', '0xFFD9D919', '0xFFA62A2A', '0xFF8C7853', '0xFFFFCC99', '0xFFCC9966', '0xFFA67D3D', '0xFF5F9F9F', '0xFF5C4033', '0xFF2F4F2F', '0xFF4A766E', '0xFF4F4F2F', '0xFF9932CD', '0xFF871F78', '0xFF6B238E', '0xFF2F4F4F', '0xFF96694F', '0xFF7093DB', '0xFF93DB70', '0xFFEAEAAE'};
		self.selectedColor = 0xFFFFFFFF;
		self.selectedColorString = '0xFFFFFFFF';
		self.bgColor = 0xFFFFFFFF;
		self.bgColorString = '0xFFFFFFFF';
		self.opAction = 0;
		self.texts = {};
		self.actualText = 0;
	end

	self.__init();

	self:createArea();
	self.render = function() self:draw(self); end;
	self.click = function(btn,state) self:action(btn,state,self); end;
	self.move = function(cx,cy,ax,ay) self:drawPaint(cx,cy,ax,ay,self); end;
	self.guiActions = function(b) self:guiClick(b,source,self); end;
	self.textSet = function(k,ks) self:textUpdate(k,ks,self); end;
	self.textDraw = function(ch) self:textDrawing(ch,self); end;
	self.textRemove = function(k,ks) self:textRemoving(k,ks,self); end;

	addEventHandler('onClientRender',root,self.render);
	addEventHandler('onClientClick', root, self.click);
	addEventHandler('onClientCursorMove', root, self.move);
	addEventHandler('onClientCharacter',root,self.textDraw);
	bindKey('backspace','down',self.textRemove);
	bindKey('mouse1','down', self.textSet);
	showCursor(true);

	for k,v in pairs(textures) do
		tex[k] = DxTexture('img/'..v..'.png','argb',false,'clamp');
	end

	return self;
end

function paint:destructor()
	if isElement(self.surface) then
		self.surface:destroy();
	end
	removeEventHandler('onClientRender', root, self.render);
	removeEventHandler('onClientClick', root, self.click);
	removeEventHandler('onClientCursorMove',root,self.move);
	removeEventHandler('onClientCharacter',root,self.textDraw);
	showCursor(false);
	unbindKey('mouse1','down',self.textSet);
	unbindKey('backspace','down',self.textRemove);
	setCursorAlpha(255);

	for k,v in pairs(tex) do
		v:destroy();
	end

	tex = {};

	if isElement(win) then
		win:destroy();
	end

	win,clbtn,svbtn,tpcmb,nmedt,nlbl,tlbl,lastact = nil,nil,nil,nil,nil,nil,nil,nil;

	_G['self'] = nil;
	collectgarbage('collect');
end

function paint:createArea()
	if not self.surface and not isElement(self.surface) then
		self.surface = DxTexture(500, 500);
	end

	local pixels = self.surface:getPixels();

	for i = 1,500 do
		for k = 1,500 do
			dxSetPixelColor(pixels, i, k, 255,255,255,255);
		end
	end

	self.surface:setPixels(pixels);
end

function paint:draw()
	dxDrawRectangle(screenX / 2 - 410 / zoom, screenY / 2 - 320 / zoom, 790 / zoom, 590 / zoom, 0x96CDCDCD, false);

	dxDrawImage(screenX / 2 - 395 / zoom, screenY / 2 - 210 / zoom, 30 / zoom, 30 / zoom, tex[1], 0,0,0, (not isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 210 / zoom, 30 / zoom, 30 / zoom) and 0xFFFFFFFF or 0xFF0DD667), false);
	dxDrawImage(screenX / 2 - 395 / zoom, screenY / 2 - 170 / zoom, 30 / zoom, 30 / zoom, tex[2], 0,0,0, (not isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 170 / zoom, 30 / zoom, 30 / zoom) and 0xFFFFFFFF or 0xFF0DD667), false);
	dxDrawImage(screenX / 2 - 395 / zoom, screenY / 2 - 130 / zoom, 30 / zoom, 30 / zoom, tex[3], 0,0,0, (not isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 130 / zoom, 30 / zoom, 30 / zoom) and 0xFFFFFFFF or 0xFF0DD667), false);
	dxDrawImage(screenX / 2 - 395 / zoom, screenY / 2 - 90 / zoom, 30 / zoom, 30 / zoom, tex[4], 0,0,0, (not isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 90 / zoom, 30 / zoom, 30 / zoom) and 0xFFFFFFFF or 0xFF0DD667), false);
	dxDrawImage(screenX / 2 - 395 / zoom, screenY / 2 - 50 / zoom, 30 / zoom, 30 / zoom, tex[5], 0,0,0, (not isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 50 / zoom, 30 / zoom, 30 / zoom) and 0xFFFFFFFF or 0xFF0DD667), false);
	dxDrawImage(screenX / 2 - 395 / zoom, screenY / 2 - 10 / zoom, 30 / zoom, 30 / zoom, tex[6], 45,0,0, (not isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 10 / zoom, 30 / zoom, 30 / zoom) and 0xFFFFFFFF or 0xFF0DD667), false);
	dxDrawImage(screenX / 2 - 395 / zoom, screenY / 2 + 30 / zoom, 30 / zoom, 30 / zoom, tex[7], 0,0,0, (not isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 + 30 / zoom, 30 / zoom, 30 / zoom) and 0xFFFFFFFF or 0xFF0DD667), false);
	dxDrawImage(screenX / 2 - 395 / zoom, screenY / 2 + 70 / zoom, 30 / zoom, 30 / zoom, tex[8], 0,0,0, (not isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 + 70 / zoom, 30 / zoom, 30 / zoom) and 0xFFFFFFFF or 0xFF0DD667), false);

	if self.surface and isElement(self.surface) then
		dxDrawImage(screenX / 2 - 350 / zoom, screenY / 2 - 230 / zoom, 730 / zoom, 500 / zoom, self.surface, 0,0,0, 0xFFFFFFFF, false);
	end

	dxDrawRectangle(screenX / 2 - 330 / zoom, screenY / 2 - 310 / zoom, 80 / zoom, 70 / zoom, self.selectedColor, false);
	dxDrawLinedRectangle(screenX / 2 - 330 / zoom, screenY / 2 - 310 / zoom, 80 / zoom, 70 / zoom, 0xFF000000, 3, false);

	for k,v in pairs(self.texts) do
		if v[9] then
			dxDrawLinedRectangle(v[2],v[3],v[4],v[5],0xFF7799FB, 2.3, true);
		end
		dxDrawText(v[1], v[2],v[3],v[4],v[5],v[6],v[7],v[8]);
	end


	if self.opAction ~= 0 then
		if isMouseInPosition(screenX / 2 - 350 / zoom, screenY / 2 - 230 / zoom, 730 / zoom, 500 / zoom) then
			if getCursorAlpha() ~= 0 then
				setCursorAlpha(0);
			end
			local cx,cy = getCursorPosition();
			local cx,cy = (cx * screenX), (cy * screenY);
			if self.actualText > 0 then
				local i = self.actualText;
				if self.texts[i][14] and not self.texts[i][15] then
					self.texts[i][2] = (cx - self.texts[i][10]);
					self.texts[i][3] = (cy - self.texts[i][11]);
				end
				if self.texts[i][15] then
					self.texts[i][4] = (cx - self.texts[i][12]);
					self.texts[i][5] = (cy - self.texts[i][13]);
					self.texts[i][7] = self.texts[i][4] / 100;
					self.texts[i][8] = self.texts[i][5] / 100;
				end
			end
			dxDrawImage(cx - 10,cy - 10, 20 / zoom, 20 / zoom, tex[self.opAction], ((self.opAction == 4 and 180 or (self.opAction == 6 and 45)) or 0),0,0, 0xFF0DD667, false);
		else
			if getCursorAlpha() ~= 255 then
				setCursorAlpha(255);
			end
		end
	end

	for i = 1,40 do
		local recX = screenX / 2 - ( i <= 20 and (250 - i * 30) or (250 - ( i % ( i < 40 and 40 or i + 1) - ((i < 40 and i or i - 1) - ((i < 40 and i or i - 1) % 20))) * 30)) / zoom;
		local recY = screenY / 2 - ( i <= 20 and 290 or 260) / zoom;
		dxDrawRectangle(recX, recY, 25 / zoom, 25 / zoom, self.colorTable[i], false);
		if isMouseInPosition(recX, recY, 25 / zoom, 25 / zoom) then
			dxDrawLinedRectangle(recX, recY, 25 / zoom, 25 / zoom, 0xFF0DD667, 2.5, false);
		end
	end
end

function paint:saveImage(name, type)
	local f = File('images/'..name..'.'..type);
	if (f) then
		f:write(dxConvertPixels(self.surface:getPixels(), type));
		f:flush();
		f:close();
		outputChatBox('Obraz został zapisany.',255,255,255);
		outputConsole('(Domyślnie) Obraz znajdziesz w C:\\Multi Theft Auto San Andreas\\mods\\deathmatch\\resources\\images\\'..resource.name);
	end
end

function paint:guiClick(b,s)
	if b == 'left' then
		if s == clbtn then
			self:createSaveUI();
			self.opAction = lastact;
		elseif s == svbtn then
			if #guiGetText(nmedt) > 0 and guiGetText(nmedt) ~= '' and  guiGetText(nmedt) ~= ' ' then
				if guiComboBoxGetSelected(tpcmb) ~= -1 then
					self:saveImage(guiGetText(nmedt), guiComboBoxGetItemText(tpcmb, guiComboBoxGetSelected(tpcmb)));
					self:createSaveUI();
					self.opAction = lastact;
				else
					outputChatBox('Wybierz rozszerzenie pliku.',255,255,255);
				end
			else
				outputChatBox('Wprowadź nazwę pliku.',255,255,255);
			end
		end
	end
end

function paint:createSaveUI()
	if not isElement(win) then
		win = guiCreateWindow(screenX / 2 - 150 / zoom, screenY / 2 - 50 / zoom, 300 / zoom, 130 / zoom, 'Zapisz obraz', false);
		clbtn = guiCreateButton(10,85,110,40,'Zamknij',false,win);
		svbtn = guiCreateButton(180,85,110,40,'Zapisz',false,win);
		nlbl = guiCreateLabel(10,20,80,20,'Nazwa pliku',false,win);
		nmedt = guiCreateEdit(5,40,200,30,'',false,win);
		tlbl = guiCreateLabel(210,25,80,20,'Typ pliku',false,win);
		tpcmb = guiCreateComboBox(210,45,80,150,'',false,win);
		guiComboBoxAddItem(tpcmb, 'PLAIN');
		guiComboBoxAddItem(tpcmb, 'PNG');
		guiComboBoxAddItem(tpcmb, 'JPEG');
		addEventHandler('onClientGUIClick',resourceRoot,self.guiActions);
	else
		removeEventHandler('onClientGUIClick',resourceRoot,self.guiActions);
		win:destroy();
		win,clbtn,svbtn,tpcmb,nmedt,nlbl,tlbl = nil,nil,nil,nil,nil,nil,nil;
	end
end

function paint:action(btn,state)
	if btn == 'left' and state == 'down' then
		if isMouseInPosition(screenX / 2 - 220, screenY / 2 - 290 / zoom, 599 / zoom, 55 / zoom) then
			for i = 1,40 do
				if isMouseInPosition(screenX / 2 - ( i <= 20 and (250 - i * 30) or (250 - ( i % ( i < 40 and 40 or i + 1) - ((i < 40 and i or i - 1) - ((i < 40 and i or i - 1) % 20))) * 30)) / zoom, screenY / 2 - ( i <= 20 and 290 or 260) / zoom, 25 / zoom, 25 / zoom) then
					self.selectedColor = self.colorTable[i];
					self.selectedColorString = self.colorStringTable[i];
					break;
				end
			end
		elseif isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 210 / zoom, 30 / zoom, 30 / zoom) then
			self.opAction = self.opAction ~= 1 and 1 or 0;
		elseif isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 170 / zoom, 30 / zoom, 30 / zoom) then
			self.opAction = self.opAction ~= 2 and 2 or 0;
		elseif isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 130 / zoom, 30 / zoom, 30 / zoom) then
			self.opAction = self.opAction ~= 3 and 3 or 0;
		elseif isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 90 / zoom, 30 / zoom, 30 / zoom) then
			self.opAction = self.opAction ~= 4 and 4 or 0;
		elseif isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 50 / zoom, 30 / zoom, 30 / zoom) then
			self.opAction = self.opAction ~= 5 and 5 or 0;
		elseif isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 - 10 / zoom, 30 / zoom, 30 / zoom) then
			self.opAction = self.opAction ~= 6 and 6 or 0;
		elseif isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 + 30 / zoom, 30 / zoom, 30 / zoom) then
			self.opAction = self.opAction ~= 7 and 7 or 0;
		elseif isMouseInPosition(screenX / 2 - 395 / zoom, screenY / 2 + 70 / zoom, 30 / zoom, 30 / zoom) then
			lastact = self.opAction;
			self.opAction = 0;
			self:createSaveUI();
		elseif isMouseInPosition(screenX / 2 - 350 / zoom, screenY / 2 - 230 / zoom, 730 / zoom, 500 / zoom) then
			if self.opAction == 1 then
				local r,g,b = hex2rgba(self.selectedColorString);
				local r2,g2,b2 = hex2rgba(self.bgColorString);
				if r ~= r2 or g ~= g2 or b ~= b2 then
					local pixels = self.surface:getPixels();
					for i = 1,500 do
						for k = 1,500 do
							dxSetPixelColor(pixels, i, k, r,g,b,255);
						end
					end
					self.surface:setPixels(pixels);
					self.bgColor = self.selectedColor;
					self.bgColorString = self.selectedColorString;
				end
			elseif self.opAction == 2 then
				local cx,cy = getCursorPosition();
				local cx,cy = (cx * screenX), (cy * screenY);
				local px = 500 * ((cx - (screenX / 2 - 350 / zoom)) / (730 / zoom));
				local py = 500 * ((cy - (screenY / 2 - 230 / zoom)) / (500 / zoom));
				local pixels = self.surface:getPixels();
				local r,g,b = dxGetPixelColor(pixels, px, py);
				self.selectedColor = rgb2hex(r,g,b, false);
				self.selectedColorString = rgb2hex(r,g,b, true);
			end
		end
	end
end

function paint:textRemoving(k,ks)
	if self.opAction == 5 then
		if self.actualText > 0 then
			if #self.texts[self.actualText][1] - 1 >= 0 then
				self.texts[self.actualText][1] = self.texts[self.actualText][1]:sub(0,#self.texts[self.actualText][1] - 1);
			end
		end
	end
end

function paint:textDrawing(ch)
	if self.opAction == 5 then
		if self.actualText > 0 then
			if dxGetTextWidth(self.texts[self.actualText][1], self.texts[self.actualText][7], 'default') <= self.texts[self.actualText][2] + self.texts[self.actualText][4] then
				self.texts[self.actualText][1] = self.texts[self.actualText][1]..ch;
			end
		end
	end
end

function paint:textUpdate(k,ks)
	if self.opAction == 5 and k == 'mouse1' and ks == 'down' and isMouseInPosition(screenX / 2 - 350 / zoom, screenY / 2 - 230 / zoom, 730 / zoom, 500 / zoom) then
		if self.actualText < 1 then
			local i = #self.texts + 1;
			local cx,cy = getCursorPosition();
			local cx,cy = (cx * screenX), (cy * screenY);
			local px = 500 * ((cx - (screenX / 2 - 350 / zoom)) / (730 / zoom));
			local py = 500 * ((cy - (screenY / 2 - 230 / zoom)) / (500 / zoom));
			self.texts[i] = {'Tekst',cx,cy,100,100,self.selectedColor,1.0,1.0,true, 0,0, 0,0, false,false};
			self.actualText = i;
		end
		if not self.texts[self.actualText][14] then
			self.texts[self.actualText][14] = true;
		else
			if not self.texts[self.actualText][15] then
				self.texts[self.actualText][15] = true;
			else
				self.texts[self.actualText][15] = false;
				self.texts[self.actualText][9] = false;
				self.actualText = 0;
			end
		end
	end
end

function paint:drawPaint(cx,cy,ax,ay)
	if self.opAction == 3 and getKeyState('mouse1') then
		local px = 500 * ((ax - (screenX / 2 - 350 / zoom)) / (730 / zoom));
		local py = 500 * ((ay - (screenY / 2 - 230 / zoom)) / (500 / zoom));
		local pixels = self.surface:getPixels();
		local r,g,b = dxGetPixelColor(pixels, px, py);
		local r2,g2,b2 = hex2rgba(self.selectedColorString);
		if r ~= r2 or g ~= g2 or b ~= b2 then
			for i = px, px + 5 do
				for k = py, py + 5 do
					dxSetPixelColor(pixels, i - 3,k - 3,r2,g2,b2,255);
					dxSetPixelColor(pixels, i - 3,k,r2,g2,b2,255);
					dxSetPixelColor(pixels, i - 3,k + 3,r2,g2,b2,255);

					dxSetPixelColor(pixels, i, k - 3, r2,g2,b2,255);
					dxSetPixelColor(pixels, i, k, r2,g2,b2,255);
					dxSetPixelColor(pixels, i, k + 3,r2,g2,b2,255);

					dxSetPixelColor(pixels, i + 3, k - 3,r2,g2,b2,255);
					dxSetPixelColor(pixels, i + 3,k,r2,g2,b2,255);
					dxSetPixelColor(pixels, i + 3, k + 3,r2,g2,b2,255);
				end
			end
			self.surface:setPixels(pixels);
		end
	elseif self.opAction == 4 and getKeyState('mouse1') then
		local px = 500 * ((ax - (screenX / 2 - 350 / zoom)) / (730 / zoom));
		local py = 500 * ((ay - (screenY / 2 - 230 / zoom)) / (500 / zoom));
		local pixels = self.surface:getPixels();
		local r,g,b = dxGetPixelColor(pixels, px, py);
		local r2,g2,b2 = hex2rgba(self.selectedColorString);
		if r ~= r2 or g ~= g2 or b ~= b2 then
			for i = px, px + 10 do
				for k = py, py + 10 do
					dxSetPixelColor(pixels, i - 3,k - 3,r2,g2,b2,255);
					dxSetPixelColor(pixels, i - 3,k,r2,g2,b2,255);
					dxSetPixelColor(pixels, i - 3,k + 3,r2,g2,b2,255);

					dxSetPixelColor(pixels, i, k - 3, r2,g2,b2,255);
					dxSetPixelColor(pixels, i, k, r2,g2,b2,255);
					dxSetPixelColor(pixels, i, k + 3,r2,g2,b2,255);

					dxSetPixelColor(pixels, i + 3, k - 3,r2,g2,b2,255);
					dxSetPixelColor(pixels, i + 3,k,r2,g2,b2,255);
					dxSetPixelColor(pixels, i + 3, k + 3,r2,g2,b2,255);
				end
			end
			self.surface:setPixels(pixels);
		end
	elseif self.opAction == 7 and getKeyState('mouse1') then
		local px = 500 * ((ax - (screenX / 2 - 350 / zoom)) / (730 / zoom));
		local py = 500 * ((ay - (screenY / 2 - 230 / zoom)) / (500 / zoom));
		local pixels = self.surface:getPixels();
		local r,g,b = dxGetPixelColor(pixels, px, py);
		if r ~= 255 or g ~= 255 or b ~= 255 then
			for i = px, px + 5 do
				for k = py, py + 5 do
					dxSetPixelColor(pixels, i - 3,k - 3,255,255,255,255);
					dxSetPixelColor(pixels, i - 3,k,255,255,255,255);
					dxSetPixelColor(pixels, i - 3,k + 3,255,255,255,255);

					dxSetPixelColor(pixels, i, k - 3, 255,255,255,255);
					dxSetPixelColor(pixels, i, k, 255,255,255,255);
					dxSetPixelColor(pixels, i, k + 3,255,255,255,255);

					dxSetPixelColor(pixels, i + 3, k - 3,255,255,255,255);
					dxSetPixelColor(pixels, i + 3,k,255,255,255,255);
					dxSetPixelColor(pixels, i + 3, k + 3,255,255,255,255);
				end
			end
			self.surface:setPixels(pixels);
		end
	end
end

local pClass;

bindKey('F3','down',function(k,s)
	if k == 'F3' and s == 'down' then
		if not pClass then
			pClass = paint();
		else
			pClass:destructor();
			pClass = nil;
		end
	end
end);