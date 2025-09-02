-- Modelo da corda que contém este script
local cordaModel = script.Parent

-- A parte que servirá como centro da rotação
local eixo = cordaModel:FindFirstChild("Eixo")

-- A(s) parte(s) da corda que vão detectar a colisão com o jogador

local parteDeColisao = cordaModel:FindFirstChild("Haste") 

-- Configurações do Jogo
local velocidadeDeRotacao = 3 
local forcaDoEmpurrao = 2000  
local alturaDoEmpurrao = 500  
local tempoDeCooldown = 1     

-- Tabela para controlar quais jogadores estão em cooldown
local playersEmCooldown = {}

-- Checa se as partes essenciais existem
if not eixo or not parteDeColisao then
    warn("AVISO: Uma das partes necessárias ('Eixo' ou a 'parteDeColisao') não foi encontrada no modelo!")
    return
end

-- Define o Eixo como a parte primária para a rotação funcionar corretamente
cordaModel.PrimaryPart = eixo

local function aoTocar(outraParte)
    print("ALGO TOCOU NA HASTE! O nome da peça é: " .. outraParte.Name)
    
    local character = outraParte.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return
    end
    
    print("O que tocou foi um personagem: " .. character.Name)
    
    if playersEmCooldown[character] then
        print("Personagem está em cooldown, ignorando.")
        return
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end
    
    print("HumanoidRootPart encontrado! APLICANDO FORÇA...")
    
    playersEmCooldown[character] = true
    
    local direcao = (humanoidRootPart.Position - eixo.Position).Unit
    local forcaTotal = (direcao * forcaDoEmpurrao) + Vector3.new(0, alturaDoEmpurrao, 0)
    
    humanoidRootPart:ApplyImpulse(forcaTotal)
    print("FORÇA APLICADA!") -- Teste 4: Comando executado.
    
    task.delay(tempoDeCooldown, function()
        playersEmCooldown[character] = nil
    end)
end

-- Conecta a função 'aoTocar' ao evento .Touched da parte de colisão
parteDeColisao.Touched:Connect(aoTocar)

while true do
    task.wait() -- Espera um frame antes de continuar
    
    -- Cria uma rotação no eixo Z (roll)
    local rotacao = CFrame.Angles(0, 0, math.rad(velocidadeDeRotacao))
    
    -- Pega a posição e orientação atual do modelo
    local atual = cordaModel:GetPivot()
    
    -- Aplica a nova rotação à posição atual
    cordaModel:PivotTo(atual * rotacao)
end
