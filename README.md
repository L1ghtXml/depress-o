# Spectrum Library

Uma biblioteca moderna e completa de UI em Lua com tema **all black**, desenvolvida especialmente para **executores externos** de Roblox.

##  Características

-  **Tema All Black** - Design moderno e elegante
- 📱 **Suporte Mobile** - Funciona perfeitamente em dispositivos móveis
- 🔲 **Cantos Quadrados** - Estilo clean e profissional
- 🎯 **Componentes Completos** - Todos os elementos que você precisa
- 🖱️ **Drag & Drop** - Interface arrastável
- 🎮 **Otimizado** - Performance excelente

## 📦 Componentes Disponíveis

### Window (Janela Principal)
- Título customizável
- Autor
- Ícone da UI
- Sistema de abas
- Botão de fechar
- Draggable (arrastável)

### Tabs (Abas)
- Navegação entre seções
- Ícones personalizados
- Animações suaves

### Botões
- Botão normal
- Botão toggle (liga/desliga)
- Callbacks funcionais

### Slider
- Funcional em mobile e PC
- Input manual no topo
- Min/Max customizável
- Incremento configurável
- Visual limpo

### Dropdown
- Lista de opções
- Animação de abertura/fechamento
- Seleção de item
- Visual compacto

### Outros
- **Parágrafo** - Texto formatado com título
- **Label** - Texto simples
- **Divider** - Linha separadora
- **Ícones Lucide** - Suporte a ícones

## 🚀 Instalação

### Método 1: LoadString (Recomendado)
```lua
local BlackUI = loadstring(game:HttpGet("URL_DA_SUA_LIBRARY"))()
```

### Método 2: Arquivo Local
1. Baixe o arquivo `BlackUI.lua`
2. Carregue no seu executor
3. Use: `local BlackUI = loadfile("BlackUI.lua")()`

## 📖 Uso Básico

### Criar Janela
```lua
local Window = BlackUI:CreateWindow({
    Title = "Meu Script",
    Author = "SeuNome",
    Icon = "home" -- Ícone Lucide (opcional)
})
```

### Criar Tab
```lua
local Tab = Window:CreateTab({
    Name = "Principal",
    Icon = "layout-dashboard" -- Opcional
})
```

### Criar Botão
```lua
Window:CreateButton(Tab, {
    Name = "MeuBotao",
    Text = "Clique Aqui",
    Callback = function()
        print("Botão clicado!")
    end
})
```

### Criar Toggle
```lua
local Toggle = Window:CreateToggle(Tab, {
    Name = "MeuToggle",
    Text = "Ativar Função",
    Default = false,
    Callback = function(state)
        print("Estado:", state)
    end
})

-- Mudar valor programaticamente
Toggle:SetValue(true)
```

### Criar Slider
```lua
local Slider = Window:CreateSlider(Tab, {
    Name = "MeuSlider",
    Text = "Velocidade",
    Min = 0,
    Max = 100,
    Increment = 1,
    Default = 50,
    Callback = function(value)
        print("Valor:", value)
    end
})

-- Mudar valor programaticamente
Slider:SetValue(75)
```

### Criar Dropdown
```lua
local Dropdown = Window:CreateDropdown(Tab, {
    Name = "MeuDropdown",
    Text = "Escolher Opção",
    Options = {"Opção 1", "Opção 2", "Opção 3"},
    Default = "Opção 1",
    Callback = function(option)
        print("Selecionado:", option)
    end
})

-- Mudar valor programaticamente
Dropdown:SetValue("Opção 2")
```

### Criar Parágrafo
```lua
Window:CreateParagraph(Tab, {
    Title = "Título do Parágrafo",
    Content = "Este é o conteúdo do parágrafo. Pode ser um texto longo que será automaticamente ajustado."
})
```

### Criar Label
```lua
Window:CreateLabel(Tab, "Este é um texto simples")
```

### Criar Divider
```lua
Window:CreateDivider(Tab)
```

## 🎨 Exemplo Completo

```lua
-- Carregar biblioteca
local BlackUI = loadstring(game:HttpGet("URL"))()

-- Criar janela
local Window = BlackUI:CreateWindow({
    Title = "BlackUI Demo",
    Author = "YourName",
    Icon = "home"
})

-- Criar tab
local MainTab = Window:CreateTab({
    Name = "Principal",
    Icon = "layout-dashboard"
})

-- Adicionar parágrafo
Window:CreateParagraph(MainTab, {
    Title = "Bem-vindo!",
    Content = "Esta é uma UI de demonstração."
})

-- Divider
Window:CreateDivider(MainTab)

-- Botão
Window:CreateButton(MainTab, {
    Name = "TestButton",
    Text = "Testar",
    Callback = function()
        print("Funcionou!")
    end
})

-- Toggle
Window:CreateToggle(MainTab, {
    Name = "TestToggle",
    Text = "Ativar",
    Default = false,
    Callback = function(state)
        print("Toggle:", state)
    end
})

-- Slider
Window:CreateSlider(MainTab, {
    Name = "SpeedSlider",
    Text = "Velocidade",
    Min = 16,
    Max = 200,
    Increment = 1,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Dropdown
Window:CreateDropdown(MainTab, {
    Name = "WeaponSelect",
    Text = "Arma",
    Options = {"Espada", "Arco", "Machado"},
    Default = "Espada",
    Callback = function(option)
        print("Arma:", option)
    end
})
```

## 🎯 Funcionalidades Especiais

### Slider com Input Manual
O slider possui um input no topo que permite digitar o valor diretamente, perfeito para quando o slider não funciona bem em mobile ou quando você precisa de precisão.

### Mobile Friendly
Todos os componentes foram testados e otimizados para funcionar perfeitamente em dispositivos móveis.

### Drag & Drop
A janela pode ser arrastada clicando e segurando em qualquer parte dela.

### Proteção Anti-Detecção
A UI automaticamente tenta se proteger usando `gethui()` ou `syn.protect_gui()` se disponível.

## 🎨 Customização de Cores

Você pode modificar as cores da UI editando a tabela `Colors` no início do código:

```lua
local Colors = {
    Background = Color3.fromRGB(10, 10, 10),
    Secondary = Color3.fromRGB(20, 20, 20),
    Border = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 150),
    Toggle = Color3.fromRGB(0, 200, 100),
    Slider = Color3.fromRGB(200, 200, 200),
    Button = Color3.fromRGB(30, 30, 30),
    ButtonHover = Color3.fromRGB(40, 40, 40)
}
```

## 🔧 Ícones Lucide

Para usar ícones Lucide, você pode:
1. Usar placeholders (padrão)
2. Substituir os IDs de asset no código
3. Usar uma CDN de ícones

Exemplo de ícones disponíveis:
- `home`
- `layout-dashboard`
- `user`
- `settings`
- `eye`
- `navigation`
- `cog`

## 📱 Compatibilidade

- ✅ Synapse X
- ✅ Script-Ware
- ✅ Krnl
- ✅ Fluxus
- ✅ Outros executores modernos
- ✅ Mobile (iOS/Android)

## ⚠️ Notas Importantes

1. **Performance**: A UI é otimizada, mas muitos elementos podem causar lag em dispositivos fracos
2. **Detecção**: Use com cautela, nenhuma UI é 100% indetectável
3. **Atualizações**: Sempre use a versão mais recente
4. **Suporte**: Reporte bugs e sugestões

## 📝 Licença

Este projeto é de código aberto. Você pode usar, modificar e distribuir livremente.

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se livre para:
- Reportar bugs
- Sugerir novas features
- Melhorar o código
- Criar temas customizados

## 📞 Suporte

Se precisar de ajuda:
1. Leia a documentação completa
2. Veja os exemplos fornecidos
3. Teste no executor antes de reportar bugs

---

**Feito com ❤️ para a comunidade de scripting**

**Versão**: 1.0
**Última Atualização**: 2026
