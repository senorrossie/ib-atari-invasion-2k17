gl.setup(1920, 800)

local font = resource.load_font "font.ttf"
local fixed = resource.load_font "ffont.ttf"
local clipart = resource.load_image "item.jpg"

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

util.file_watch("gameinfo.txt", function(gameinfo)
    infolines = wrap(gameinfo, 60)
end)

util.file_watch("scores.txt", function(scoredata)
    scores = wrap(scoredata, 80)
end)

function node.render()
	gl.clear(0,0,0,0.8)

    util.draw_correct(clipart, 50,50, 370,290, 0.8)
	
	font: write( 5, 5, "Homebrew Game Compo", 40, 1,1,1,1 )

	-- Game Info Area: WRAP@60 characters
	font: write( 50, 310, "Game Information", 40, 255,255,0,1 )

	font: write( 50, 382, "Platform:", 30, 1,1,1,1 )
	font: write( 250, 382, infolines[2], 30, 1,1,1,1 )
	font: write( 50, 414, "Released:", 30, 1,1,1,1 )
	font: write( 250, 414, infolines[3], 30, 1,1,1,1 )
	font: write( 50, 446, "Author:", 30, 1,1,1,1 )
	font: write( 250, 446, infolines[4], 30, 1,1,1,1 )
	font: write( 50, 478, "Players:", 30, 1,1,1,1 )
	font: write( 250, 478, infolines[5], 30, 1,1,1,1 )
	font: write( 50, 510, "Controller:", 30, 1,1,1,1 )
	font: write( 250, 510, infolines[6], 30, 1,1,1,1 )
	font: write( 50, 542, "Extra's", 20, 255,255,0,1 )
	font: write( 50, 562, infolines[7], 18, 1,1,1,1 )

	-- Score Area: WRAP@60 characters
	font: write( 800, 5, infolines[1], 50, 255,255,0,1 )

	-- Score Details: WRAP@80 characters
	font: write( 800, 5, infolines[1], 50, 255,255,0,1 )
	y = 100
	for i, line in ipairs(scores) do
		local size = 30
		if i ~= 1 then
			player, score = line:match( "([^,]+),([^,]+)" )
			fixed: write( 800, y, player, size, 1,1,1,1 )
			fixed: write( 1600, y, score, size, 255,255,0,1 )
			y = y + size + 2
		end
	end
end
