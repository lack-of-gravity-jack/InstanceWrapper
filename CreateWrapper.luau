local WrapperMetatable = {}
WrapperMetatable.__index = function(wrapper, key)
	local instance = rawget(wrapper, _instance)
	if type(instance[key]) == "function" then
		return function(FirstParameter, ...)
			if FirstParameter == wrapper then --this is a method call
				return instance[key](instance, ...) --invoke with instance as "self" instead of wrapper
			else --normal function call
				return instance[key](FirstParameter, ...)
			end
		end
	else
		return instance[key]
	end
end

local function CreateWrapper(instance: Instance)
	local NewWrapper = setmetatable({}, WrapperMetatable)
	NewWrapper._instance = instance
	return NewWrapper
end

return CreateWrapper
