TerminalR.Programs["colorsettings"] = {}

local terminalColors = {

	[1] = { c = Color(255, 255, 255, 255), n = "Белый" },
	[2] = { c = Color(0, 255, 0, 255), n = "Зеленый" },
	[3] = { c = Color(255, 0, 0, 255), n = "Красный" },
	[4] = { c = Color(0, 0, 255, 255), n = "Синий" },
	[5] = { c = Color(255, 150, 0, 255), n = "Желтый" }

}

TerminalR.Programs["colorsettings"].Init = function( self )

	local W, H = ScrW(), ScrH()
	
	for i = 1, #terminalColors do 

		local SW, SH = TerminalRGetTextSize( "> " .. terminalColors[i].n, "TrmR_Medium" )
		local colorButton = self:CreateMenuButton( "colorButton" .. i, "> " .. terminalColors[i].n )
		colorButton:SetPos( W*0.05, H * (0.15 + (0.05 * i))  )
		colorButton:SetSize( SW + 40, SH + 10 )
		colorButton.DoClick = function( selfB )
			self:SetMemory("TerminalColor", terminalColors[i].c)
		end

	end

	local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.Cancel, "TrmR_Medium" )
	local Save = self:CreateMenuButton( "Save", "> " .. TerminalR.Lang.Cancel )
	Save:SetPos( ScrW()*0.01, ScrH()*0.925 )
	Save:SetSize( SW + 40, SH + 10 )
	Save.DoClick = function( selfB )
		self:RemoveParent()
		self:LaunchProgram( "menu" )
	end

end