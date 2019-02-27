-- Creating an exe: https://www.youtube.com/watch?v=yLTYsW_Ab8k
-- projectiles: https://github.com/mrinalpande/Space-Invaders/blob/Initail/main.lua
-- spawn enemies: https://youtu.be/FeLljv5clnw?t=462

Player = require "Player"
Manager = require "gameManager"
Enemy = require "Enemy"

function love.load(arg)
end

-- Updates the external scripts
function love.update(dt)
  Player:update(dt)
  Enemy:update(dt)
  if jumpRow == true then
    Enemy:update(dt)
    jumpRow = false;
  end
  Manager:update(dt)
  Manager:debug_mode()
end

-- Draws visuals
function love.draw()
  Manager:draw()
  Enemy:draw()
  Player:draw()
  Manager:debug_mode()
end

-- Closes down the game window when pressing ESC
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
