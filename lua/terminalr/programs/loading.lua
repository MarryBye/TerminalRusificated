TerminalR.Programs["loading"] = {}

local terminalColors = {

	[1] = { c = Color(255, 255, 255, 255), n = "Белый" },
	[2] = { c = Color(0, 255, 0, 255), n = "Зеленый" },
	[3] = { c = Color(255, 0, 0, 255), n = "Красный" },
	[4] = { c = Color(0, 0, 255, 255), n = "Синий" },
	[5] = { c = Color(255, 150, 0, 255), n = "Желтый" }

}

TerminalR.Programs["loading"].Init = function( self )
	self:SetMemoryIfEmpty( "LoadingPercent", 0 )
	self:SetMemoryIfEmpty( "LoadingAmount", 1 )
	self:SetMemoryIfEmpty( "NextThink", 0 )
	self:SetMemoryIfEmpty( "BlackScreenAlpha", 0 )
	self:SetMemoryIfEmpty( "TitleScreenAlpha", 0 )
	self:SetMemoryIfEmpty( "TitleScreenPosX", 0 )
	self:SetMemoryIfEmpty( "TitleScreenPosY", 0 )
	self:SetMemoryIfEmpty( "TerminalColor", terminalColors[5].c )
	
	local LoadingText = { 
		[0] = "...",
		[1] = "Загрузка ...",
		[2] = "Считывание диска с OS ...",
		[3] = "Подготовка к установке OS ...",
		[4] = "Установка OS ...",
		[5] = "Запись на устройство (1/3) ...",
		[6] = "Запись на устройство (2/3) ...",
		[7] = "Запись на устройство (3/3) ...",
		[8] = "Завершение установки ...",
		[9] = "Подготовка к запуску ...",
		[10] = "Запуск ..."
	}
	self:SetMemoryIfEmpty( "Text", LoadingText )
end

TerminalR.Programs["loading"].Paint = function( self, w, h )
	local cr, cg, cb, ca = self:GetMemory("TerminalColor").r, self:GetMemory("TerminalColor").g, self:GetMemory("TerminalColor").b, math.random(230, 255)
	local cclr = Color(math.random(cr - 35, cr), math.random(cg - 35, cg), math.random(cb - 35, cb), ca)
	local Percent = math.Clamp( self:GetMemory( "LoadingPercent" ), 0, 100 )
	local randBlack = math.random(0, 3)
	draw.RoundedBox( 0, 0, 0, w, h, Color(randBlack, randBlack, randBlack) )
	draw.RoundedBox( 0, w*0.2, h*0.5, w*0.6, h*0.05, Color(30,30,30) )
	draw.RoundedBox( 0, w*0.2, h*0.5, (Percent/100)*(w*0.6), h*0.05, cclr )

	local Text = self:GetMemory( "Text" )[ math.Round( Percent * 0.1  ) ]
	draw.DrawText( Text, "TrmR_Medium", ScrW() * 0.5, ScrH() * 0.45, cclr, 1 )
	draw.DrawText( "(" .. Percent .. ") %", "TrmR_Medium", ScrW() * 0.5, ScrH() * 0.575, cclr, 1 )
	draw.DrawText( "Установка", "TrmR_Title", ScrW() * 0.5, ScrH() * 0.2, cclr, 1 )
	
	local BAplha = self:GetMemory( "BlackScreenAlpha" )
	local TAplha = self:GetMemory( "TitleScreenAlpha" )
	
	local PosX = Lerp( self:GetMemory( "TitleScreenPosX" ), w ,w*0.05 )
	local PosY = Lerp( self:GetMemory( "TitleScreenPosY" ), h*0.025 ,h*0.025 )
	
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, BAplha ) )
	draw.DrawText( "Меню терминала", "TrmR_Title", PosX, PosY, cclr, 0, 0 )
end

TerminalR.Programs["loading"].Think = function( self, dt )
	if ( self:GetMemory("LoadingPercent") < 100 ) then
		if ( CurTime() > self:GetMemory( "NextThink" ) ) then
			self:SetMemory( "LoadingPercent", self:GetMemory("LoadingPercent") + self:GetMemory( "LoadingAmount" ) )
			self:SetMemory( "LoadingAmount", math.random(1, 10) )
			if ( math.random( 1, 100 ) > 80 ) then
				self:SetMemory( "NextThink", CurTime() + math.random( 5, 15 ) / 10 )
			else
				self:SetMemory( "NextThink", CurTime() + 0.08 )
			end
		end
	else
		self:SetMemory( "BlackScreenAlpha", self:GetMemory("BlackScreenAlpha") + ( dt * 125 ) )
		if ( self:GetMemory("BlackScreenAlpha") > 255 ) then
			self:SetMemory( "TitleScreenAlpha", self:GetMemory("TitleScreenAlpha") + ( dt * 255 ) )
			self:SetMemory( "TitleScreenPosX", self:GetMemory("TitleScreenPosX") + ( dt * 0.3 ) )
			self:SetMemory( "TitleScreenPosY", self:GetMemory("TitleScreenPosY") + ( dt * 0.3 ) )
			if ( self:GetMemory("BlackScreenAlpha") > 750 ) then
				self:RemoveAllMemoryNamed( {"TitleScreenAlpha", "TitleScreenPosX", "TitleScreenPosY", "BlackScreenAlpha", "LoadingPercent", "LoadingAmount", "NextThink", "Text"} )
				self:LaunchProgram( "menu" )
			end
		end
	end
end

TerminalR.Programs["loading"].OnRemove = function( self )
	self:RemoveMemory( "Text" )
end