local bcrypt = require("bcrypt")
return {
	---@param string string
	---@return string
	encrypt = function(string)
		local log_rounds = 5
		local digest = bcrypt.digest(string, log_rounds)
		return digest
	end,
	---@param string string
	---@param digest string
	---@return string
	verify = function(string, digest)
		return bcrypt.verify(string, digest)
	end,
}
