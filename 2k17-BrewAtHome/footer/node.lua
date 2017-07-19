gl.setup(1920, 160)

local font = resource.load_font("font.ttf")

util.auto_loader(_G)

function feeder()
    return { line }
end

function trim(s)
    return s:match "^%s*(.-)%s*$"
end

util.file_watch("scrolldata.txt", function(data)
    line = trim(data)
end)

text = util.running_text{
    font = font;
    size = 90;
    speed = 60;
    color = {1, 0.5, 0.25, 1};
    generator = util.generator(feeder)
}

function node.render()
	gl.clear(0.36, 0.82, 0.36, 0.6) -- Transparent
	text:draw(HEIGHT-100)
end
