gl.setup(1920, 340)

-- Interval
local INTERVAL = 0.5

local font = resource.load_font("font.ttf")
local font2 = resource.load_font("font2.ttf")
local logo = resource.load_image("logo.png")

-- Initial position of the logo
local lw = 212			-- Logo width
local x2 = 1915			-- Logo start position right X coordinate
local x1 = x2 - lw		-- Logo start position left X coordinate
local hmin = 5			-- Min amount of pixels to scroll at once
local hmax = lw			-- Max amount of pixels to scroll at once
local hscroll = hmin		-- Amount of pixels to scroll
local hmotion = hscroll * -1	-- Move left
local slowdown = 0		-- Speed up

-- Initial postion of texts
local t1y = 2			-- Atari Invasion Y coordinate
local t1s = 200			-- Text size
local t2y = 170			-- Brew at Home Y coordinate
local t2s = 100			-- Text size
local vmotion = -5		-- Move up

local old = sys.now()

function node.render()
	gl.clear(0, 0, 0, 0)

	local now = sys.now()
	if now - old >= INTERVAL then
		x1 = x1 + hmotion
		x2 = x2 + hmotion
		old = now

		-- Reached left side
		if x1 <= 5 then
			x1 = 5
			x2 = x1 + lw
			-- In-/Decrease horizontal motion
			if slowdown == 0 then
				hmotion = hmotion * -2
				if hmotion < 0 and hmotion < hmax * -1 then
					slowdown = 1
					hmotion = hmax * -1
				end
				if hmotion > 0 and hmotion > hmax then
					slowdown = 1
					hmotion = hmax
				end
			else
				hmotion = hmotion / -2
				if hmotion < 0 and hmotion > -1 then
					slowdown = 0
					hmotion = hmin * -1
				end
				if hmotion > 0 and hmotion < hmin then
					slowdown = 0
					hmotion = hmin
				end
			end
			t1y = t1y + vmotion
			t2y = t2y + vmotion
		end
		-- Reached right side
		if x2 >= 1905 then
			x2 = 1905
			x1 = x2 - lw
			-- In-/Decrease horizontal motion
			if slowdown == 0 then
				hmotion = hmotion * -2
				if hmotion < 0 and hmotion < hmax * -1 then
					slowdown = 1
					hmotion = hmax * -1
				end
				if hmotion > 0 and hmotion > hmax then
					slowdown = 1
					hmotion = hmax
				end
			else
				hmotion = hmotion / -2
				if hmotion < 0 and hmotion > -1 then
					slowdown = 0
					hmotion = hmin * -1
				end
				if hmotion > 0 and hmotion < hmin then
					slowdown = 0
					hmotion = hmin
				end
			end
			t1y = t1y + vmotion
			t2y = t2y + vmotion
		end

		-- Moving text up
		if t1y < 0 - t1s then
			t1y = 300
		end
		if t2y < 0 - t1s then
			t2y = 300
		end

		-- Moving text down
--		if t1y >= 300 then
--			t1y = 0
--		end
--		if t2y >= 300 and t1y <= 152 then
--			t2y = 0
--		end
	end

	logo: draw( x1,20, x2,320, 1 )
	font: write( 10, t1y, "Atari Invasion 2017", t1s, 1,1,1,1 )
	font: write( 1180, t2y, "Brew at Home", t2s, 162,162,162,0.8 )
end
