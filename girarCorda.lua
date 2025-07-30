local cordaModel = script.Parent
local haste = cordaModel:FindFirstChild("Haste")

if haste then
	cordaModel.PrimaryPart = haste
else
	warn("Parte 'Haste' não encontrada no modelo!")
	return
end

local velocidade = 2 -- graus por frame

while true do
	task.wait()
	local rotacao = CFrame.Angles(0, math.rad(velocidade), 0)
	local atual = cordaModel:GetPivot()
	cordaModel:PivotTo(atual * rotacao)
end

