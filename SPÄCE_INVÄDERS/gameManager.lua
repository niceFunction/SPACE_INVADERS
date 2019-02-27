Player = require  "Player"
Enemy = require "Enemy"

-- Necessary that this part of the script needs
playerLifeController = {}
playerLifeController.Lives = {}

-- Variables that does different things inside the game
Background = love.graphics.newImage("Background.png")
Border = love.graphics.newImage("Border.png")
Manager = {}
Manager.posX = love.graphics.getWidth() / 2
Manager.posY = love.graphics.getHeight() / 2
Manager.fontColor = {0 / 255, 0 / 255, 0 / 255, 1}
Manager.scoreFont = love.graphics.newFont("Square.ttf", 32)
Manager.fontPosX = 100
Manager.fontPosY = 610
Manager.highScore = 0
Manager.gameOverSprite = love.graphics.newImage("GameOver.png")
Manager.youWinSprite = love.graphics.newImage("youWin.png")
Manager.gameOverOriginX = Manager.gameOverSprite:getWidth() / 2
Manager.gameOverOriginY = Manager.gameOverSprite:getHeight() / 2
Manager.youWinOriginX = Manager.youWinSprite:getWidth() / 2
Manager.youWinOriginY = Manager.youWinSprite:getHeight() / 2
Manager.logoSprite = love.graphics.newImage("SPACEINVADERS_logo.png")
Manager.logoPosX = Manager.logoSprite:getWidth()
Manager.logoPosY = 200
Manager.logoOriginX = Manager.logoSprite:getWidth() * 0.5
Manager.logoOriginY = Manager.logoSprite:getHeight() * 0.5
Manager.controlsSprite = love.graphics.newImage("SPACEINVADERS_controls.png")
Manager.controlsPosX = love.graphics.getWidth() - 780
Manager.controlsPosY = love.graphics.getHeight() - 130
--Manager.controlsOriginX = Manager.controlsSprite:getWidth() * 0.5
--Manager.controlsOriginY = Manager.controlsSprite:getHeight() * 0.5

-- Spawn life icon variables
function playerLifeController.spawnLife(posX, posY)
  Life = {}
  Life.playerLifeSprite = love.graphics.newImage("playerLifeIcon.png")
  Life.posX = posX - 30
  Life.posY = 610
  Life.Width = Life.playerLifeSprite:getWidth()
  Life.Height = Life.playerLifeSprite:getHeight()

  table.insert(playerLifeController.Lives, Life)
end
-- Spawns 2 life icons
heartCounter = 0
for i = 1, 2 do
  playerLifeController.spawnLife(i * 45)
  heartCounter = heartCounter + 1
end

-- Shows player/enemy variables in a corner for "debugging"
function Manager:debug_mode()
  if love.keyboard.isDown("c") then
    -- Shows Origin On Player
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", Player.posX, Player.posY, 4, 4)
    love.graphics.setColor(1, 1, 1, 1)

    -- Shows variables related to the player
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 5, 10, 145, 130)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Player X: " ..Player.posX, 10, 10)
    love.graphics.print("Player Y: " ..Player.posY, 10, 25)
    love.graphics.print("Player W: " ..Player.Sprite:getWidth(), 10, 40)
    love.graphics.print("Player H: " ..Player.Sprite:getHeight(), 10, 55)
    love.graphics.print("Player Fire Timer: "..string.format(
                        "%.1f", Player.bulletCooldown), 10, 70)
    love.graphics.print("Player.isAlive: "..string.format(
                        "%s", Player.isAlive), 10, 85)

    -- Shows variables related to the enemy
    love.graphics.print("Enemy Speed: "..string.format(
                        "%.1f", Enemy.Speed), 10, 110)
    love.graphics.print("Enemy Fire Timer: "..string.format(
                        "%.1f", bulletSpawnTimer), 10, 125)
  end
end

-- Checks enemy to player projectiles
function enemyCheckCollisions(enemies, bullets)
  for i, e in ipairs(enemies) do
    for j,b in ipairs(bullets) do
      if b.posY <= e.posY + e.Height and
         b.posX > e.posX and b.posX < e.posX + e.Width then
        print("REMOVED PLAYER BULLET")
        Enemy.deathSound:setVolume(0.4)
        Enemy.deathSound:play()
        print("HIT ENEMY")
        -- Removes enemies and player projetiles
        Manager.highScore = Manager.highScore + 10
        table.remove(enemies, i)
        table.remove(Player.Bullets, j)
      end
    end
  end
end

-- Checks player to enemy projectiles
function playerCheckCollisions(Player, enemyBullets)
local playerTop = Player.posY - Player.Height * 0.5
local playerLeft = Player.posX - Player.Width * 0.5
local playerRight = Player.posX + Player.Width * 0.5
  for i, b in ipairs(enemyBullets) do
    local bulletBottom = b.posY + b.Height
    local bulletLeft = b.posX
    local bulletRight = b.posX + b.Width
    if Player.isAlive then
      if bulletBottom >= playerTop and bulletLeft <= playerRight and
         bulletRight >= playerLeft then
           -- Decrease player health - 1
           table.remove(Enemy.enemyBullets, i)
           table.remove(playerLifeController.Lives, heartCounter)
           heartCounter = heartCounter - 1
      -- If health is 0, remove all enemies and enemy projectiles and shows
      -- show Game Over
      elseif heartCounter == 0 then
        -- Clear enemy and enemy projectiles tables
        enemiesController.enemies = {}
        Enemy.enemyBullets = {}
        gameOver = true
      end
    end
  end
end

-- Updates the "debug mode"
function Manager:update(dt)
  Manager:debug_mode()
end

function Manager:draw()
  -- Draws the background
  love.graphics.draw(Background, 0, 0)
  love.graphics.draw(Border, 0, 595)
  love.graphics.setFont(Manager.scoreFont, 24)
  love.graphics.print("HI: "..self.highScore, self.fontPosX, self.fontPosY)
  -- Draws the life icon sprite
  for _, l in pairs(playerLifeController.Lives) do
    love.graphics.draw(Life.playerLifeSprite,
                       l.posX,
                       l.posY,
                       0, 1, 1)
  end
  -- Draws a game over sprite if the player loses
  if gameOver then
    love.graphics.draw(Manager.gameOverSprite,
                       Manager.posX,
                       Manager.posY,
                       0, 1, 1,
                       Manager.gameOverOriginX,
                       Manager.gameOverOriginY)
  -- Draws a you win sprite if the player destroys all enemies
  elseif gameWin then
    love.graphics.draw(Manager.youWinSprite,
                       Manager.posX,
                       Manager.posY,
                       0, 1, 1,
                       Manager.youWinOriginX,
                       Manager.youWinOriginY)
  end
  -- Draws the "debug mode"
  Manager:debug_mode()
end

return Manager
