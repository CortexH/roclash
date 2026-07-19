local module = {}

module.__index = module

-- TODO: remover isso mais tarde e colocar um sistema apropriado.
local MIN_EVENT_DELAY = 0.0001

module.currentQueue = {}

local function isLess(a, b)
	if a.time ~= b.time then
		return a.time < b.time
	end

	return a.sequence < b.sequence
end

local function heapSwap(heap, a, b)
	heap[a], heap[b] = heap[b], heap[a]
end

local function heapUp(heap, index)
	while index > 1 do
		local parent = math.floor(index / 2)

		if not isLess(heap[index], heap[parent]) then
			break
		end

		heapSwap(heap, parent, index)
		index = parent
	end
end

local function heapDown(heap, index)
	local size = #heap

	while true do
		local left = index * 2
		local right = left + 1
		local smallest = index

		if left <= size and isLess(heap[left], heap[smallest]) then
			smallest = left
		end

		if right <= size and isLess(heap[right], heap[smallest]) then
			smallest = right
		end

		if smallest == index then
			break
		end

		heapSwap(heap, index, smallest)
		index = smallest
	end
end

function module.new(userId : string, startTime : number, eventLogModule)
	local self = setmetatable({}, module)

	self.currentTime = startTime
	self.userId = userId
	self.log = eventLogModule

	self.events = {}
	self.consumedCommands = {}
	self.currentRuntimeEvents = {}

	self.sequence = 0
	
	module.currentQueue = self
	return self
end

function module:getTime()
	return self.currentTime
end

function module:peek()
	return self.events[1]
end

function module:pop()
	local heap = self.events
	local root = heap[1]

	if not root then
		return nil
	end

	local last = table.remove(heap)

	if #heap > 0 then
		heap[1] = last
		heapDown(heap, 1)
	end

	if root.type == "COMMAND" then
		table.insert(self.consumedCommands, root)
	end

	table.insert(self.currentRuntimeEvents, root)

	return root
end

function module:advanceTo(targetTime)

	self.currentRuntimeEvents = {}

	while true do
		local nextEvent = self:peek()

		if not nextEvent or nextEvent.time > targetTime then
			break
		end
		
		local actualEvent = self:pop()

		self.currentTime = actualEvent.time
				
		self.eventProcessor(actualEvent)
	end

	self.currentTime = targetTime
end

function module:setProcessor(processor)
	self.eventProcessor = processor
end

function module:enqueue(event)

	local suc, err = self:validateEnqueue(event)

	self.sequence += 1
	event.sequence = self.sequence

	local heap = self.events

	table.insert(heap, event)
	heapUp(heap, #heap)

	self.log.eventEnqueued(event)

	return true
end

function module:enqueueInBatch(events)

	local successEvents = {}

	for _, event in events do

		local suc, err = self:validateEnqueue(event)

		if not suc then
			self.log.eventFail(event, err)
			continue
		end

		self.sequence += 1
		event.sequence = self.sequence

		table.insert(self.events, event)
		heapUp(self.events, #self.events)

		table.insert(successEvents, event)

		self.log.eventEnqueued(event)
	end

	return successEvents
end

function module:validateEnqueue(event)
	
	if not event.time then
		if not event.delay then
			return false, "Evento não tem 'time' ou 'delay'"
		end

		event.time = self:getEventTimeByDelay(event.delay)
	end

	if not event.eventType then
		return false, "Evento não tem 'eventType'"
	end
		
	if event.time < self.currentTime then
		return false, "Evento lançado no passado"
	end

	return true
end

function module:getEventTimeByDelay(delay)

	if delay < MIN_EVENT_DELAY then
		delay = MIN_EVENT_DELAY
	end

	return self.currentTime + delay
end

function module:getAllRuntimeEvents()
	return self.currentRuntimeEvents
end

function module.getCurrentQueue() : queue
	return module.currentQueue
end

export type queue = typeof(module.new("123", 0, nil))

return module