function g(v)
	local g = -9.81
	local cw = 1.33
	local rho = 1.2
	local A = 0.25
	return (g + (1/2 * cw * rho * A * v * v))
end