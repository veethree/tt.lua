function love.load()
    -- Loading and configure tt
    tt = require "tt"
    tt:setWaitForTimeout(true)
    tt:setBufferTimeout(0.5)

    -- Defining some triggers
    tt:new("escape", love.event.push, "quit")
    tt:new("hello", print, "Hello world!")
    tt:new("mouse1mouse1", print, "Double click")
end

function love.update(dt)
    -- Updating the internal timer
    tt:update(dt)
end

function love.draw()
    -- Printing out the buffer
    love.graphics.print("Current buffer: "..tt:getBuffer(), 12, 12)
end

function love.keypressed(key)
    -- Updating the buffer
    tt:updateBuffer(key)
end

function love.textinput(t)
    -- In löve, You can also use 'textinput' to update the buffer.
    -- That way you can have triggers with capital letters, but a trigger like "escape"
    -- wont be triggered when the escape key is pressed. Only when you type it out.
    -- tt:updateBuffer(t)
end

function love.mousepressed(x, y, b)
    -- You could also update the buffer in mousepressed, For example to detect a double click
    -- Here i send the buffer a string like "mouse1" instead of just passing it "b" directly
    -- This is so the "double click" trigger doesnt also trigger if you just type "11" 
    local char = "mouse"..b
    tt:updateBuffer(char)
end