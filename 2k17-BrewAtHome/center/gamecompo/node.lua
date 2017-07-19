gl.setup(1920, 800)

local interval = 60

util.auto_loader(_G)

function make_switcher(childs, interval)
    local next_switch = 0
    local child
    local function next_child()
        child = childs.next()
        next_switch = sys.now() + interval
    end
    local function draw()
        if sys.now() > next_switch then
            next_child()
        end
        util.draw_correct(resource.render_child(child), 0, 0, WIDTH, HEIGHT)
    end
    return {
        draw = draw;
    }
end

local switcher = make_switcher(util.generator(function()
    local cycle = {}
    for child, updated in pairs(CHILDS) do
        table.insert(cycle, child)
    end
    return cycle
end), interval)


function node.render()
    gl.clear(0, 0, 0, 0.1)
    switcher.draw()
end
