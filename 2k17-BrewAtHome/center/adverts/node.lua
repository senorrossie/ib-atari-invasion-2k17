-- at which intervals should the screen switch to the
-- next image?
local INTERVAL = 35

-- enough time to load next image
local SWITCH_DELAY = 1

-- transition time in seconds.
-- set it to 0 switching instantaneously
local SWITCH_TIME = 5.0


-- Media directory. Set to '' to have your
-- images in the current directory.
local MEDIA_DIRECTORY = 'images'

local ALL_CONTENTS, ALL_CHILDS = node.make_nested()

assert(SWITCH_TIME + SWITCH_DELAY < INTERVAL,
    "INTERVAL must be longer than SWITCH_DELAY + SWITCHTIME")

local function alphanumsort(o)
    local function padnum(d) return ("%03d%s"):format(#d, d) end
    table.sort(o, function(a,b)
        return tostring(a):gsub("%d+",padnum) < tostring(b):gsub("%d+",padnum)
    end)
    return o
end

local pictures = util.generator(function()
    local files = {}
    for name, _ in pairs(ALL_CONTENTS[MEDIA_DIRECTORY]) do
        if name:match(".*jpg") or name:match(".*png") then
            files[#files+1] = name
        end
    end
    return alphanumsort(files) -- sort files by filename
end)
node.event("content_remove", function(filename)
    pictures:remove(filename)
end)

local current_image = resource.create_colored_texture(0,0,0,0)
local fade_start = 0

local function next_image()
    local next_image_name = pictures.next()
    print("now loading " .. next_image_name)
    last_image = current_image
    current_image = resource.load_image(next_image_name)
    fade_start = sys.now()
end

gl.setup(1920, 800)

function node.render()
	gl.clear(0,0,0,0.8)

    local delta = sys.now() - fade_start - SWITCH_DELAY
    if last_image and delta < 0 then
        util.draw_correct(last_image, 0, 0, WIDTH, HEIGHT)
    elseif last_image and delta < SWITCH_TIME then
        local progress = delta / SWITCH_TIME
        util.draw_correct(last_image, 0, 0, WIDTH, HEIGHT, 1 - progress)
        util.draw_correct(current_image, 0, 0, WIDTH, HEIGHT, progress)
    else
        if last_image then
            last_image:dispose()
            last_image = nil
        end
        util.draw_correct(current_image, 0, 0, WIDTH, HEIGHT)
    end
end

util.set_interval(INTERVAL, next_image)
