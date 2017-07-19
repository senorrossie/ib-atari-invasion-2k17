gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local image = resource.load_image "background.jpg"

function node.render()
	gl.clear(0,0,0,1)
	util.draw_correct(image, 0, 0, WIDTH, HEIGHT)

        -- *** HEADER [1920x300] ***
	local header = resource.render_child("header")
	header:draw(0,0, 1920,300)

        -- *** CENTER [1920x800] ***
	local center = resource.render_child("center")
	center:draw(0,225, 1920,1025)

        -- *** FOOTER [1920x55] ***
	local footer = resource.render_child("footer")
	footer:draw(0,1025, 1920,1080)
end
