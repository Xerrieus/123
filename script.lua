--=============================================================================
-- 1. СИСТЕМА КЛЮЧІВ PLATOBOOST (ID: 21337)
--=============================================================================
local service = 21337;
local secret = "6cdf2b5c-4b91-4360-a991-ce70f332244b";
local useNonce = true;

-- Функція для сповіщень
local onMessage = function(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Platoboost",
        Text = message,
        Duration = 5
    })
end;

-- Внутрішня бібліотека Platoboost (Хешування та JSON)
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;
local lEncode = function(t) return game:GetService("HttpService"):JSONEncode(t) end;
local lDecode = function(t) return game:GetService("HttpService"):JSONDecode(t) end;
local lDigest = Z;

repeat task.wait(1) until game:IsLoaded();

local fSetClipboard, fRequest, fGetHwid = setclipboard or toclipboard, request or http_request or syn_request, gethwid or function() return game:GetService("Players").LocalPlayer.UserId end
local host = "https://api.platoboost.com";

function copyLink()
    local response = fRequest({Url = host .. "/public/start", Method = "POST", Body = lEncode({service = service, identifier = lDigest(fGetHwid())}), Headers = {["Content-Type"] = "application/json"}});
    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success then fSetClipboard(decoded.data.url) onMessage("Посилання на ключ скопійовано!") end
    end
end

function verifyKey(key)
    local endpoint = host .. "/public/whitelist/" .. tostring(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;
    local response = fRequest({Url = endpoint, Method = "GET"});
    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        return decoded.success and decoded.data.valid;
    end
    return false;
end

--=============================================================================
-- 2. ТВОЄ ESP ЗІ ЗОБРАЖЕННЯ (Змінні та функції)
--=============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NL_COLOR = {
    MainBG = Color3.fromRGB(8, 8, 12),
    SideBG = Color3.fromRGB(5, 5, 8),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

_G.MASTER_ESP = false
_G.BOX_ENABLED = true
_G.NAME_ENABLED = true
_G.DIST_ENABLED = true

local espObjects = {}

local function silentRemoveESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do obj.Visible = false end
    end
end

Players.PlayerRemoving:Connect(silentRemoveESP)

-- Логіка малювання ESP (спрощена для Orion)
RunService.RenderStepped:Connect(function()
    if not _G.MASTER_ESP then 
        for p, _ in pairs(espObjects) do silentRemoveESP(p) end
        return 
    end
    -- (Тут має бути твій повний код малювання боксів з script.lua)
end)

--=============================================================================
-- 3. ГРАФІЧНИЙ ІНТЕРФЕЙС (Orion Library)
--=============================================================================
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Tpa Simulator Hub | ESP & Farm", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "TpaConfig",
    KeySystem = true,
    KeySettings = {
        Title = "Вхід у скрипт",
        Subtitle = "Потрібен ключ Platoboost",
        Note = "Натисніть 'Get Key', пройдіть рекламу і вставте ключ",
        FileName = "TpaKey",
        SaveKey = true,
        CustomCheck = function(enteredKey)
            return verifyKey(enteredKey)
        end
    }
})

-- Вкладка ESP
local EspTab = Window:MakeTab({Name = "Візуал (ESP)", Icon = "rbxassetid://4483345998"})

EspTab:AddToggle({
    Name = "Увімкнути ESP",
    Default = false,
    Callback = function(Value)
        _G.MASTER_ESP = Value
    end
})

EspTab:AddToggle({
    Name = "Показувати бокси",
    Default = true,
    Callback = function(Value)
        _G.BOX_ENABLED = Value
    end
})

-- Вкладка Фарму (Tpa Simulator)
local FarmTab = Window:MakeTab({Name = "Фарм", Icon = "rbxassetid://4483345998"})

_G.AutoClick = false
FarmTab:AddToggle({
    Name = "Авто-клікер",
    Default = false,
    Callback = function(Value)
        _G.AutoClick = Value
        task.spawn(function()
            while _G.AutoClick do
                local event = game:GetService("ReplicatedStorage"):FindFirstChild("ClickEvent", true)
                if event then event:FireServer() end
                task.wait(0.1)
            end
        end)
    end
})

-- Вкладка Ключів
local KeyTab = Window:MakeTab({Name = "Ключ", Icon = "rbxassetid://4483345998"})

KeyTab:AddButton({
    Name = "Отримати посилання на ключ",
    Callback = function()
        copyLink()
    end
})

OrionLib:Init()
