TerminalR.Programs["menu"] = {}

TerminalR.Programs["menu"].Init = function( self )
	local W, H = ScrW(), ScrH()
	self:SetMemory( "MenuMsg", "" )
	self:SetMemory( "MenuMsgAlpha", 0 )
	
	local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.ButtonReadDisk, "TrmR_Medium" )
	local ReadDisk = self:CreateMenuButton( "ReadDisk", "> " .. TerminalR.Lang.ButtonReadDisk )
	ReadDisk:SetPos( W*0.05, H*0.15 )
	ReadDisk:SetSize( SW + 40 , SH + 10 )
	ReadDisk.DoClick = function( selfB )
		if ( self.Memory.DiskText ) then
			if ( self:GetMemory("DiskPass") ) then
				self:SetMemory("BlockedProgram", "disk_read" )
				self:LaunchProgram( "password_check" )
			else
				self:LaunchProgram( "disk_read" )
			end
		else
			self:SetMemory( "MenuMsg", TerminalR.Lang.NoDiskInsert )
			self:SetMemory( "MenuMsgAlpha", 255 )
			surface.PlaySound( "terminalr/false.wav" )
		end
	end
	
	local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.ButtonWriteDisk, "TrmR_Medium" )
	local WriteOnDisk = self:CreateMenuButton( "WriteOnDisk", "> " .. TerminalR.Lang.ButtonWriteDisk )
	WriteOnDisk:SetPos( W*0.05, H*0.2 )
	WriteOnDisk:SetSize( SW + 40 , SH + 10 )
	WriteOnDisk.DoClick = function( selfB )
		if ( self.Memory.DiskText ) then
			if ( self:GetMemory("DiskPass") ) then
				self:SetMemory("BlockedProgram", "disk_write" )
				self:LaunchProgram( "password_check" )
			else
				self:LaunchProgram( "disk_write" )
			end
		else	
			self:SetMemory( "MenuMsg", TerminalR.Lang.NoDiskInsert )
			self:SetMemory( "MenuMsgAlpha", 255 )
			surface.PlaySound( "terminalr/false.wav" )
		end
	end
	
	local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.ButtonEjectDisk, "TrmR_Medium" )
	local EjectDisk = self:CreateMenuButton( "EjectDisk", "> " .. TerminalR.Lang.ButtonEjectDisk )
	EjectDisk:SetPos( W*0.05, H*0.25 )
	EjectDisk:SetSize( SW + 40 , SH + 10 )
	EjectDisk.DoClick = function( selfB )
		if ( self.Memory.DiskText ) then
			self:LaunchProgram( "disk_eject" )
		else
			self:SetMemory( "MenuMsg", "Нет диска" )
			self:SetMemory( "MenuMsgAlpha", 255 )
			surface.PlaySound( "terminalr/false.wav" )
		end
	end
	
	local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.ButtonProtectDisk, "TrmR_Medium" )
	local ProtectDisk = self:CreateMenuButton( "ProtectDisk", "> " .. TerminalR.Lang.ButtonProtectDisk )
	ProtectDisk:SetPos( W*0.05, H*0.3 )
	ProtectDisk:SetSize( SW + 40 , SH + 10 )
	ProtectDisk.DoClick = function( selfB )
		if ( self:GetMemory("DiskText") ) then
			if ( self:GetMemory("DiskPass") ) then
				self:SetMemory("BlockedProgram", "password_save" )
				self:LaunchProgram( "password_check" )
			else
				self:LaunchProgram( "password_save" )
			end
		else
			self:SetMemory( "MenuMsg", TerminalR.Lang.NoDiskInsert )
			self:SetMemory( "MenuMsgAlpha", 255 )
			surface.PlaySound( "terminalr/false.wav" )
		end
	end
	
	local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.ButtonShutDown, "TrmR_Medium" )
	local TurnOff = self:CreateMenuButton( "TurnOff", "> " .. TerminalR.Lang.ButtonShutDown )
	TurnOff:SetPos( W*0.05, H*0.925 )
	TurnOff:SetSize( SW + 40 , SH + 10 )
	TurnOff.DoClick = function( selfB )
		self:TurnOff()
		self:Remove()
	end

	local SW, SH = TerminalRGetTextSize( "> " .. "Игры", "TrmR_Medium" )
	local Settings = self:CreateMenuButton( "games", "> " .. "Игры" )
	Settings:SetPos( W*0.05, H*0.35 )
	Settings:SetSize( SW + 40 , SH + 10 )
	Settings.DoClick = function( selfB )
		self:LaunchProgram( "games" )
	end

	local SW, SH = TerminalRGetTextSize( "> " .. "Настройки", "TrmR_Medium" )
	local Settings = self:CreateMenuButton( "Settings", "> " .. "Настройки" )
	Settings:SetPos( W*0.05, H*0.4 )
	Settings:SetSize( SW + 40 , SH + 10 )
	Settings.DoClick = function( selfB )
		self:LaunchProgram( "colorsettings" )
	end
	
	if ( self:GetMemory( "HackModule" )  ) then
		local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.HackProgram, "TrmR_Medium" )
		local Hack = self:CreateMenuButton( "Hack"  )
		Hack:SetPos( W*0.05, H*0.5 )
		Hack:SetSize( SW + 40, SH + 10 )
		Hack.Paint = function( selfB, w, h )
			draw.SimpleText( "> " .. TerminalR.Lang.HackProgram, "TrmR_Medium", 20, 5 + math.random( -H*0.005, H*0.005 ), Color( math.random(0, 255), math.random(0, 255), math.random(0, 255) ), 0, 0 )
			draw.SimpleText( "> " .. TerminalR.Lang.HackProgram, "TrmR_Medium", 20, 5, Color( math.random(0, 255), math.random(0, 255), math.random(0, 255) ), 0, 0 )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 0, selfB.Alpha ) )
		end
		Hack.DoClick = function( selfB )
			if ( self:GetMemory( "HackProtection" ) ) then
				if ( self:GetMemory( "HackProtection" ) > CurTime() ) then
					self:SetMemory( "MenuMsg", TerminalR.Lang.HackProtection )
					self:SetMemory( "MenuMsgAlpha", 255 )
					surface.PlaySound( "terminalr/false.wav" )
					return
				end
			end
			self:LaunchProgram( "hacking" )
		end
		
		local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.HackEject, "TrmR_Medium" )
		local EjectHM = self:CreateMenuButton( "EjectHack" )
		EjectHM:SetPos( W*0.05, H*0.55 )
		EjectHM:SetSize( SW + 40, SH + 10 )
		EjectHM.Paint = function( selfB, w, h )
			draw.SimpleText( "> " .. TerminalR.Lang.HackEject, "TrmR_Medium", 20, 5 + math.random( -H*0.005, H*0.005 ), Color( math.random(0, 255), math.random(0, 255), math.random(0, 255) ), 0, 0 )
			draw.SimpleText( "> " .. TerminalR.Lang.HackEject, "TrmR_Medium", 20, 5, Color( math.random(0, 255), math.random(0, 255), math.random(0, 255) ), 0, 0 )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 0, selfB.Alpha ) )
		end
		EjectHM.DoClick = function( selfB )
			self:SetMemory( "HackModule", nil )
			net.Start( "Net_TerminalR:EjectHackModule")
				net.WriteInt( self.EntIndex, 32 )
			net.SendToServer()
			self:Remove()
		end
	end
	
end

TerminalR.Programs["menu"].Paint = function( self, w, h )
	local cr, cg, cb, ca = self:GetMemory("TerminalColor").r, self:GetMemory("TerminalColor").g, self:GetMemory("TerminalColor").b, math.random(230, 255)
	local cclr = Color(math.random(cr - 35, cr), math.random(cg - 35, cg), math.random(cb - 35, cb), ca)
	local randBlack = math.random(0, 3)
	draw.RoundedBox( 0, 0, 0, w, h, Color( randBlack, randBlack, randBlack, 255) )
	draw.RoundedBox( 0, w*0.05, h*0.12, w*0.38, h*0.002, cclr )
	draw.SimpleText( TerminalR.Lang.TerminalMenu, "TrmR_Title", w*0.05, h*0.025, cclr, 0, 0 )
	draw.SimpleText( self:GetMemory("MenuMsg"), "TrmR_Large", w*0.5, h*0.925, cclr, 1, 0 )
end

TerminalR.Programs["menu"].OnRemove = function( self )
	self:RemoveAllMemoryNamed( { "MenuMsg", "MenuMsgAlpha" } )
end

TerminalR.Programs["menu"].Think = function( self, dt )
	if ( self:GetMemory("MenuMsgAlpha") > 0 ) then
		self:SetMemory("MenuMsgAlpha", self:GetMemory("MenuMsgAlpha") - (125*dt) ) 
	end
	
end

TerminalR.Programs["menu"].Launch = function( self, dt )
	self:RemoveParent()
end