Listener = Class{}

function Listener:init(self)
    self.listeners = {}
end

function Listener:addListener(event, callback)
	table.insert(self.listeners, {event = event, callback = callback})
end

function Listener:broadcastEvent(event, ...)
    for _, listener in pairs(self.listeners) do
        if event == listener.event then
            listener.callback(...)
        end
    end
end

function StartListening(listener)
    listener.listeners = {}

    listener.addListener = function(self, event, callback)
        table.insert(self.listeners, {event = event, callback = callback})
    end
    
    listener.broadcastEvent = function(self, event, ...)
        for _, listener in pairs(self.listeners) do
            if event == listener.event then
                listener.callback(...)
            end
        end
    end
end