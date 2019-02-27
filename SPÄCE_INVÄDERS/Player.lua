-- Loads player related variables
Player = {}
Player.Sprite = love.graphics.newImage("Player.png")
Player.posX = love.graphics.getWidth() / 2
Player.posY = 575
Player.Width = Player.Sprite:getWidth()
Player.Height = Player.Sprite:getHeight()
Player.originX = Player.Sprite:getWidth() / 2
Player.originY = Player.Sprite:getHeight() / 2
Player.clampLeft = 25
Player.clampRight = 775
Player.moveSpeed = 10
Player.isAlive = true
Player.bulletSprite = love.graphics.newImage("playerProjectile.png")
Player.bulletSound = love.audio.newSource("laserShot.wav", "static")
Player.Bullets = {}
Player.bulletCooldown = 0.4
Player.fireBullet = function()
  -- Function that the player uses to fire projetiles
  if Player.bulletCooldown <= 0 then
    Player.bulletSound:setVolume(0.2)
    Player.bulletSound:play()
    Player.bulletCooldown = 0.4
    Projectile = {}
    Projectile.posX = Player.posX
    Projectile.posY = Player.posY
    Projectile.originX = Player.bulletSprite:getWidth() / 2
    Projectile.originY = Player.bulletSprite:getHeight() + 16
    Projectile.Speed = 10

    table.insert(Player.Bullets, Projectile)
  end
end

function Player:update(dt, self)
  -- Interval between fired projectiles
  -- Should the projectiles only be fired -->
  -- when they have hit an enemy or moved outside of the screen?
  Player.bulletCooldown = Player.bulletCooldown - 1 * dt
  -- Left and Right movement
  if love.keyboard.isDown("left") then
    Player.posX = Player.posX - Player.moveSpeed
  elseif love.keyboard.isDown("right") then
    Player.posX = Player.posX + Player.moveSpeed
  end

-- Stops the player when they have reached the edges of the screen
  if Player.posX <= Player.clampLeft then
    Player.posX = Player.clampLeft
  elseif Player.posX >= Player.clampRight then
    Player.posX = Player.clampRight
  end

-- Fires player projectiles
  if love.keyboard.isDown("space") then
    Player.fireBullet()
  end

-- Removes bullets above the screen
  for i,b in ipairs(Player.Bullets) do
    if b.posY < -20 then
      print("P_BULLET REMOVED ABOVE THE SCREEN")
      table.remove(Player.Bullets, i)
    end
    -- Player projectile movement
    b.posY = b.posY - b.Speed
  end
  playerCheckCollisions(Player, Enemy.enemyBullets)
end

function Player:draw(self)
  -- Draws the player sprite
  love.graphics.draw(Player.Sprite,
                     Player.posX,
                     Player.posY,
                     0, 1, 1,
                     Player.originX,
                     Player.originY)

  -- Draws a table of player projetiles
  for _, b in pairs(Player.Bullets) do
    love.graphics.draw(Player.bulletSprite,
                       b.posX,
                       b.posY,
                       0, 1, 1,
                       b.originX,
                       b.originY)
  end
end

return Player
