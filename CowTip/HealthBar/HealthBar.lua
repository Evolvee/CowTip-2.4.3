if select(6, GetAddOnInfo("CowTip_" .. (debugstack():match("[C%.][o%.][w%.]Tip\\Modules\\(.-)\\") or debugstack():match("[C%.][o%.][w%.]Tip\\(.-)\\") or ""))) ~= "MISSING" then return end

local VERSION = tonumber(("$Revision: 62835 $"):match("%d+"))

local CowTip = CowTip
local CowTip_HealthBar = CowTip:NewModule("HealthBar", "LibRockEvent-1.0", "LibRockHook-1.0")
local self = CowTip_HealthBar
if CowTip.revision < VERSION then
	CowTip.version = "r" .. VERSION
	CowTip.revision = VERSION
	CowTip.date = ("$Date: 2008-02-25 00:24:33 -0500 (Mon, 25 Feb 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")
end
CowTip_HealthBar.desc = "Allow for a health bar on the tooltip"

local localization = (GetLocale() == "koKR") and {
	["Health bar"] = "생명력 막대",
	["Change settings for the health bar."] = "생명력 막대에 대한 설정을 변경합니다.",
	["Size"] = "크기",
	["The size of the health bar."] = "생명력 막대의 크기입니다.",
	["Position"] = "위치",
	["The position of the health bar relative to the tooltip."] = "툴팁에서 생명력 막대의 위치입니다.",
	["Texture"] = "무늬",
	["The texture which the health bar uses."] = "생명력 먁대에 사용할 무늬입니다.",
	["Left"] = "왼쪽",
	["Right"] = "오른쪽",
	["Top"] = "위",
	["Bottom"] = "아래",
} or (GetLocale() == "zhCN") and {
	["Health bar"] = "生命条",
	["Change settings for the health bar."] = "更改生命条的设置。",
	["Size"] = "大小",
	["The size of the health bar."] = "更改生命条的大小。",
	["Position"] = "位置",
	["The position of the health bar relative to the tooltip."] = "更改生命条应在提示信息框上哪个位置。",
	["Texture"] = "贴图",
	["The texture which the health bar uses."] = "更改生命条所用的贴图。",
	["Left"] = "左",
	["Right"] = "右",
	["Top"] = "上",
	["Bottom"] = "下",
} or (GetLocale() == "zhTW") and {
	["Health bar"] = "生命力條",
	["Change settings for the health bar."] = "更改生命力條設定。",
	["Size"] = "大小",
	["The size of the health bar."] = "生命力條的大小。",
	["Position"] = "位置",
	["The position of the health bar relative to the tooltip."] = "生命力條相對於提示訊息的位置。",
	["Texture"] = "紋理",
	["The texture which the health bar uses."] = "生命力條的紋理。",
	["Left"] = "左",
	["Right"] = "右",
	["Top"] = "上",
	["Bottom"] = "下",
} or (GetLocale() == "frFR") and {
	["Health bar"] = "Barre de vie",
	["Change settings for the health bar."] = "Modifie les paramètres de la barre de vie.",
	["Size"] = "Taille",
	["The size of the health bar."] = "La taille de la barre de vie.",
	["Position"] = "Position",
	["The position of the health bar relative to the tooltip."] = "La position de la barre de vie par rapport à l'infobulle.",
	["Texture"] = "Texture",
	["The texture which the health bar uses."] = "La texture à utiliser pour la barre de vie.",
	["Left"] = "Gauche",
	["Right"] = "Droite",
	["Top"] = "Haut",
	["Bottom"] = "Bas",
} or {}

local L = CowTip:L("CowTip_HealthBar", localization)

local SharedMedia = Rock("LibSharedMedia-3.0")

local _G = _G
local GameTooltip = _G.GameTooltip
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitIsUnit = _G.UnitIsUnit
local CreateFrame = _G.CreateFrame

local healthBar
function CowTip_HealthBar:OnInitialize()
	self.db = CowTip:GetDatabaseNamespace("HealthBar")
	CowTip:SetDatabaseNamespaceDefaults("HealthBar", "profile", {
		size = 5,
		position = "TOP",
		texture = "Blizzard",
	})
end

function CowTip_HealthBar:OnEnable(first)
	self:AddEventListener("UNIT_HEALTH")
	self:AddEventListener("UNIT_MAXHEALTH", "UNIT_HEALTH")
	SharedMedia.RegisterCallback(self, "LibSharedMedia_Registered")
	
	_G.GameTooltipStatusBar:Hide()
	self:AddScriptHook(GameTooltipStatusBar, "OnShow", function(this) this:Hide() end)
	
	self:Reposition()
	if CowTip:HasModule("PowerBar") and CowTip:IsModuleActive("PowerBar") then
		CowTip:GetModule("PowerBar"):Reposition()
	end
end

function CowTip_HealthBar:OnDisable()
	if healthBar then
		healthBar:Hide()
		healthBar.side = nil
	end
	
	_G.GameTooltipStatusBar:Show()
	
	if CowTip:HasModule("PowerBar") and CowTip:IsModuleActive("PowerBar") then
		CowTip:GetModule("PowerBar"):Reposition()
	end
end

-- LibSharedMedia-3.0 Callback
function CowTip_HealthBar:LibSharedMedia_Registered(event, kind, name)
	if healthBar and kind == "statusbar" then
		healthBar:SetStatusBarTexture(SharedMedia:Fetch('statusbar', self.db.profile.texture))
	end
end

function CowTip_HealthBar:UNIT_HEALTH(ns, event, unit)
	if not UnitIsUnit(unit, "mouseover") then
		return
	end
	
	self:Update()
end

local function HealthGradient(perc)
	local r1, g1, b1
	local r2, g2, b2
	if perc <= 0.5 then
		perc = perc * 2
		r1, g1, b1 = 1, 0, 0
		r2, g2, b2 = 1, 1, 0
	else
		perc = perc * 2 - 1
		r1, g1, b1 = 1, 1, 0
		r2, g2, b2 = 0, 1, 0
	end
	return r1 + (r2-r1)*perc, g1 + (g2-g1)*perc, b1 + (b2-b1)*perc
end

function CowTip_HealthBar:Reposition()
	if not CowTip:IsModuleActive(self) or not healthBar then
		return
	end
	local position = self.db.profile.position
	healthBar:SetWidth(0)
	healthBar:SetHeight(0)
	healthBar:ClearAllPoints()
	healthBar.side = position
	if position == "TOP" then
		local powerBar = _G.CowTip_PowerBar_Bar
		if powerBar and powerBar.side == "TOP" then
			healthBar:SetPoint("BOTTOMLEFT", powerBar, "TOPLEFT")
			healthBar:SetPoint("BOTTOMRIGHT", powerBar, "TOPRIGHT")
		else
			healthBar:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 4, 0)
			healthBar:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -4, 0)
		end
		healthBar:SetHeight(self.db.profile.size)
		healthBar:SetOrientation("HORIZONTAL")
	elseif position == "BOTTOM" then
		healthBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 4, 0)
		healthBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -4, 0)
		healthBar:SetHeight(self.db.profile.size)
		healthBar:SetOrientation("HORIZONTAL")
	elseif position == "LEFT" then
		local powerBar = _G.CowTip_PowerBar_Bar
		if powerBar and powerBar.side == "LEFT" then
			healthBar:SetPoint("TOPRIGHT", powerBar, "TOPLEFT")
			healthBar:SetPoint("BOTTOMRIGHT", powerBar, "BOTTOMLEFT")
		else
			healthBar:SetPoint("TOPRIGHT", GameTooltip, "TOPLEFT", 0, -4)
			healthBar:SetPoint("BOTTOMRIGHT", GameTooltip, "BOTTOMLEFT", 0, 4)
		end
		healthBar:SetWidth(self.db.profile.size)
		healthBar:SetOrientation("VERTICAL")
	elseif position == "RIGHT" then
		healthBar:SetPoint("TOPLEFT", GameTooltip, "TOPRIGHT", 0, -4)
		healthBar:SetPoint("BOTTOMLEFT", GameTooltip, "BOTTOMRIGHT", 0, 4)
		healthBar:SetWidth(self.db.profile.size)
		healthBar:SetOrientation("VERTICAL")
	end
end

function CowTip_HealthBar:OnTooltipShow()
	if not healthBar then
		healthBar = CreateFrame("StatusBar", "CowTip_HealthBar_Bar", GameTooltip)
		healthBar:SetStatusBarTexture(SharedMedia:Fetch('statusbar', self.db.profile.texture))
		healthBar:SetMinMaxValues(0, 1)
		self:Reposition()
		if CowTip:HasModule("PowerBar") and CowTip:IsModuleActive("PowerBar") then
			CowTip:GetModule("PowerBar"):Reposition()
		end
	end
	
	if not GameTooltip:GetUnit() then
		healthBar:Hide()
		return
	end
	
	healthBar:Show()
	
	self:Update()
end

function CowTip_HealthBar:OnTooltipHide()
	if not healthBar then
		return
	end
	healthBar:Hide()
end

function CowTip_HealthBar:Update()
	if not healthBar then
		return
	end
	local max = UnitHealthMax("mouseover")
	local value
	if max == 0 then
		value = 0
	else
		value = UnitHealth("mouseover") / max
	end
	healthBar:SetValue(value)
	healthBar:SetStatusBarColor(HealthGradient(value))
end

function CowTip_HealthBar:SetSize(size)
	self.db.profile.size = size
	if not healthBar then
		return
	end
	healthBar:SetHeight(size)
end

function CowTip_HealthBar:SetPosition(position)
	self.db.profile.position = position
	if not healthBar then
		return
	end
	self:Reposition()
	if CowTip:HasModule("PowerBar") and CowTip:IsModuleActive("PowerBar") then
		CowTip:GetModule("PowerBar"):Reposition()
	end
end

function CowTip_HealthBar:SetTexture(value)
	self.db.profile.texture = value
	if not healthBar then
		return
	end
	healthBar:SetStatusBarTexture(SharedMedia:Fetch('statusbar', value))
end

CowTip_HealthBar:RegisterCowTipOption({
	name = L["Health bar"],
	desc = L["Change settings for the health bar."],
	type = 'group',
	args = {
		size = {
			type = 'number',
			name = L["Size"],
			desc = L["The size of the health bar."],
			get = function()
				return CowTip_HealthBar.db.profile.size
			end,
			set = "SetSize",
			min = 1,
			max = 20,
			step = 1,
		},
		position = {
			type = 'choice',
			name = L["Position"],
			desc = L["The position of the health bar relative to the tooltip."],
			get = function()
				return CowTip_HealthBar.db.profile.position
			end,
			set = "SetPosition",
			choices = {
				LEFT = L["Left"],
				RIGHT = L["Right"],
				TOP = L["Top"],
				BOTTOM = L["Bottom"],
			}
		},
		texture = {
			type = 'choice',
			name = L["Texture"],
			desc = L["The texture which the health bar uses."],
			get = function()
				return CowTip_HealthBar.db.profile.texture
			end,
			set = "SetTexture",
			choices = SharedMedia:List('statusbar'),
			choiceTextures = SharedMedia:HashTable('statusbar'),
		},
	}
})