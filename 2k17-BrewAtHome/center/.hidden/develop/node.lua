gl.setup(1920, 800)

-- at which intervals should we switch between items ?
local INTERVAL = 60

-- at which intervals should the screen switch to the
-- next image of the item on display?
local INTERVAL = 5

-- enough time to load next image
local SWITCH_DELAY = 1

-- transition time in seconds.
-- set it to 0 switching instantaneously
local SWITCH_TIME = 1.0

local ALL_IMAGES = node.make_nested()

assert(SWITCH_TIME + SWITCH_DELAY < INTERVAL,
    "INTERVAL must be longer than SWITCH_DELAY + SWITCHTIME")

local font = resource.load_font "font.ttf"
local lines = {}

-- Wrap long lines after 'limit' characters
function wrap(str, limit, indent, indent1)
    indent = indent or ""
    indent1 = indent1 or indent
    limit = limit or 72
    function wrap_parargraph(str)
        local here = 1-#indent1
        return indent1..str:gsub("(%s+)()(%S+)()", function(sp, st, word, fi)
            if fi-here > limit then
                here = st - #indent
                return "\n"..indent..word
            end
        end)
    end
    local splitted = {}
    for par in string.gmatch(str, "[^\n]+") do
        local wrapped = wrap_parargraph(par)
        for line in string.gmatch(wrapped, "[^\n]+") do
            splitted[#splitted + 1] = line
        end
    end
    return splitted
end

util.file_watch("playlist.txt", function(content)
    homebrew = wrap(content,999)
end)

function node.render()
	gl.clear(0,0,0,0.8)

	font: write( 5, 5, "Atari Homebrew", 40, 1,1,1,1 )

	-- Game Info Area: WRAP@30 characters
	font: write( 50, 510, "Game Information", 40, 255,255,0,1 )

	-- Text Area: WRAP@60 characters
	font: write( 800, 5, homebrew[1], 40, 255,255,0,1 )

	y = 100
	for i, line in ipairs(homebrew) do
		local size = 30
		font: write( 800, y, line, size, 1,1,1,1 )
		y = y + size + 2
	end
end