gl.setup(1920, 800)

local json = require "json"
local font = resource.load_font "font.ttf"
local chb, hwitems, switems, numitems, switch, item
local ci

util.file_watch("homebrew.json", function(content)
	print("***HOMEBREW*** Reloading homebrew.json")
	hbdata = json.decode(content)

	hwitems = #hbdata.hardware
	switems = #hbdata.software
	numitems = hwitems + switems
	if chb == nil then
		chb = 0
	end
	switch = 0
end)

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


--
-- *** Homebrew DATA ***
--

function next_item()
	local hbitem = {}

	if chb == nil then
		chb = 1
	elseif chb > numitems then
		chb = 1
	else
		chb = chb + 1
	end

	if chb <= hwitems then
	    hbitem = hbdata.hardware[chb]
		hbitem.type = "Hardware"
	else
	    hbitem = hbdata.software[chb - hwitems]
		hbitem.type = "Software"
    end
    print("[HOMEBREW] now loading " .. hbitem.name .. " of type " .. hbitem.type)
    print("  switch in: " .. hbitem.time .. "s")
	return hbitem
end
--
-- *** END OF: Homebrew DATA ***
--

--
-- *** Picture fader ***
--

-- * Settings
-- at which intervals should the screen switch to the
-- next image?
local INTERVAL = 5

-- enough time to load next image
local SWITCH_DELAY = 1

-- transition time in seconds.
-- set it to 0 switching instantaneously
local SWITCH_TIME = 1.0

function get_pictures(data)
    local files = {}
	local idx, id
	for idx, images in pairs(data) do
		for id, name in pairs(images) do
			-- print("Image: " .. name)
			files[#files+1] = name
		end
    end
    return files
end

local current_image = resource.create_colored_texture(0,0,0,0)
local fade_start = 0

local function next_image()
	if ci == nil then
		ci = 1
	elseif ci > numimages then
		ci = 1
	else
		ci = ci + 1
	end

    local next_image_name = pictures[ci]
    print("[HB - IMAGE] now loading " .. next_image_name)
	-- print("  switching to new item in: " .. switch - sys.now() .. "s")

    last_image = current_image
    current_image = resource.load_image(next_image_name)
    fade_start = sys.now()
end
--
-- *** END OF: Picture fader ***
--

----- DEBUG
-- for idx in ipairs(hbdata.hardware) do
    -- print("---- BEGIN: " .. idx .. " ----")
	-- pp( hbdata.hardware[idx] )
	-- print(" ---")
	-- print( "ID: " .. idx )
	-- print("* N A M E *: " .. hbdata.hardware[idx].name)
	-- print("Platform   : " .. hbdata.hardware[idx].platform)
	-- print("Released   : " .. hbdata.hardware[idx].released)
	-- print("Author     : " .. hbdata.hardware[idx].author)
	-- print("Players    : " .. hbdata.hardware[idx].players)
	-- print("Controller : " .. hbdata.hardware[idx].controller)
	-- print("Extras     : " .. hbdata.hardware[idx].extras)
	-- print("---- END ----")
-- end

function node.render()
	gl.clear(0,0,0,0.8)

	now = sys.now()
	local delta = switch - sys.now()
	if delta < 0 or item == nil then
		item = next_item()
		switch = sys.now() + item.time
		print("  switch at: " .. switch)
		pictures = get_pictures(item.images)
		numimages = #pictures
		last_image = current_image
		current_image = resource.load_image(pictures[1])
		fade_start = 0
	end

	local delta = now - fade_start - SWITCH_DELAY
	if last_image and delta < 0 then
		util.draw_correct(last_image, 50,50, 690,530, 0.8)
	elseif last_image and delta < SWITCH_TIME then
		local progress = delta / SWITCH_TIME
		util.draw_correct(last_image, 50,50, 690,530, 0.8 - progress)
		util.draw_correct(current_image, 50,50, 690,530, progress)
	else
		if last_image then
			last_image:dispose()
			last_image = nil
		end
		util.draw_correct(current_image, 50,50, 690,530, 0.8)
	end
	font: write( 5, 5, "Atari Homebrew " .. item.type, 40, 1,1,1,1 )

	-- Game Info Area: WRAP@30 characters
	font: write( 50, 510, "Information:", 40, 255,255,0,1 )

	font: write( 50, 582, "Platform:", 30, 1,1,1,1 )
	font: write( 250, 582, item.platform, 30, 1,1,1,1 )
	font: write( 50, 614, "Released:", 30, 1,1,1,1 )
	font: write( 250, 614, item.released, 30, 1,1,1,1 )
	font: write( 50, 646, "Author:", 30, 1,1,1,1 )
	font: write( 250, 646, item.author, 30, 1,1,1,1 )
	font: write( 50, 678, "Players:", 30, 1,1,1,1 )
	font: write( 250, 678, item.players, 30, 1,1,1,1 )
	font: write( 50, 710, "Controller:", 30, 1,1,1,1 )
	font: write( 250, 710, item.controller, 30, 1,1,1,1 )
	font: write( 50, 742, "Extra's", 20, 255,255,0,1 )
	font: write( 50, 762, item.extras, 18, 1,1,1,1 )

	-- Text Area: WRAP@60 characters
	font: write( 800, 5, item.name, 40, 255,255,0,1 )
	local desclines = wrap(item.description)
	y = 100
	for i, line in ipairs(desclines) do
		local size = 30
		font: write( 800, y, line, size, 1,1,1,1 )
		y = y + size + 2
	end

	font: write( 1850, 775, chb .. "/" .. numitems , 25, 162,162,162,0.8 )

end

-- Generate TICK for image selection
util.set_interval(INTERVAL, next_image)