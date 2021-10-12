# tt.lua
Text triggers for lua. Lets you trigger a function when a certain sequence of characters has been pressed.

# Basic usage
First load it
```lua
tt = require "tt"
```
Next, You must update the buffer. This function should be placed in a keypress callback, Passing it the key that was pressed.
```lua
tt:updateBuffer(key)
```
And with just those 2 lines, It will work. However for some functionality, tt.lua requires that you call the updateTimer function every frame, And pass delta time to it.
```lua
tt:updateTimer(dt)
```
The functionality in question is buffer timeout, Which will automatically clear the buffer after a timeout. And 'wait for timeout', Which will wait for the buffer to timeout before checking for triggers. This is necessary if you want to have multiple triggers that start with the same characers.

Next you can create your first trigger
```lua
tt:new("hello", print, "Hello world!")
```
Now if you run your program and type "hello" it should print out "Hello world!"

# Available functions

```lua 
tt:new(triggerString, triggerFunction, ...)
```
Creates a new trigger
* triggerString: The trigger string for this trigger
* triggerFunction: The function it should call
* ...: Any number of arguments the trigger function will be called with.
##
```lua
tt:remove(triggerString)
```
Removes a trigger
* triggerString: The trigger to remove
##
```lua
tt:updateBuffer(key)
```
Updates the buffer
* key: The string to add to the buffer, Should usually be the key that was pressed.
##
```lua
tt:updateTimer(dt)
```
Updates the internal timer, Optional, But necessary for buffer timeout & wait for timeout to function.
* dt: Delta time, Time passed since the last frame in seconds.
##
```lua
tt:setBufferLength(length)
```
Sets the maximum length of the buffer.
* length: Length of the buffer, The default is `32`.
##
```lua
tt:setBufferTimeout(time)
```
Sets the buffer timeout
* time: timeout in seconds. The default is `1`
##
```lua
tt:setWaitForTimeout(wait)
```
Sets whether tt.lua will wait for the buffer to timeout before checking for triggers
* wait: Boolean. The default is `false`
##
```lua
tt:setInputFilter(filter)
```
Sets an input filter function. The filter function is called before calling any trigger functions, If it returns false (or nil) the trigger function will not be called. Can be useful when you want to ignore input under certain circumstances.
##
```lua
tt:clearBuffer()
```
Clears the buffer
##
```lua
tt:getBuffer()
```
Returns the buffer. Could come in handy when debugging
##
```lua
tt:checkTriggers()
```
Checks for triggers in the buffer. This is called internally, So you should never have to use it, but its available to you anway.

# What's this useful for?
Remember cheat codes in games? Those were the days. Well now with a little help from tt.lua you can bring those back.
```lua
tt:new("upupdowndownleftrightleftrightba", activate_cheat)
```

# Demo
The demo is made for [löve](https://love2d.org)
Its quite simple so here's the whole code:
```lua
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
```
