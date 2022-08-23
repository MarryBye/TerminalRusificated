TerminalR.Programs["snake"] = {}

TerminalR.Programs["snake"].Init = function( self )

	W, H = ScrW(), ScrH()

	self.Score = 0
	self.arenaSizeX, self.arenaSizeY = W * 0.5, H * 0.5
	self.arenaPosX, self.arenaPosY = W * 0.5 - self.arenaSizeX * 0.5, H * 0.5 - self.arenaSizeY * 0.5
	self.snakeTales = {}
	self.snakePosX, self.snakePosY = W * 0.5 - self.arenaSizeX * 0.5, H * 0.5 - self.arenaSizeY * 0.5
	self.snakeTales[1] = { x = self.snakePosX, y = self.snakePosY }
	self.snakeDirection = 'Right'
	self.snakeStep = 15
	self.snakeCooldown = 0.05
	self.snakeNextMove = CurTime() + self.snakeCooldown
	self.snakeNextChangeDir = CurTime() + self.snakeCooldown

	self.fruitSpawned = false
	self.fruitPosX, self.fruitPosY = 0, 0

	local SW, SH = TerminalRGetTextSize( "> " .. TerminalR.Lang.Cancel, "TrmR_Medium" )
	local snake = self:CreateMenuButton( "snake", "> " .. TerminalR.Lang.Cancel )
	snake:SetPos( ScrW()*0.01, ScrH()*0.925 )
	snake:SetSize( SW + 40, SH + 10 )
	snake.DoClick = function( selfB )
		self:RemoveParent()
		self:LaunchProgram( "menu" )
	end

end

TerminalR.Programs["snake"].Paint = function( self )

	--print(self.snakePosX .. ' ' .. self.snakePosY)
	--print(self.arenaPosX .. ' ' .. self.arenaPosY .. ' | ' .. W * 0.5 + self.arenaPosX - 15 .. ' ' .. H * 0.5 + self.arenaPosY - 15)
	--print(self.snakePosX >= self.fruitPosX - 7 and self.snakePosX <= self.fruitPosX)
	--print(self.snakePosY >= self.fruitPosY - 7 and self.snakePosY<= self.fruitPosY)
	--print('=======================================')

	local cr, cg, cb, ca = self:GetMemory("TerminalColor").r, self:GetMemory("TerminalColor").g, self:GetMemory("TerminalColor").b, math.random(230, 255)
	local cclr = Color(math.random(cr - 35, cr), math.random(cg - 35, cg), math.random(cb - 35, cb), ca)
	local testclr = HSVToColor(CurTime()% 6*60,1,1)
	
	draw.RoundedBox(0, self.arenaPosX - 3, self.arenaPosY - 3, self.arenaSizeX + 6, self.arenaSizeY + 6, cclr)
	draw.RoundedBox(0, self.arenaPosX, self.arenaPosY, self.arenaSizeX, self.arenaSizeY, Color(35, 35, 35, 255))

	draw.RoundedBox(3, self.fruitPosX, self.fruitPosY, 15, 15, Color(testclr.r, testclr.g, testclr.b, 255))

	for k,v in ipairs(self.snakeTales) do

		if k == 1 then 
			
			draw.RoundedBox(3, v.x, v.y, 15, 15, Color(cclr.r, 0, 0, 255))

		else 

			draw.RoundedBox(3, v.x, v.y, 15, 15, cclr)

		end

	end

	draw.DrawText(self.Score, "TrmR_Medium", W*0.5, H*0.94, cclr, 1, 1)

end

TerminalR.Programs["snake"].Think = function( self )

	if ( CurTime() > self.snakeNextMove ) then

		for i = #self.snakeTales, 2, -1 do 
						
			self.snakeTales[i] = self.snakeTales[i - 1]
 
		end

		self.snakeTales[1] = { x = self.snakePosX, y = self.snakePosY }

		for i = #self.snakeTales, 3, -1 do  

			if self.snakeTales[1].x == self.snakeTales[i].x and self.snakeTales[1].y == self.snakeTales[i].y then 

				if self:GetMemory('SnakeRecord') < self.Score then

					LocalPlayer():EmitSound( "terminalr/passgood.wav" ) 
					self:SetMemory('SnakeRecord', self.Score)

				else

					LocalPlayer():EmitSound( "terminalr/passbad.wav" )

				end

				self.snakePosX, self.snakePosY = self.arenaPosX, self.arenaPosY
				self.Score = 0
				self.snakeDirection = 'Right'
				self.snakeTales = {}
				self.snakeTales[1] = { x = W * 0.5 - self.arenaSizeX * 0.5, y = H * 0.5 - self.arenaSizeY * 0.5 }
				self.snakeNextMove = CurTime() + self.snakeCooldown
				self.snakeNextChangeDir = CurTime() + self.snakeCooldown
				self.fruitSpawned = false 

				break

			end

		end

		if self.snakeDirection == 'Right' then

			self.snakePosX = self.snakePosX + self.snakeStep
			self.snakeTales[1].x = self.snakePosX

		elseif self.snakeDirection == 'Left' then

			self.snakePosX = self.snakePosX - self.snakeStep
			self.snakeTales[1].x = self.snakePosX

		elseif self.snakeDirection == 'Up' then

			self.snakePosY = self.snakePosY - self.snakeStep
			self.snakeTales[1].y = self.snakePosY

		elseif self.snakeDirection == 'Down' then 

			self.snakePosY = self.snakePosY + self.snakeStep
			self.snakeTales[1].y = self.snakePosY

		end

		self.snakeNextMove = CurTime() + self.snakeCooldown

	end

	if ( CurTime() > self.snakeNextChangeDir ) then

		if ( input.IsKeyDown( 91 ) ) then

			self.snakeDirection = 'Right'

		elseif ( input.IsKeyDown( 89 ) ) then

			self.snakeDirection = 'Left'
		
		elseif ( input.IsKeyDown( 90 ) ) then

			self.snakeDirection = 'Down'
		
		elseif ( input.IsKeyDown( 88 ) ) then

			self.snakeDirection = 'Up'

		end

		self.snakeNextChangeDir = CurTime() + self.snakeCooldown

	end

	if not self.fruitSpawned then 

		self.fruitPosX, self.fruitPosY = math.random(self.arenaPosX, W * 0.5 + (W * 0.5 - self.arenaSizeX * 0.5) - 15), math.random(self.arenaPosY, H * 0.5 + (H * 0.5 - self.arenaSizeY * 0.5) - 15)

		self.fruitSpawned = true

	end

	if self.snakePosX >= self.fruitPosX - 15 and self.snakePosX <= self.fruitPosX + 15 and self.snakePosY >= self.fruitPosY - 15 and self.snakePosY <= self.fruitPosY + 15 then 

		LocalPlayer():EmitSound("terminalr/char/" .. math.random( 1, 5 ) .. ".wav" )

		self.Score = self.Score + 1
		self.snakeTales[#self.snakeTales + 1] = { x = 0, y = 0 }
		self.fruitSpawned = false 

	end

	if (self.snakePosX > W * 0.5 + self.arenaPosX - 15) or (self.snakePosX < self.arenaPosX) or (self.snakePosY > H * 0.5 + self.arenaPosY - 15) or (self.snakePosY < self.arenaPosY) then

		if self:GetMemory('SnakeRecord') < self.Score then

			LocalPlayer():EmitSound( "terminalr/passgood.wav" ) 
			self:SetMemory('SnakeRecord', self.Score)

		else

			LocalPlayer():EmitSound( "terminalr/passbad.wav" )

		end

		self.snakePosX, self.snakePosY = self.arenaPosX, self.arenaPosY
		self.Score = 0
		self.snakeDirection = 'Right'
		self.snakeTales = {}
		self.snakeTales[1] = { x = W * 0.5 - self.arenaSizeX * 0.5, y = H * 0.5 - self.arenaSizeY * 0.5 }
		self.snakeNextMove = CurTime() + self.snakeCooldown
		self.snakeNextChangeDir = CurTime() + self.snakeCooldown
		self.fruitSpawned = false 
	
	end

end

TerminalR.Programs["snake"].OnRemove = function( self )

end