local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-------------------------------------------------------------------------------
--! PLATOBOOST LIBRARY & CONFIGURATION
-------------------------------------------------------------------------------
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;

local service = 21337;
local secret = "6cdf2b5c-4b91-4360-a991-ce70f332244b";
local useNonce = true;

local onMessage = function(message) 
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "NEVERLOSE Key System",
            Text = message,
            Duration = 5
        })
    end)
end;

repeat task.wait(1) until game:IsLoaded();

local requestSending = false;
local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid = setclipboard or toclipboard, request or http_request or syn_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function() return game:GetService("Players").LocalPlayer.UserId end
local cachedLink, cachedTime = "", 0;
local host = "https://api.platoboost.com";
local hostResponse = fRequest({ Url = host .. "/public/connectivity", Method = "GET" });
if hostResponse.StatusCode ~= 200 or hostResponse.StatusCode ~= 429 then
    host = "https://api.platoboost.net";
end

function cacheLink()
    if cachedTime + (10*60) < fOsTime() then
        local response = fRequest({
            Url = host .. "/public/start", Method = "POST",
            Body = lEncode({ service = service, identifier = lDigest(fGetHwid()) }),
            Headers = { ["Content-Type"] = "application/json" }
        });
        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body);
            if decoded.success == true then
                cachedLink = decoded.data.url; cachedTime = fOsTime();
                return true, cachedLink;
            else
                onMessage(decoded.message); return false, decoded.message;
            end
        elseif response.StatusCode == 429 then
            local msg = "Rate limited, wait 20s."; onMessage(msg); return false, msg;
        end
        local msg = "Failed to cache link."; onMessage(msg); return false, msg;
    else
        return true, cachedLink;
    end
end

cacheLink();

local generateNonce = function()
    local str = ""
    for _ = 1, 16 do str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97) end
    return str
end

for _ = 1, 5 do
    local oNonce = generateNonce(); task.wait(0.2)
    if generateNonce() == oNonce then local msg = "platoboost nonce error."; onMessage(msg); error(msg); end
end

local copyLink = function()
    local success, link = cacheLink();
    if success then fSetClipboard(link); onMessage("Link copied to clipboard!") end
end

local redeemKey = function(key)
    local nonce = generateNonce();
    local endpoint = host .. "/public/redeem/" .. fToString(service);
    local body = { identifier = lDigest(fGetHwid()), key = key }
    if useNonce then body.nonce = nonce; end
    local response = fRequest({ Url = endpoint, Method = "POST", Body = lEncode(body), Headers = { ["Content-Type"] = "application/json" } });
    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then return true;
                    else onMessage("failed to verify integrity."); return false; end    
                else return true; end
            else onMessage("key is invalid."); return false; end
        else
            if fStringSub(decoded.message, 1, 27) == "unique constraint violation" then
                onMessage("Active key exists, wait for expiration."); return false;
            else onMessage(decoded.message); return false; end
        end
    elseif response.StatusCode == 429 then onMessage("Rate limited, wait 20s."); return false;
    else onMessage("Server error."); return false; end
end

local verifyKey = function(key)
    if requestSending == true then onMessage("Request pending..."); return false; else requestSending = true; end
    local nonce = generateNonce();
    local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;
    if useNonce then endpoint = endpoint .. "&nonce=" .. nonce; end
    local response = fRequest({ Url = endpoint, Method = "GET", });
    requestSending = false;
    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then return true;
                    else onMessage("failed to verify integrity."); return false; end
                else return true; end
            else
                if fStringSub(key, 1, 4) == "KEY_" then return redeemKey(key);
                else onMessage("key is invalid."); return false; end
            end
        else onMessage(decoded.message); return false; end
    elseif response.StatusCode == 429 then onMessage("Rate limited, wait 20s."); return false;
    else onMessage("Server error."); return false; end
end

-------------------------------------------------------------------------------
--! NEVERLOSE VARIABLES & PALETTE
-------------------------------------------------------------------------------
local NL_COLOR = {
    MainBG = Color3.fromRGB(8, 8, 12),
    SideBG = Color3.fromRGB(5, 5, 8),
    SectionBG = Color3.fromRGB(13, 13, 20),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(140, 140, 145)
}

local MASTER_ESP, BOX_ENABLED, NAME_ENABLED, DIST_ENABLED, SNAP_ENABLED = false, true, true, true, false
local ui_visible = false -- Спочатку меню сховане
local running, espObjects = true, {}
local TOGGLE_KEY = Enum.KeyCode.Delete
local is_binding = false
local isAuthenticated = false -- СТАТУС АВТОРИЗАЦІЇ

-------------------------------------------------------------------------------
--! ESP LOGIC
-------------------------------------------------------------------------------
local function silentRemoveESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do obj.Visible = false end
    end
end
Players.PlayerRemoving:Connect(silentRemoveESP)

local espLoop
espLoop = RunService.RenderStepped:Connect(function()
    if not running or not isAuthenticated then 
        for p, _ in pairs(espObjects) do silentRemoveESP(p) end
        if not running then espLoop:Disconnect() end
        return 
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not espObjects[player] then
                espObjects[player] = {
                    Box = Drawing.new("Square"), BgBar = Drawing.new("Square"), HpBar = Drawing.new("Square"),
                    Name = Drawing.new("Text"), Dist = Drawing.new("Text"), Snap = Drawing.new("Line")
                }
                local o = espObjects[player]
                o.Box.Color = NL_COLOR.Accent; o.Box.Thickness = 1.5; o.Box.Transparency = 1
                o.BgBar.Color = Color3.new(0,0,0); o.BgBar.Filled = true
                o.HpBar.Filled = true
                o.Name.Color = NL_COLOR.Text; o.Name.Size = 13; o.Name.Center = true; o.Name.Outline = true; o.Name.Font = 3
                o.Dist.Color = NL_COLOR.Text; o.Dist.Size = 13; o.Dist.Center = true; o.Dist.Outline = true; o.Dist.Font = 3
                o.Snap.Color = NL_COLOR.Accent; o.Snap.Thickness = 1; o.Snap.Transparency = 0.5
            end
            local o, char = espObjects[player], player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local isEnemy = (player.Team ~= LocalPlayer.Team)
            if MASTER_ESP and root and isEnemy and hum and hum.Health > 0 then
                local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local fovScale = 70 / Camera.FieldOfView 
                    local size = (2500 / rootPos.Z) * fovScale
                    local boxW, boxH = math.floor(size), math.floor(size * 1.5)
                    local boxX, boxY = math.floor(rootPos.X - boxW/2), math.floor(rootPos.Y - boxH/2)
                    if BOX_ENABLED then
                        o.Box.Size = Vector2.new(boxW, boxH); o.Box.Position = Vector2.new(boxX, boxY); o.Box.Visible = true
                        local hpP = hum.Health / hum.MaxHealth
                        o.BgBar.Size = Vector2.new(4, boxH + 2); o.BgBar.Position = Vector2.new(boxX - 6, boxY - 1); o.BgBar.Visible = true
                        local hpSize = math.floor(boxH * hpP)
                        o.HpBar.Size = Vector2.new(2, hpSize); o.HpBar.Position = Vector2.new(boxX - 5, boxY + boxH - hpSize)
                        o.HpBar.Color = Color3.fromRGB(255 - (hpP * 255), hpP * 255, 0); o.HpBar.Visible = true
                    else o.Box.Visible = false; o.BgBar.Visible = false; o.HpBar.Visible = false end
                    if NAME_ENABLED then o.Name.Text = player.Name; o.Name.Position = Vector2.new(boxX + boxW/2, boxY - 16); o.Name.Visible = true else o.Name.Visible = false end
                    if DIST_ENABLED then o.Dist.Text = math.floor((Camera.CFrame.Position - root.Position).Magnitude) .. "m"; o.Dist.Position = Vector2.new(boxX + boxW/2, boxY + boxH + 2); o.Dist.Visible = true else o.Dist.Visible = false end
                    if SNAP_ENABLED then o.Snap.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); o.Snap.To = Vector2.new(boxX + boxW/2, boxY + boxH); o.Snap.Visible = true else o.Snap.Visible = false end
                else for _, obj in pairs(o) do obj.Visible = false end end
            else for _, obj in pairs(o) do obj.Visible = false end end
        end
    end
end)

-------------------------------------------------------------------------------
--! UI CONSTRUCTION
-------------------------------------------------------------------------------
local MenuGui = Instance.new("ScreenGui")
MenuGui.ResetOnSpawn = false; MenuGui.DisplayOrder = 9999
pcall(function() MenuGui.Parent = CoreGui end)
if not MenuGui.Parent then MenuGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- [ГОЛОВНЕ ВІКНО МЕНЮ]
local Main = Instance.new("Frame", MenuGui)
Main.Size = UDim2.new(0, 480, 0, 320); Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = NL_COLOR.MainBG; Main.BorderSizePixel = 0; Main.Draggable = true; Main.Active = true
Main.Visible = false -- Сховане до авторизації
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 4)

-- [ВІКНО АВТОРИЗАЦІЇ KEY SYSTEM]
local KeyMain = Instance.new("Frame", MenuGui)
KeyMain.Size = UDim2.new(0, 320, 0, 160); KeyMain.Position = UDim2.new(0.5, -160, 0.5, -80)
KeyMain.BackgroundColor3 = NL_COLOR.MainBG; KeyMain.BorderSizePixel = 0; KeyMain.Draggable = true; KeyMain.Active = true
Instance.new("UICorner", KeyMain).CornerRadius = UDim.new(0, 4)

local KeyTopLine = Instance.new("Frame", KeyMain)
KeyTopLine.Size = UDim2.new(1, 0, 0, 2); KeyTopLine.BackgroundColor3 = NL_COLOR.Accent; KeyTopLine.BorderSizePixel = 0
Instance.new("UICorner", KeyTopLine).CornerRadius = UDim.new(0, 4)

local KeyLogo = Instance.new("TextLabel", KeyMain)
KeyLogo.Size = UDim2.new(1, 0, 0, 30); KeyLogo.Position = UDim2.new(0, 10, 0, 5); KeyLogo.BackgroundTransparency = 1; 
KeyLogo.Text = "NEVERLOSE.CC | KEY SYSTEM"; KeyLogo.TextColor3 = NL_COLOR.Text; KeyLogo.Font = "GothamBold"; KeyLogo.TextSize = 13; KeyLogo.TextXAlignment = "Left"

local KeyBoxBG = Instance.new("Frame", KeyMain)
KeyBoxBG.Size = UDim2.new(1, -40, 0, 35); KeyBoxBG.Position = UDim2.new(0, 20, 0, 50)
KeyBoxBG.BackgroundColor3 = NL_COLOR.SectionBG; KeyBoxBG.BorderSizePixel = 0
Instance.new("UICorner", KeyBoxBG).CornerRadius = UDim.new(0, 4)

local KeyInput = Instance.new("TextBox", KeyBoxBG)
KeyInput.Size = UDim2.new(1, -20, 1, 0); KeyInput.Position = UDim2.new(0, 10, 0, 0)
KeyInput.BackgroundTransparency = 1; KeyInput.Text = ""; KeyInput.PlaceholderText = "Enter your key here..."
KeyInput.TextColor3 = NL_COLOR.Text; KeyInput.PlaceholderColor3 = NL_COLOR.TextDark; KeyInput.Font = "GothamSemibold"; KeyInput.TextSize = 12

local GetKeyBtn = Instance.new("TextButton", KeyMain)
GetKeyBtn.Size = UDim2.new(0, 130, 0, 35); GetKeyBtn.Position = UDim2.new(0, 20, 0, 105)
GetKeyBtn.BackgroundColor3 = NL_COLOR.SectionBG; GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Text = "Get Key"; GetKeyBtn.TextColor3 = NL_COLOR.TextDark; GetKeyBtn.Font = "GothamSemibold"; GetKeyBtn.TextSize = 12
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 4)

local VerifyBtn = Instance.new("TextButton", KeyMain)
VerifyBtn.Size = UDim2.new(0, 130, 0, 35); VerifyBtn.Position = UDim2.new(1, -150, 0, 105)
VerifyBtn.BackgroundColor3 = NL_COLOR.Accent; VerifyBtn.BorderSizePixel = 0
VerifyBtn.Text = "Verify"; VerifyBtn.TextColor3 = Color3.fromRGB(255,255,255); VerifyBtn.Font = "GothamBold"; VerifyBtn.TextSize = 12
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 4)

-- Логіка кнопок ключів
GetKeyBtn.MouseButton1Click:Connect(function() copyLink() end)

VerifyBtn.MouseButton1Click:Connect(function()
    VerifyBtn.Text = "Checking..."
    local key = KeyInput.Text
    local success = verifyKey(key)
    
    if success then
        isAuthenticated = true
        KeyMain.Visible = false
        ui_visible = true
        Main.Visible = true
        onMessage("Welcome to NEVERLOSE!")
    else
        VerifyBtn.Text = "Verify"
    end
end)

-- [ВІДЖЕТ БІНДІВ - ІНТЕГРОВАНИЙ В МЕНЮ]
local BindBtn = Instance.new("TextButton", Main)
BindBtn.Size = UDim2.new(0, 100, 0, 25); BindBtn.Position = UDim2.new(1, -110, 1, -35)
BindBtn.BackgroundColor3 = NL_COLOR.SectionBG; BindBtn.BorderSizePixel = 0
BindBtn.Text = "[" .. TOGGLE_KEY.Name .. "]"; BindBtn.TextColor3 = NL_COLOR.TextDark; BindBtn.Font = "GothamSemibold"; BindBtn.TextSize = 11
Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

local BindLabel = Instance.new("TextLabel", Main)
BindLabel.Size = UDim2.new(0, 100, 0, 15); BindLabel.Position = UDim2.new(1, -110, 1, -50)
BindLabel.BackgroundTransparency = 1; BindLabel.Text = "Menu Keybind"; BindLabel.TextColor3 = NL_COLOR.TextDark
BindLabel.Font = "GothamBold"; BindLabel.TextSize = 10; BindLabel.TextXAlignment = "Center"

BindBtn.MouseButton1Click:Connect(function()
    is_binding = true; BindBtn.Text = "..."; BindBtn.TextColor3 = NL_COLOR.Accent
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if is_binding then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            TOGGLE_KEY = input.KeyCode; BindBtn.Text = "[" .. TOGGLE_KEY.Name .. "]"; BindBtn.TextColor3 = NL_COLOR.TextDark
            is_binding = false
        end
        return
    end
    -- Меню відкривається тільки якщо ключ перевірено
    if not gpe and input.KeyCode == TOGGLE_KEY and isAuthenticated then
        ui_visible = not ui_visible
        Main.Visible = ui_visible
    end
end)

-- [LOGO & Sidebar]
local LogoContainer = Instance.new("Frame", Main)
LogoContainer.Size = UDim2.new(0, 100, 0, 35); LogoContainer.BackgroundTransparency = 1
local TopLine = Instance.new("Frame", LogoContainer)
TopLine.Size = UDim2.new(1, 0, 0, 2); TopLine.BackgroundColor3 = NL_COLOR.Accent; TopLine.BorderSizePixel = 0
Instance.new("UICorner", TopLine).CornerRadius = UDim.new(0, 4)
local LogoText = Instance.new("TextLabel", LogoContainer)
LogoText.Size = UDim2.new(1, 0, 1, 0); LogoText.Position = UDim2.new(0, 10, 0, 2); LogoText.BackgroundTransparency = 1; LogoText.Text = "NEVERLOSE.CC"; LogoText.TextColor3 = NL_COLOR.Text; LogoText.Font = "GothamBold"; LogoText.TextSize = 13; LogoText.TextXAlignment = "Left"

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 100, 1, -35); Sidebar.Position = UDim2.new(0, 0, 0, 35); Sidebar.BackgroundColor3 = NL_COLOR.SideBG; Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)
local TabHolder = Instance.new("Frame", Sidebar); TabHolder.Size = UDim2.new(1, 0, 1, 0); TabHolder.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabHolder); TabLayout.HorizontalAlignment = "Center"; TabLayout.Padding = UDim.new(0, 5)
Instance.new("UIPadding", TabHolder).PaddingTop = UDim.new(0, 10)

local function createTab(name, active)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, -20, 0, 30); t.BackgroundTransparency = 1; t.Text = name; t.Font = "GothamSemibold"; t.TextSize = 13; t.TextColor3 = active and NL_COLOR.Accent or NL_COLOR.TextDark; t.TextXAlignment = "Left"
    return t
end
local tVisuals = createTab("Visuals", true); local tMisc = createTab("Misc", false)

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -115, 1, -45); Pages.Position = UDim2.new(0, 110, 0, 40); Pages.BackgroundTransparency = 1
local VisualsPage = Instance.new("ScrollingFrame", Pages); VisualsPage.Size = UDim2.new(1, 0, 1, 0); VisualsPage.BackgroundTransparency = 1; VisualsPage.ScrollBarThickness = 0
local MiscPage = Instance.new("Frame", Pages); MiscPage.Size = UDim2.new(1, 0, 1, 0); MiscPage.BackgroundTransparency = 1; MiscPage.Visible = false

-- [ESP Sections]
local function createNLSection(parent, title)
    local sect = Instance.new("Frame", parent); sect.Size = UDim2.new(1, 0, 0, 40); sect.BackgroundColor3 = NL_COLOR.SectionBG; sect.BorderSizePixel = 0
    Instance.new("UICorner", sect).CornerRadius = UDim.new(0, 4)
    local top = Instance.new("Frame", sect); top.Size = UDim2.new(1, 0, 0, 40); top.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", top); label.Size = UDim2.new(1, -60, 1, 0); label.Position = UDim2.new(0, 12, 0, 0); label.BackgroundTransparency = 1; label.Text = title:upper(); label.TextColor3 = NL_COLOR.Text; label.Font = "GothamBold"; label.TextSize = 11; label.TextXAlignment = "Left"
    local sw = Instance.new("TextButton", top); sw.Size = UDim2.new(0, 28, 0, 14); sw.Position = UDim2.new(1, -40, 0, 13); sw.BackgroundColor3 = Color3.fromRGB(35, 35, 45); sw.Text = ""; Instance.new("UICorner", sw)
    local d = Instance.new("Frame", sw); d.Size = UDim2.new(0, 10, 0, 10); d.Position = UDim2.new(0, 2, 0, 2); d.BackgroundColor3 = Color3.fromRGB(90, 90, 95); Instance.new("UICorner", d)
    local isExpanded, content = false, Instance.new("Frame", sect); content.Size = UDim2.new(1, 0, 0, 140); content.Position = UDim2.new(0, 0, 0, 40); content.Visible = false; content.BackgroundTransparency = 1
    sw.MouseButton1Click:Connect(function() MASTER_ESP = not MASTER_ESP; d:TweenPosition(MASTER_ESP and UDim2.new(0, 16, 0, 2) or UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.1, true); d.BackgroundColor3 = MASTER_ESP and NL_COLOR.Accent or Color3.fromRGB(90, 90, 95) end)
    top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isExpanded = not isExpanded; sect.Size = isExpanded and UDim2.new(1, 0, 0, 180) or UDim2.new(1, 0, 0, 40); content.Visible = isExpanded end end)
    return content
end
local espSect = createNLSection(VisualsPage, "Enemy ESP")

local function addNLToggle(parent, text, y, default, callback)
    local t = Instance.new("TextButton", parent); t.Size = UDim2.new(1, 0, 0, 30); t.Position = UDim2.new(0, 12, 0, y); t.BackgroundTransparency = 1; t.Text = text; t.TextColor3 = default and NL_COLOR.Text or NL_COLOR.TextDark; t.Font = "GothamSemibold"; t.TextSize = 12; t.TextXAlignment = "Left"
    local b = Instance.new("Frame", t); b.Size = UDim2.new(0, 12, 0, 12); b.Position = UDim2.new(1, -40, 0, 9); b.BackgroundColor3 = default and NL_COLOR.Accent or Color3.fromRGB(30, 30, 40); Instance.new("UICorner", b)
    t.MouseButton1Click:Connect(function() default = not default; callback(default); b.BackgroundColor3 = default and NL_COLOR.Accent or Color3.fromRGB(30, 30, 40); t.TextColor3 = default and NL_COLOR.Text or NL_COLOR.TextDark end)
end
addNLToggle(espSect, "Box ESP", 5, true, function(s) BOX_ENABLED = s end);
addNLToggle(espSect, "Name ESP", 35, true, function(s) NAME_ENABLED = s end); addNLToggle(espSect, "Distance", 65, true, function(s) DIST_ENABLED = s end);
addNLToggle(espSect, "Snaplines", 95, false, function(s) SNAP_ENABLED = s end)

-- [Misc Page - Safe Exit]
local unl = Instance.new("TextButton", MiscPage)
unl.Size = UDim2.new(1, 0, 0, 40); unl.Position = UDim2.new(0,0,0,10); unl.BackgroundColor3 = NL_COLOR.SectionBG; unl.Text = "Silent Unload"; unl.TextColor3 = Color3.new(1, 0.3, 0.3); unl.Font = "GothamBold"; Instance.new("UICorner", unl)
unl.MouseButton1Click:Connect(function() running = false; MASTER_ESP = false; Main.Visible = false; KeyMain.Visible = false; MenuGui.Enabled = false end)

tVisuals.MouseButton1Click:Connect(function() VisualsPage.Visible = true; MiscPage.Visible = false; tVisuals.TextColor3 = NL_COLOR.Accent; tMisc.TextColor3 = NL_COLOR.TextDark end)
tMisc.MouseButton1Click:Connect(function() VisualsPage.Visible = false; MiscPage.Visible = true; tVisuals.TextColor3 = NL_COLOR.TextDark; tMisc.TextColor3 = NL_COLOR.Accent end)
