local cordaModel = script.Parent
local eixo = cordaModel:FindFirstChild("Eixo")
local parteDeColisao = cordaModel:FindFirstChild("Haste") 
local Debris = game:GetService("Debris")

-- Ajuste estes valores para calibrar o jogo --
local velocidadeDeRotacao = 3    .
local forcaDoEmpurrao = 30000    
local alturaDoEmpurrao = 10000   
local duracaoDoEmpurrao = 0.2    
local tempoDeCooldown = 1        .

--// --- INICIALIZAÇÃO E CHECAGENS ---
local playersEmCooldown = {}

if not eixo or not parteDeColisao then
    warn("AVISO: Uma das partes necessárias ('Eixo' ou 'Haste') não foi encontrada!")
    return
end

-- Define o Eixo como a parte primária para a rotação funcionar corretamente
cordaModel.PrimaryPart = eixo

--// --- FUNÇÃO DE COLISÃO ---
local function aoTocar(outraParte)
    local character = outraParte.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return
    end

    if playersEmCooldown[character] then
        return
    end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end

    playersEmCooldown[character] = true

.
    local eixoDeRotacao = Vector3.new(0, 0, 1)

    --  O vetor que aponta do centro da rotação para o jogador.
    local vetorRadial = humanoidRootPart.Position - eixo.Position

    --    esteja correta mesmo se a velocidade for negativa (girando para o outro lado).
    local direcaoTangencial = eixoDeRotacao:Cross(vetorRadial).Unit * math.sign(velocidadeDeRotacao)
    
    --  Combina a força do "varrido" com um empurrão para cima.
    local forcaFinal = (direcaoTangencial * forcaDoEmpurrao) + Vector3.new(0, alturaDoEmpurrao, 0)
    
    local attachment = Instance.new("Attachment")
    attachment.Parent = humanoidRootPart

    local force = Instance.new("VectorForce")
    force.RelativeTo = Enum.ActuatorRelativeTo.World
    force.Attachment0 = attachment
    force.Force = forcaFinal
    force.Parent = humanoidRootPart

    Debris:AddItem(force, duracaoDoEmpurrao)
    Debris:AddItem(attachment, duracaoDoEmpurrao)
    
    -- Agendamos a remoção do jogador do cooldown
    task.delay(tempoDeCooldown, function()
        playersEmCooldown[character] = nil
    end)
end

-- Conecta a função ao evento .Touched da parte de colisão
parteDeColisao.Touched:Connect(aoTocar)

while true do
    task.wait()
    local rotacao = CFrame.Angles(0, 0, math.rad(velocidadeDeRotacao))
    local atual = cordaModel:GetPivot()
    cordaModel:PivotTo(atual * rotacao)
end
