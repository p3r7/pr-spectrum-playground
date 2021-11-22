-- pirate radio spectrum analyzer
--
--             |   |
--   | |       | | |   |   | |
-- | | | | |   | | | | |   | |     |
-- | | | | | | | | | | | | | | |   |
-- | | | | | | | | | | | | | | | | |
-- | | | | | | | | | | | | | | | | |


-- ------------------------------------------------------------------------
-- init

local fps = 10
local redraw_clock

local bar_updates_ps = 50
local update_bar_clock

function init()
  screen.aa(1)
  screen.line_width(1)

  -- we have 2 clocks (aka couroutines, i.e. // loops)
  -- they are very similar but serve different purpose

  -- one for controlling rate of screen redraw
  redraw_clock = clock.run(
    function()
      local step_s = 1 / fps
      while true do
        clock.sleep(step_s)
        redraw() -- <- here
      end
  end)

  -- the other for doing bar length computations, at a much higher rate
  update_bar_clock = clock.run(
    function()
      local step_s = 1 / bar_updates_ps
      while true do
        clock.sleep(step_s)
        update_bar() -- <- there
      end
  end)
end

function cleanup()
  clock.cancel(redraw_clock)
  clock.cancel(update_bar_clock)
end

function redraw()
  screen.clear()
  redraw_bar()
  screen.update()
end


-- ------------------------------------------------------------------------
-- drawing

-- bar origin point coordinates on screen
local x = 128/2 -- center column of the screen
local y = 64 -- bottom of the screen (last row)

-- bar "value", i.e. its length in pixels
local bar_v = 0

function redraw_bar()
  screen.level(15)
  screen.move(x, y)
  screen.line(x, y - bar_v)
  screen.stroke()
end

function update_bar()
  bar_v = bar_v + 1
  if bar_v > 64 then --  we're at the edge of the screen
    bar_v = 0       -- -> start back
  end
end
