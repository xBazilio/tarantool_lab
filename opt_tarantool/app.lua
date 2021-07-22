box.cfg{}

fiber = require('fiber')

init = {}

init.space = function()
    if box.space.bigspace == nil then
        s = box.schema.space.create('bigspace')
        s:create_index('primary', {
            type = 'tree',
            parts = {{field = 1, type = 'unsigned'}}
        })

    end
end

init.data = function()
    if box.space.bigspace:count() >= 1000000 then
        print('Data is already here.')
        return
    end
    print('Inserting Data...')
    for i=1, 1000000 do
        box.space.bigspace:insert({i, generateString(10)})
    end
    print('Done!')
end

function generateString(numSymbols)
    s = ''
    for i=numSymbols,1,-1 do
        s = s .. string.char(math.random(33, 126))
    end
    return s
end

init.all = function()
    init.space()
    init.data()
end

init.all()

fiberObj1, fiberObj2 = nil, nil
function longFiber()
    local endTime = math.floor(fiber.time() + 600)
    local fiberId = fiber.self().id()
    print('In fiber: ' .. fiberId)

    while endTime > fiber.time() do
        fiber.testcancel()
        fiber.sleep(1)

        local timeLeft = endTime -  math.floor(fiber.time())
        if timeLeft % 10 == 0 then
            print('[' .. fiberId .. '] Time left: ' .. timeLeft)
        end
    end

end
fiberObj1 = fiber.create(longFiber)
fiberObj2 = fiber.create(longFiber)
