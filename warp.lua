-- Services
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Konfigurasi
local message = "/warp kfns:wawa"

-- Hapus GUI lama jika script dijalankan ulang
if LocalPlayer.PlayerGui:FindFirstChild("AutoWarpHub") then
    LocalPlayer.PlayerGui.AutoWarpHub:Destroy()
end
if CoreGui:FindFirstChild("AutoWarpHub") then
    CoreGui.AutoWarpHub:Destroy()
end

-- Membuat GUI Utama (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWarpHub"
screenGui.ResetOnSpawn = false

local parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
screenGui.Parent = parent

-- Frame Utama (Panel Hub)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 110)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar / Header Panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Growblox Auto-Warp"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

-- Tombol Minimize (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -30, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Tombol Warp Utama di dalam Panel
local warpBtn = Instance.new("TextButton")
warpBtn.Size = UDim2.new(1, -20, 0, 45)
warpBtn.Position = UDim2.new(0, 10, 0, 45)
warpBtn.BackgroundColor3 = Color3.fromRGB(200, 35, 35)
warpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
warpBtn.Text = "WARP 1X"
warpBtn.Font = Enum.Font.SourceSansBold
warpBtn.TextSize = 16
warpBtn.Parent = mainFrame

local warpCorner = Instance.new("UICorner")
warpCorner.CornerRadius = UDim.new(0, 8)
warpCorner.Parent = warpBtn

-- Tombol Floating Kecil (OPEN)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 45, 0, 45)
openBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Text = "OPEN"
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextSize = 12
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 22)
openCorner.Parent = openBtn

-- Fungsi Kirim Chat Serbaguna
local function sendWarpChat()
    -- Percobaan 1: Menggunakan RemoteEvent Legacy Chat
    local sayMessage = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") 
        and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    
    if sayMessage then
        sayMessage:FireServer(message, "All")
    end

    -- Percobaan 2: Menggunakan TextChatService (Modern Chat)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if generalChannel then
            generalChannel:SendAsync(message)
        end
    end

    -- Percobaan 3: Simulasi Membuka Chat Bar & Kirim Teks
    task.spawn(function()
        local chatBar = LocalPlayer.PlayerGui:FindFirstChild("ChatBar", true) 
                     or CoreGui:FindFirstChild("ChatBar", true)
        
        if chatBar and chatBar:IsA("TextBox") then
            chatBar:CaptureFocus()
            chatBar.Text = message
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            chatBar:ReleaseFocus()
        end
    end)
end

-- Aksi Tombol Warp
warpBtn.MouseButton1Click:Connect(function()
    warpBtn.BackgroundColor3 = Color3.fromRGB(35, 200, 35)
    warpBtn.Text = "WARPING..."
    
    sendWarpChat()
    
    task.wait(0.4)
    warpBtn.BackgroundColor3 = Color3.fromRGB(200, 35, 35)
    warpBtn.Text = "WARP 1X"
end)

-- Aksi Minimize (-)
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Position = mainFrame.Position
    openBtn.Visible = true
end)

-- Aksi Buka Kembali (Tombol OPEN)
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Position = openBtn.Position
    mainFrame.Visible = true
    openBtn.Visible = false
end)
