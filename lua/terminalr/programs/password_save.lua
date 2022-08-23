TerminalR.Programs["password_save"] = {}

TerminalR.Programs["password_save"].Init = function( self )
	local W, H = ScrW(), ScrH()
	self:SetMemory( "Password", "" )
	
	local ParentTable = self:GetParentTable()
	ParentTable["TE"] = vgui.Create( "DTextEntry", self )
	ParentTable["TE"]:SetText( "" )
	ParentTable["TE"].NextTyping = CurTime() + 1
	ParentTable["TE"].Paint = function( TE )
	end
	ParentTable["TE"].OnLoseFocus = function( TE )
		TE:RequestFocus()
	end
	ParentTable["TE"].AllowInput = function( selfD, stringValue )
		local Password = self:GetMemory( "Password" ) .. stringValue
		if ( #Password > 16 ) then return end
		self:SetMemory( "Password", Password )
		LocalPlayer():EmitSound("terminalr/char/" .. math.random( 1, 5 ) .. ".wav" )
		return true
	end
	ParentTable["TE"].Think = function( selfD )
		if ( CurTime() > selfD.NextTyping ) then
			if ( input.IsKeyDown( 66 ) ) then
				local Password = self:GetMemory( "Password" )
				if ( #Password <= 0 ) then return end
				local NewText = string.sub( Password, 0, #Password -1 )
				self:SetMemory( "Password", NewText)
				LocalPlayer():EmitSound("terminalr/char/" .. math.random( 1, 5 ) .. ".wav" )
				selfD.NextTyping = CurTime() + 0.1
			elseif ( input.IsKeyDown( 64 ) ) then
				local Password = self:GetMemory( "Password" )
				if ( Password == "" ) then
					self:RemoveAllMemoryNamed( { "DiskPass", "Password" } )
					self:LaunchProgram( "menu" )
				else
					self:SetMemory( "DiskPass", self:GetMemory( "Password" ) )
					self:RemoveMemory( "Password" )
					self:LaunchProgram( "menu" )
				end
			end
		end
	end
	ParentTable["TE"]:RequestFocus()
	
	local SW, SH = TerminalRGetTextSize( TerminalR.Lang.Cancel, "TrmR_Medium" )
	local Cancel = self:CreateMenuButton( "Cancel", TerminalR.Lang.Cancel )
	Cancel:SetPos( W*0.01, H*0.94 )
	Cancel:SetSize( SW + 40, SH + 10 )
	Cancel.DoClick = function( selfB )
		self:RemoveAllMemoryNamed( { "Password" } )
		self:LaunchProgram( "menu" )
	end
	
end

TerminalR.Programs["password_save"].Paint = function( self, w, h )
	local cr, cg, cb, ca = self:GetMemory("TerminalColor").r, self:GetMemory("TerminalColor").g, self:GetMemory("TerminalColor").b, math.random(230, 255)
	local cclr = Color(math.random(cr - 35, cr), math.random(cg - 35, cg), math.random(cb - 35, cb), ca)
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 255) )
	draw.SimpleText( "Пароль", "TrmR_Title", w*0.5, h*0.35, cclr, 1, 0 )
	draw.SimpleText( "Введите пароль", "TrmR_Small", w*0.5, h*0.45, Color( math.random(210,255), math.random(210,255), math.random(210,255) ), 1, 0 )
	draw.SimpleText( "> " .. tostring(self:GetMemory("Password")) .. " <", "TrmR_Medium", w*0.5, h*0.55, cclr, 1, 0 )
end

TerminalR.Programs["password_save"].Think = function( self, dt )

end

TerminalR.Programs["password_save"].Launch = function( self )
	self:RemoveMemory( "Password" )
	self:RemoveParent()
end