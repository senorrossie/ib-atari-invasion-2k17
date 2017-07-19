gl.setup(1920, 800)

local font = resource.load_font "font.ttf"
local lines = {}

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

util.file_watch("competition.txt", function(compo)
    desclines = wrap(compo, 80)
end)
util.file_watch("highscores.txt", function(scores)
    highscores = wrap(scores, 60)
end)

function node.render()
	gl.clear(0,0,0,0.8)

	font: write( 5, 5, "Homebrew Game Competition", 40, 1,1,1,1 )

	-- High Score Area: WRAP@30 characters
	font: write( 10, 50, "High Scores", 40, 255,255,0,1 )
    y = 100
	for i, line in ipairs(highscores) do
		game, player, score = line:match( "([^,]+),([^,]+),([^,]+)" )
		local size = 30
		font: write( 10, y, game, size, 0,255,0,1 )
		y = y + size + 2

		font: write( 15, y, player, size - 5, 1,1,1,1 )
		font: write( 600, y, score, size - 5, 1,1,1,1 )
		y = y + size + 10
	end

	-- Information: WRAP@80 characters
	font: write( 800, 5, "I N F O R M A T I E", 50, 255,255,0,1 )
	y = 100
	for i, line in ipairs(desclines) do
		local size = 30
		font: write( 800, y, line, size, 1,1,1,1 )
		y = y + size + 2
	end
end
