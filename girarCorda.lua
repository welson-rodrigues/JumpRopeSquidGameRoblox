local cordaModel = script.Parent

local haste = cordaModel:FindFirstChild("Haste")

if haste then
	cordaModel.PrimaryPart = haste
else
	warn("A parte 'Haste' não foi encontrada no modelo!")
	return
end

local velocidade = 2 


while true do
	task.wait()
	local rotacao = CFrame.Angles(0, math.rad(velocidade), 0)
	local atual = cordaModel:GetPivot()
	cordaModel:PivotTo(atual * rotacao)
end

