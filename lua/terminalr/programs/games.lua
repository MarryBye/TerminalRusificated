TerminalR.Programs["games"] = {}

local terminalGames = {

	[1] = { n = "Змейка", programm = 'snake', r = 'SnakeRecord' }

}


TerminalR.Programs["games"].Init = function( self )

	local W, H = ScrW(), ScrH()
	
	for i = 1, #terminalGames do 

		self:SetMemoryIfEmpty(terminalGames[i].r, 0)

		local SW, SH = TerminalRGetTextSize( "> " .. terminalGames[i].n .. '(Рекорд: ' .. self:GetMemory(terminalGames[i].r) .. ')', "TrmR_Medium" )
		local gameButton = self:CreateMenuButton( "gameButton" .. i, "> " .. terminalGames[i].n .. ' (Рекорд: ' .. self:GetMemory(terminalGames[i].r) .. ' ) ' )
		gameButton:SetPos( W*0.05, H * (0.15 + (0.05 * i))  )
		gameButton:SetSize( SW + 40, SH + 10 )
		gameButton.DoClick = function( selfB )
			self:RemoveParent()
			self:LaunchProgram(terminalGames[i].programm)
		end

	end

	local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.Cancel, "TrmR_Medium" )
	local games = self:CreateMenuButton( "games", "> " .. TerminalR.Lang.Cancel )
	games:SetPos( ScrW()*0.01, ScrH()*0.925 )
	games:SetSize( SW + 40, SH + 10 )
	games.DoClick = function( selfB )
		self:RemoveParent()
		self:LaunchProgram( "menu" )
	end

end