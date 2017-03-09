if select(6, GetAddOnInfo("CowTip_" .. (debugstack():match("[C%.][o%.][w%.]Tip\\Modules\\(.-)\\") or debugstack():match("[C%.][o%.][w%.]Tip\\(.-)\\") or ""))) ~= "MISSING" then return end

local VERSION = tonumber(("$Revision: 68121 $"):match("%d+"))

local CowTip = CowTip
local CowTip_Position = CowTip:NewModule("Position", "LibRockTimer-1.0", "LibRockHook-1.0")
local self = CowTip_Position
if CowTip.revision < VERSION then
	CowTip.version = "r" .. VERSION
	CowTip.revision = VERSION
	CowTip.date = ("$Date: 2008-04-05 07:44:09 +0000 (Sat, 05 Apr 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")
end
CowTip_Position.desc = "Allow for positioning of the tooltip"

local localization = (GetLocale() == "koKR") and {
	["%s, %s"] = "%s, %s",
	["Cursor"] = "커서",
	["Parent frame"] = "부모 프레임",
	["Screen"] = "화면",
	["Top"] = "상단",
	["Top-left"] = "상단-좌측",
	["Top-right"] = "상단-우측",
	["Right"] = "우측",
	["Left"] = "좌측",
	["Bottom"] = "하단",
	["Bottom-left"] = "하단-좌측",
	["Bottom-right"] = "하단-우측",
	["Middle"] = "가운데",
	["Anchor: %s\nClick and drag to the position you want.\nDouble-click when finished."] = "Anchor: %s\nClick and drag to the position you want.\nDouble-click when finished.",
	["Anchor"] = "앵커",
	["The anchor with which the tooltips are located."] = "툴팁의 앵커 위치를 설정합니다.",
	["Set anchor offset"] = "앵커의 좌표 설정",
	["Click this to bring up an easy-to-use offset box."] = "사용하기 쉬운 좌표 박스를 열려면 클릭하세요.",
	["Adjust"] = "조절",
	["Horizontal offset"] = "가로 좌표",
	["Offset of the x-axis."] = "X-축의 좌표입니다.",
	["Vertical offset"] = "세로 좌표",
	["Offset of the y-axis."] = "Y-축의 좌표입니다.",
	["Position"] = "위치",
	["Change where the tooltip is located."] = "툴팁의 위치를 변경합니다.",
	["Unit"] = "유닛",
	["Options for unit mouseover tooltips"] = "유닛에 마우스 오버 시 툴팁의 설정입니다.",
	["Frame"] = "프레임",
	["Options for frame mouseover tooltips"] = "프레임에 마우스 오버 시 툴팁의 설정입니다.",
} or (GetLocale() == "zhCN") and {
	["%s, %s"] = "%s，%s",
	["Cursor"] = "鼠标指针",
	["Top"] = "上",
	["Top-left"] = "左上",
	["Top-right"] = "右上",
	["Right"] = "右",
	["Left"] = "左",
	["Bottom"] = "下",
	["Bottom-left"] = "左下",
	["Bottom-right"] = "右下",
	["Parent frame"] = "父级框架",
	["Screen"] = "游戏屏幕",
	["Middle"] = "中间",
	["Anchor: %s\nClick and drag to the position you want.\nDouble-click when finished."] = "锚点：%s\n按住并拖拽到你想要的位置。\n完成时双击确认。",
	["Anchor"] = "锚点",
	["The anchor with which the tooltips are located."] = "设置提示信息框的位置。",
	["Set anchor offset"] = "设置锚点偏移",
	["Click this to bring up an easy-to-use offset box."] = "点击会打开一个易于使用的偏移位置对话框。",
	["Adjust"] = "调整",
	["Horizontal offset"] = "水平偏移",
	["Offset of the x-axis."] = "水平方向的偏移量。",
	["Vertical offset"] = "垂直偏移",
	["Offset of the y-axis."] = "垂直方向的偏移量。",
	["Position"] = "位置",
	["Change where the tooltip is located."] = "更改提示信息框的位置。",
	["Unit"] = "单位",
	["Options for unit mouseover tooltips"] = "鼠标悬停在某单位上时的提示信息框的设置",
	["Frame"] = "框体",
	["Options for frame mouseover tooltips"] = "鼠标悬停在某框体上时的提示信息框的设置",
} or (GetLocale() == "zhTW") and {
	["%s, %s"] = "%s，%s",
	["Cursor"] = "鼠標",
	["Screen"] = "螢幕",
	["Top"] = "上",
	["Top-left"] = "左上",
	["Top-right"] = "右上",
	["Right"] = "右",
	["Left"] = "左",
	["Bottom"] = "下",
	["Bottom-left"] = "左下",
	["Bottom-right"] = "右下",
	["Middle"] = "中",
	["Anchor: %s\nClick and drag to the position you want.\nDouble-click when finished."] = "定位點: %s\n點擊和拖動到適當的位置。\n雙擊確認。",
	["Position"] = "位置",
	["Change where the tooltip is located."] = "更改提示訊息的位置。",
	["Click this to bring up an easy-to-use offset box."] = "點擊打開易用位移輸入框。",
	["Adjust"] = "調整",
} or (GetLocale() == "frFR") and {
	["%s, %s"] = "%s, %s",
	["Cursor"] = "Curseur",
	["Screen"] = "Écran",
	["Top"] = "Haut",
	["Top-left"] = "Haut-gauche",
	["Top-right"] = "Haut-droite",
	["Right"] = "Droite",
	["Left"] = "Gauche",
	["Bottom"] = "Bas",
	["Bottom-left"] = "Bas-gauche",
	["Bottom-right"] = "Bas-droite",
	["Middle"] = "Milieu",
	["Anchor: %s\nClick and drag to the position you want.\nDouble-click when finished."] = "Ancrage : %s\nCliquer et saisir vers la position désirée.\nDouble-clic une fois terminé.",
	["Position"] = "Position",
	["Change where the tooltip is located."] = "Modifie la position de l'infobulle.",
	["Click this to bring up an easy-to-use offset box."] = "Cliquez pour afficher une boîte de positionnement facile.",
	["Adjust"] = "Ajuster",
	["Parent frame"] = "Fenêtre parente",
	["Horizontal offset"] = "Décalage horizontal",
	["Offset of the x-axis."] = "Le décalage sur l'axe des X.",
	["Vertical offset"] = "Décalage vertical",
	["Offset of the y-axis."] = "Le décalage sur l'axe des Y.",
	["Anchor"] = "Ancre",
	["The anchor with which the tooltips are located."] = "L'ancre où se positionnent les infobulles.",
	["Set anchor offset"] = "Décalage de l'ancre",
	["Unit"] = "Unité",
	["Options for unit mouseover tooltips"] = "Options concernant les infobulles des unités survolées.",
	["Frame"] = "Fenêtre",
	["Options for frame mouseover tooltips"] = "Options concernant les infobulles des fenêtres survolées.",
} or {}

local L = CowTip:L("CowTip_Position", localization)

local _G = _G
local GetScreenWidth = _G.GetScreenWidth
local GetScreenHeight = _G.GetScreenHeight
local UIParent = _G.UIParent
local CreateFrame = _G.CreateFrame
local GetCursorPosition = _G.GetCursorPosition
local GameTooltip = _G.GameTooltip

function CowTip_Position:OnInitialize()
	self.db = CowTip:GetDatabaseNamespace("Position")
	CowTip:SetDatabaseNamespaceDefaults("Position", "profile", {
		unitAnchor = "CURSOR_BOTTOM",
		unitOffsetX = 0,
		unitOffsetY = 0,
		frameAnchor = "BOTTOMRIGHT",
		frameOffsetX = 0,
		frameOffsetY = 0,
	})
end

function CowTip_Position:OnEnable()
	self:AddHook("GameTooltip_SetDefaultAnchor", "GameTooltip_SetDefaultAnchor", true)
end

function CowTip_Position:OnTooltipHide()
	self:RemoveTimer("CowTip_Position_Update")
end

local currentOffsetX, currentOffsetY = 0, 0
local currentCursorAnchor = "BOTTOM"
local currentAnchorType = "CURSOR"
local currentOwner = UIParent

local anchorOpposite = {
	BOTTOMLEFT = "TOPLEFT",
	BOTTOM = "TOP",
	BOTTOMRIGHT = "TOPRIGHT",
	LEFT = "RIGHT",
	RIGHT = "LEFT",
	TOPLEFT = "BOTTOMLEFT",
	TOP = "BOTTOM",
	TOPRIGHT = "BOTTOMRIGHT",
}

local function ReanchorTooltip()
	GameTooltip:ClearAllPoints()
	local scale = GameTooltip:GetEffectiveScale()
	if currentAnchorType == "PARENT" then
		GameTooltip:SetPoint(currentCursorAnchor, currentOwner, anchorOpposite[currentCursorAnchor], currentOffsetX, currentOffsetY)
	else -- CURSOR
		local x, y = GetCursorPosition()
		x, y = x / scale + currentOffsetX, y / scale + currentOffsetY
		GameTooltip:SetPoint(currentCursorAnchor, UIParent, "BOTTOMLEFT", x, y)
	end
end

function CowTip_Position:GameTooltip_SetDefaultAnchor(this, owner, ...)
	self.hooks.GameTooltip_SetDefaultAnchor(this, owner, ...)
	
	local db = self.db.profile
	
	local anchor, offsetX, offsetY
	currentOwner = owner
	if owner == UIParent then -- world character
		anchor = db.unitAnchor
		offsetX = db.unitOffsetX
		offsetY = db.unitOffsetY
	else -- frame
		anchor = db.frameAnchor
		offsetX = db.frameOffsetX
		offsetY = db.frameOffsetY
	end
	if anchor:find("^CURSOR") or anchor:find("^PARENT") then
		if anchor == "CURSOR_TOP" and math.abs(offsetX) < 1 and math.abs(offsetY) < 0 then
			this:SetOwner(owner, "ANCHOR_CURSOR")
		else
			currentOffsetX = offsetX
			currentOffsetY = offsetY
			currentCursorAnchor = anchor:sub(8)
			currentAnchorType = anchor:sub(1, 6)
			self:AddRepeatingTimer("CowTip_Position_Update", 0, ReanchorTooltip)
			ReanchorTooltip()
		end
	else
		this:SetOwner(owner, "ANCHOR_NONE")
		this:ClearAllPoints()
		this:SetPoint(anchor, UIParent, anchor, offsetX, offsetY)
	end
end

local offsetBox

function CowTip_Position:SetUnitAnchor(value)
	if offsetBox then
		offsetBox:GetScript("OnDoubleClick")(offsetBox, "LeftButton")
	end
	self.db.profile.unitAnchor = value
	self.db.profile.unitOffsetX = 0
	self.db.profile.unitOffsetY = 0
end

function CowTip_Position:SetFrameAnchor(value)
	if offsetBox then
		offsetBox:GetScript("OnDoubleClick")(offsetBox, "LeftButton")
	end
	self.db.profile.frameAnchor = value
	self.db.profile.frameOffsetX = 0
	self.db.profile.frameOffsetY = 0
end

local anchorChoices = {
	CURSOR_BOTTOM = L["%s, %s"]:format(L["Cursor"], L["Top"]),
	CURSOR_BOTTOMRIGHT = L["%s, %s"]:format(L["Cursor"], L["Top-left"]),
	CURSOR_BOTTOMLEFT = L["%s, %s"]:format(L["Cursor"], L["Top-right"]),
	CURSOR_LEFT = L["%s, %s"]:format(L["Cursor"], L["Right"]),
	CURSOR_RIGHT = L["%s, %s"]:format(L["Cursor"], L["Left"]),
	CURSOR_TOP = L["%s, %s"]:format(L["Cursor"], L["Bottom"]),
	CURSOR_TOPRIGHT = L["%s, %s"]:format(L["Cursor"], L["Bottom-left"]),
	CURSOR_TOPLEFT = L["%s, %s"]:format(L["Cursor"], L["Bottom-right"]),
	PARENT_BOTTOM = L["%s, %s"]:format(L["Parent frame"], L["Top"]),
	PARENT_BOTTOMRIGHT = L["%s, %s"]:format(L["Parent frame"], L["Top-right"]),
	PARENT_BOTTOMLEFT = L["%s, %s"]:format(L["Parent frame"], L["Top-left"]),
	PARENT_LEFT = L["%s, %s"]:format(L["Parent frame"], L["Right"]),
	PARENT_RIGHT = L["%s, %s"]:format(L["Parent frame"], L["Left"]),
	PARENT_TOP = L["%s, %s"]:format(L["Parent frame"], L["Bottom"]),
	PARENT_TOPRIGHT = L["%s, %s"]:format(L["Parent frame"], L["Bottom-right"]),
	PARENT_TOPLEFT = L["%s, %s"]:format(L["Parent frame"], L["Bottom-left"]),
	TOPLEFT = L["%s, %s"]:format(L["Screen"], L["Top-left"]),
	TOP = L["%s, %s"]:format(L["Screen"], L["Top"]),
	TOPRIGHT = L["%s, %s"]:format(L["Screen"], L["Top-right"]),
	LEFT = L["%s, %s"]:format(L["Screen"], L["Left"]),
	RIGHT = L["%s, %s"]:format(L["Screen"], L["Right"]),
	BOTTOMLEFT = L["%s, %s"]:format(L["Screen"], L["Bottom-left"]),
	BOTTOM = L["%s, %s"]:format(L["Screen"], L["Bottom"]),
	BOTTOMRIGHT = L["%s, %s"]:format(L["Screen"], L["Bottom-right"]),
	CENTER = L["%s, %s"]:format(L["Screen"], L["Middle"]),
}

local fakeMouse
function CowTip_Position:CreateOffsetBox(kind)
	if not offsetBox then
		offsetBox = CreateFrame("Button", "CowTipOffsetBox", UIParent)
		offsetBox:SetWidth(300)
		offsetBox:SetHeight(100)
		offsetBox:SetFrameStrata("TOOLTIP")
		
		local bg = offsetBox:CreateTexture("CowTipOffsetBoxBackground", "BACKGROUND")
		bg:SetTexture(0.7, 0.4, 0) -- orange
		bg:SetAllPoints(offsetBox)
		
		local text = offsetBox:CreateFontString("CowTipOffsetBoxText", "ARTWORK", "GameFontHighlight")
		offsetBox.text = text
		text:SetPoint("CENTER")
		
		offsetBox:SetScript("OnDoubleClick", function(this)
			-- cleanup
			this:StopMovingOrSizing()
			this:Hide()
			fakeMouse:Hide()
		end)
		
		offsetBox:SetScript("OnDragStart", function(this)
			this:StartMoving()
		end)
		
		offsetBox:SetScript("OnDragStop", function(this)
			local kind = this.kind
			local db = self.db.profile
			local anchor
			if kind == "unit" then
				anchor = db.unitAnchor
			else
				anchor = db.frameAnchor
			end
			local offsetX, offsetY
			if anchor == "BOTTOMLEFT" or anchor == "BOTTOM" or anchor == "BOTTOMRIGHT" then
				offsetY = this:GetBottom()
			elseif anchor == "LEFT" or anchor == "CENTER" or anchor == "RIGHT" then
				local _,y = this:GetCenter()
				offsetY = y - GetScreenHeight()/2/this:GetScale()
			elseif anchor == "TOPLEFT" or anchor == "TOP" or anchor == "TOPRIGHT" then
				offsetY = this:GetTop() - GetScreenHeight()/this:GetScale()
			elseif anchor == "CURSOR_BOTTOM" or anchor == "CURSOR_BOTTOMLEFT" or anchor == "CURSOR_BOTTOMRIGHT" or anchor == "PARENT_BOTTOM" or anchor == "PARENT_BOTTOMLEFT" or anchor == "PARENT_BOTTOMRIGHT" then
				offsetY = this:GetBottom() - GetScreenHeight()/2/this:GetScale()
			elseif anchor == "CURSOR_TOP" or anchor == "CURSOR_TOPLEFT" or anchor == "CURSOR_TOPRIGHT" or anchor == "PARENT_TOP" or anchor == "PARENT_TOPLEFT" or anchor == "PARENT_TOPRIGHT" then
				offsetY = this:GetTop() - GetScreenHeight()/2/this:GetScale()
			elseif anchor == "CURSOR_LEFT" or anchor == "CURSOR_RIGHT" or anchor == "PARENT_LEFT" or anchor == "PARENT_RIGHT" then
				local _,y = this:GetCenter()
				offsetY = y - GetScreenHeight()/2/this:GetScale()
			end
			if anchor == "TOPLEFT" or anchor == "LEFT" or anchor == "BOTTOMLEFT" then
				offsetX = this:GetLeft()
			elseif anchor == "TOP" or anchor == "CENTER" or anchor == "BOTTOM" then
				offsetX = this:GetCenter() - GetScreenWidth()/2/this:GetScale()
			elseif anchor == "TOPRIGHT" or anchor == "RIGHT" or anchor == "BOTTOMRIGHT" then
				offsetX = this:GetRight() - GetScreenWidth()/this:GetScale()
			elseif anchor == "CURSOR_RIGHT" or anchor == "CURSOR_TOPRIGHT" or anchor == "CURSOR_BOTTOMRIGHT" or anchor == "PARENT_RIGHT" or anchor == "PARENT_TOPRIGHT" or anchor == "PARENT_BOTTOMRIGHT" then
				offsetX = this:GetRight() - GetScreenWidth()/2/this:GetScale()
			elseif anchor == "CURSOR_LEFT" or anchor == "CURSOR_TOPLEFT" or anchor == "CURSOR_BOTTOMLEFT" or anchor == "PARENT_LEFT" or anchor == "PARENT_TOPLEFT" or anchor == "PARENT_BOTTOMLEFT" then
				offsetX = this:GetLeft() - GetScreenWidth()/2/this:GetScale()
			elseif anchor == "CURSOR_TOP" or anchor == "CURSOR_BOTTOM" or anchor == "PARENT_TOP" or anchor == "PARENT_BOTTOM" then
				offsetX = this:GetCenter() - GetScreenWidth()/2/this:GetScale()
			end
			if kind == "unit" then
				db.unitOffsetX = offsetX
				db.unitOffsetY = offsetY
			else
				db.frameOffsetX = offsetX
				db.frameOffsetY = offsetY
			end
			-- save
			this:StopMovingOrSizing()
		end)
		
		offsetBox:SetMovable(true)
		offsetBox:RegisterForDrag("LeftButton")
		offsetBox:Hide()
		
		fakeMouse = CreateFrame("Frame", "CowTipOffsetBoxFakeMouse", UIParent)
		fakeMouse:SetWidth(1)
		fakeMouse:SetHeight(1)
		fakeMouse:SetPoint("CENTER")
		local tex = fakeMouse:CreateTexture(nil, "ARTWORK")
		tex:SetTexture("Interface\\CURSOR\\Cast")
		tex:SetPoint("TOPLEFT", fakeMouse, "TOPLEFT")
		fakeMouse:Hide()
	end
	
	offsetBox:Show()
	offsetBox:SetScale(GameTooltip:GetScale())
	
	local anchor, offsetX, offsetY
	offsetBox.kind = kind
	local db = self.db.profile
	if kind == "unit" then
		anchor = db.unitAnchor
		offsetX = db.unitOffsetX
		offsetY = db.unitOffsetY
	else
		anchor = db.frameAnchor
		offsetX = db.frameOffsetX
		offsetY = db.frameOffsetY
	end
	
	offsetBox:ClearAllPoints()
	offsetBox.text:SetText(L["Anchor: %s\nClick and drag to the position you want.\nDouble-click when finished."]:format(anchorChoices[anchor]))
	if anchor:find("^CURSOR") or anchor:find("^PARENT") then
		offsetBox:SetPoint(anchor:sub(8), UIParent, "CENTER", offsetX, offsetY)
		fakeMouse:Show()
	else
		offsetBox:SetPoint(anchor, UIParent, anchor, offsetX, offsetY)
	end
	offsetBox:SetClampedToScreen(true)
end

local anchorChoices_withoutParent = {}
for k,v in pairs(anchorChoices) do
	if not k:find("^PARENT_") then
		anchorChoices_withoutParent[k] = v
	end
end

local function x_min()
	return -math.floor(GetScreenWidth()/5 + 0.5) * 5
end

local function x_max()
	return math.floor(GetScreenWidth()/5 + 0.5) * 5
end

local function y_min()
	return -math.floor(GetScreenHeight()/5 + 0.5) * 5
end

local function y_max()
	return math.floor(GetScreenHeight()/5 + 0.5) * 5
end

local args = {
	anchor = {
		type = 'choice',
		name = L["Anchor"],
		desc = L["The anchor with which the tooltips are located."],
		get = function(key)
			return CowTip_Position.db.profile[key .. 'Anchor']
		end,
		set = function(key, value)
			if key == 'unit' then
				self:SetUnitAnchor(value)
			else
				self:SetFrameAnchor(value)
			end
		end,
		choices = function(key)
			if key == 'unit' then
				return anchorChoices_withoutParent
			else
				return anchorChoices
			end
		end,
		order = 1,
	},
	offset = {
		type = 'execute',
		name = L["Set anchor offset"],
		desc = L["Click this to bring up an easy-to-use offset box."],
		func = "CreateOffsetBox",
		buttonText = L["Adjust"],
		order = 2,
	},
	x = {
		type = 'number',
		name = L["Horizontal offset"],
		desc = L["Offset of the x-axis."],
		min = x_min,
		max = x_max,
		step = 1,
		bigStep = 5,
		get = function(key)
			return self.db.profile[key .. "OffsetX"]
		end,
		set = function(key, value)
			self.db.profile[key .. "OffsetX"] = value
			if offsetBox and offsetBox:IsShown() and offsetBox.kind == key then
				local anchor = self.db.profile.unitAnchor
				if anchor:find("^CURSOR") or anchor:find("^PARENT") then
					offsetBox:SetPoint(anchor:sub(8), UIParent, "CENTER", value, self.db.profile.unitOffsetY)
				else
					offsetBox:SetPoint(anchor, UIParent, anchor, value, self.db.profile.unitOffsetY)
				end
			end
		end,
		order = 3,
	},
	y = {
		type = 'number',
		name = L["Vertical offset"],
		desc = L["Offset of the y-axis."],
		min = y_min,
		max = y_max,
		step = 1,
		bigStep = 5,
		get = function(key)
			return self.db.profile[key .. "OffsetY"]
		end,
		set = function(key, value)
			self.db.profile[key .. "OffsetY"] = value
			if offsetBox and offsetBox:IsShown() and offsetBox.kind == key then
				local anchor = self.db.profile.unitAnchor
				if anchor:find("^CURSOR") or anchor:find("^PARENT") then
					offsetBox:SetPoint(anchor:sub(8), UIParent, "CENTER", self.db.profile.unitOffsetX, value)
				else
					offsetBox:SetPoint(anchor, UIParent, anchor, self.db.profile.unitOffsetX, value)
				end
			end
		end,
		order = 4,
	},
}

CowTip_Position:RegisterCowTipOption({
	name = L["Position"],
	desc = L["Change where the tooltip is located."],
	type = 'group',
	args = {
		unit = {
			type = 'group',
			groupType = 'inline',
			name = L["Unit"],
			desc = L["Options for unit mouseover tooltips"],
			child_passValue = 'unit',
			args = args
		},
		frame = {
			type = 'group',
			groupType = 'inline',
			name = L["Frame"],
			desc = L["Options for frame mouseover tooltips"],
			child_passValue = 'frame',
			args = args
		}
	}
})