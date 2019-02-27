-- Necessary variables that this script needs
bulletSpawnTimer = 0.5
enemy = {}
JumpRow = false
enemiesController = {}
enemiesController.enemies = {}
enemyBulletSprite = love.graphics.newImage("enemyProjectile.png")
-- Function used to check the length of enemies in their table
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- Table of enemies with different values and variables
function enemiesController.spawnEnemy(posX, posY)
  Enemy = {}
  Enemy.Sprite = love.graphics.newImage("Enemy.png")
  Enemy.posX = posX
  Enemy.posY = posY
  Enemy.Width = Enemy.Sprite:getWidth()
  Enemy.Height = Enemy.Sprite:getHeight()
  Enemy.originX = Enemy.Sprite:getWidth() / 2
  Enemy.originY = Enemy.Sprite:getHeight() / 2
  Enemy.deathSound = love.audio.newSource("enemyExplosion.wav", "static")
  Enemy.enemyLaserSound = love.audio.newSource("enemyLaserSound.wav", "static")
  Enemy.enemyBullets = {}
  Enemy.Speed = 40
  Enemy.dirX = 1

  -- Adds enemies to enemiesController table
  table.insert(enemiesController.enemies, Enemy)
end

-- Enemies projectile function
function enemyFire()
    Enemy.enemyLaserSound:setVolume(0.2)
    Enemy.enemyLaserSound:play()
    local randomIndex = love.math.random(1, tablelength(enemiesController.enemies))
    Projectile = {}
    Projectile.posX = enemiesController.enemies[randomIndex].posX + Enemy.Width * 0.5
    Projectile.posY = enemiesController.enemies[randomIndex].posY + Enemy.Height
    Projectile.Width = enemyBulletSprite:getWidth()
    Projectile.Height = enemyBulletSprite:getHeight()
    Projectile.bulletSpeed = 10
    table.insert(Enemy.enemyBullets, Projectile)
end

-- Load a table of enemies, 11 units wide and 5 units high
for i = 0, 11 do
  for j = 0, 5 do
    enemiesController.spawnEnemy(i * 48, j * 28)
  end
end

function Enemy:update(dt)
  -- If all enemies has been destroyed
  if tablelength(enemiesController.enemies) == 0 then
    gameWin = true
    return
  end
  -- If enemies has managed to move below the screen
  for _,e in pairs(enemiesController.enemies) do
    if e.posY >= love.graphics.getHeight() then
      gameOver = true
    end

-- Enemy movement
    e.posX = e.posX + e.dirX * e.Speed * dt
    -- When enemy reach 750 on X, pop 30px down and change directon
    if e.posX >= 750 then
      JumpRow = true
    elseif e.posX <= 0 then
      JumpRow = true
    end
  end

  if( JumpRow == true ) then
    for _,e in pairs(enemiesController.enemies) do
      e.posY = e.posY + 30;
      e.dirX = e.dirX * -1
      e.Speed = e.Speed * 1.2
    end
    JumpRow = false;
  end

-- Making enemies fire their projetiles
  bulletSpawnTimer = bulletSpawnTimer - dt
  if bulletSpawnTimer <= 0 then
    enemyFire()
    local leftOver = math.abs(bulletSpawnTimer)
    bulletSpawnTimer = 0.5 - leftOver
  end

-- Removes enemies when they move below the screen
  for i, e in ipairs(enemiesController.enemies) do
    if e.posY >= 630 then
      table.remove(enemiesController.enemies, i)
      print("ENEMY REMOVED BELOW")
    end
  end

-- Removes enemy projectiles when they move below the screen
  for i,b in ipairs(Enemy.enemyBullets) do
    if b.posY >= 596 then
      print("E_BULLETS REMOVED BELOW SCREEN")
      table.remove(Enemy.enemyBullets, i)
    end
    b.posY = b.posY + b.bulletSpeed
  end
  -- Checks collisions between enemies and player projectiles
    enemyCheckCollisions(enemiesController.enemies, Player.Bullets)
end

function Enemy:draw()
  -- Draws the enemies
  for _,e in pairs(enemiesController.enemies) do
    love.graphics.setColor(210 / 255, 82 / 255, 127 / 255, 1)
    love.graphics.draw(self.Sprite,
                       e.posX,
                       e.posY,
                       0, 1, 1)
    love.graphics.setColor(1, 1, 1, 1)
  end

-- Draws enemy projetiles
  for _,b in pairs(Enemy.enemyBullets) do
    love.graphics.setColor(240 / 255, 255 / 255, 0 / 255, 1)
    love.graphics.draw(enemyBulletSprite,
                       b.posX,
                       b.posY,
                       0, 1, 1)
    love.graphics.setColor(1, 1, 1, 1)
  end
end

return Enemy
