local cordaModel = script.Parent

local eixo = cordaModel:FindFirstChild("Eixo")

if not eixo then
	warn("A parte 'Eixo' não foi encontrada no modelo!")
	return
end

cordaModel.PrimaryPart = eixo

local velocidade = 2

while true do
	task.wait()
	local rotacao = CFrame.Angles(0, math.rad(velocidade), 0)
	local atual = cordaModel:GetPivot()
	cordaModel:PivotTo(atual * rotacao)
end

