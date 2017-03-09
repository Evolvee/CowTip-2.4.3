if select(6, GetAddOnInfo("CowTip_" .. (debugstack():match("[C%.][o%.][w%.]Tip\\Modules\\(.-)\\") or debugstack():match("[C%.][o%.][w%.]Tip\\(.-)\\") or ""))) ~= "MISSING" then return end

local VERSION = tonumber(("$Revision: 62835 $"):match("%d+"))

local CowTip = CowTip
local CowTip_PowerBar = CowTip:NewModule("PowerBar", "LibRockEvent-1.0")
local self = CowTip_PowerBar
if CowTip.revision < VERSION then
	CowTip.version = "r" .. VERSION
	CowTip.revision = VERSION
	CowTip.date = ("$Date: 2008-02-25 00:24:33 -0500 (Mon, 25 Feb 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")
end
CowTip_PowerBar.desc = "Allow for a power bar on the tooltip"

local localization = (GetLocale() == "koKR") and {
	["Power bar"] = "파워 막대",
	["Change settings for the power bar."] = "파워 막대에 대한 설정을 변경합니다.",
	["Size"] = "크기",
	["The size of the power bar."] = "파워 막대의 크기입니다.",
	["Position"] = "위치",
	["The position of the power bar relative to the tooltip."] = "툴팁에서 파워 막대의 위치입니다.",
	["Texture"] = "무늬",
	["The texture which the power bar uses."] = "파워 막대에 사용할 무늬입니다.",
	["Left"] = "왼쪽",
	["Right"] = "오른쪽",
	["Top"] = "위",
	["Bottom"] = "아래",
} or (GetLocale() == "zhCN") and {
	["Power bar"] = "法力条",
	["Change settings for the power bar."] = "更改法力条的设置。",
	["Size"] = "大小",
	["The size of the power bar."] = "更改法力条的大小。",
	["Position"] = "位置",
	["The position of the power bar relative to the tooltip."] = "更改法力条应在提示信息框上哪个位置。",
	["Texture"] = "贴图",
	["The texture which the power bar uses."] = "更改法力条所用的贴图。",
	["Left"] = "左",
	["Right"] = "右",
	["Top"] = "上",
	["Bottom"] = "下",
} or (GetLocale() == "zhTW") and {
	["Power bar"] = "能力條",
	["Change settings for the power bar."] = "更改能力條設定。",
	["Size"] = "大小",
	["The size of the power bar."] = "能力條的大小。",
	["Position"] = "位置",
	["The position of the power bar relative to the tooltip."] = "能力條相對於提示訊息的位置。",
	["Texture"] = "紋理",
	["The texture which the power bar uses."] = "能力條的紋理。",
	["Left"] = "左",
	["Right"] = "右",
	["Top"] = "上",
	["Bottom"] = "下",
} or (GetLocale() == "frFR") and {
	["Power bar"] = "Barre de puissance",
	["Change settings for the power bar."] = "Modifie les paramètres de la barre de puissance.",
	["Size"] = "Taille",
	["The size of the power bar."] = "La taille de la barre de puissance.",
	["Position"] = "Position",
	["The position of the power bar relative to the tooltip."] = "La position de la barre de puissance par rapport à l'infobulle.",
	["Texture"] = "Texture",
	["The texture which the power bar uses."] = "La texture à utiliser pour la barre de puissance.",
	["Left"] = "Gauche",
	["Right"] = "Droite",
	["Top"] = "Haut",
	["Bottom"] = "Bas",
} or {}

local L = CowTip:L("CowTip_PowerBar", localization)

local SharedMedia = Rock("LibSharedMedia-3.0")

local _G = _G
local UnitIsUnit = _G.UnitIsUnit
local CreateFrame = _G.CreateFrame
local GameTooltip = _G.GameTooltip
local UnitManaMax = _G.UnitManaMax
local UnitMana = _G.UnitMana
local UnitPowerType = _G.UnitPowerType

local powerBar
function CowTip_PowerBar:OnInitialize()
	self.db = CowTip:GetDatabaseNamespace("PowerBar")
	CowTip:SetDatabaseNamespaceDefaults("PowerBar", "profile", {
		size = 5,
		position = "BOTTOM",
		texture = "Blizzard",
	})
end

function CowTip_PowerBar:OnEnable(first)
	self:AddEventListener("UNIT_MANA")
	self:AddEventListener("UNIT_RAGE", "UNIT_MANA")
	self:AddEventListener("UNIT_FOCUS", "UNIT_MANA")
	self:AddEventListener("UNIT_ENERGY", "UNIT_MANA")
	self:AddEventListener("UNIT_RUNIC_POWER", "UNIT_MANA")
	self:AddEventListener("UNIT_MAXMANA", "UNIT_MANA")
	self:AddEventListener("UNIT_MAXRAGE", "UNIT_MANA")
	self:AddEventListener("UNIT_MAXFOCUS", "UNIT_MANA")
	self:AddEventListener("UNIT_MAXENERGY", "UNIT_MANA")
	self:AddEventListener("UNIT_MAXRUNIC_POWER", "UNIT_MANA")
	self:AddEventListener("UNIT_DISPLAYPOWER", "UNIT_MANA")
	SharedMedia.RegisterCallback(self, "LibSharedMedia_Registered")
	
	self:Reposition()
	if CowTip:HasModule("HealthBar") and CowTip:IsModuleActive("HealthBar") then
		CowTip:GetModule("HealthBar"):Reposition()
	end
end

function CowTip_PowerBar:OnDisable()
	if powerBar then
		powerBar:Hide()
		powerBar.side = nil
	end
	
	if CowTip:HasModule("HealthBar") and CowTip:IsModuleActive("HealthBar") then
		CowTip:GetModule("HealthBar"):Reposition()
	end
end

-- LibSharedMedia-3.0 Callback
function CowTip_PowerBar:LibSharedMedia_Registered(event, kind, name)
	if powerBar and kind == "statusbar" then
		powerBar:SetStatusBarTexture(SharedMedia:Fetch('statusbar', self.db.profile.texture))
	end
end

function CowTip_PowerBar:UNIT_MANA(ns, event, unit)
	if not UnitIsUnit(unit, "mouseover") then
		return
	end
	
	self:Update()
end

function CowTip_PowerBar:OnTooltipShow()
	if not powerBar then
		powerBar = CreateFrame("StatusBar", "CowTip_PowerBar_Bar", GameTooltip)
		powerBar:SetStatusBarTexture(SharedMedia:Fetch('statusbar', self.db.profile.texture))
		powerBar:SetMinMaxValues(0, 1)
		self:Reposition()
		if CowTip:HasModule("HealthBar") and CowTip:IsModuleActive("HealthBar") then
			CowTip:GetModule("HealthBar"):Reposition()
		end
	end
	
	if not GameTooltip:GetUnit() then
		powerBar:Hide()
		return
	end
	
	powerBar:Show()
	
	self:Update()
end

function CowTip_PowerBar:OnTooltipHide()
	if not powerBar then
		return
	end
	powerBar:Hide()
end

function CowTip_PowerBar:Update()
	if not powerBar then
		return
	end
	local max = UnitManaMax("mouseover")
	local value
	if max == 0 then
		value = 0
	else
		value = UnitMana("mouseover") / max
	end
	powerBar:SetValue(value)
	local powerType = UnitPowerType("mouseover")
	if powerType == 0 then
		-- mana
		powerBar:SetStatusBarColor(48/255, 113/255, 191/255)
	elseif powerType == 1 then
		-- rage
		powerBar:SetStatusBarColor(226/255, 45/255, 75/255)
	elseif powerType == 2 then
		-- focus
		powerBar:SetStatusBarColor(1, 210/255, 0)
    elseif powerType == 6 then
		-- runic power
		powerBar:SetStatusBarColor(48/255, 113/255, 191/255)
	else
		-- energy
		powerBar:SetStatusBarColor(1, 220/255, 25/255)
	end
end

function CowTip_PowerBar:SetSize(size)
	self.db.profile.size = size
	if not powerBar then
		return
	end
	powerBar:SetHeight(size)
end

function CowTip_PowerBar:Reposition()
	if not CowTip:IsModuleActive(self) or not powerBar then
		return
	end
	local position = self.db.profile.position
	
	powerBar:SetWidth(0)
	powerBar:SetHeight(0)
	powerBar:ClearAllPoints()
	powerBar.side = position
	if position == "TOP" then
		powerBar:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 4, 0)
		powerBar:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -4, 0)
		powerBar:SetHeight(self.db.profile.size)
		powerBar:SetOrientation("HORIZONTAL")
	elseif position == "BOTTOM" then
		local healthBar = _G.CowTip_HealthBar_Bar
		if healthBar and healthBar.side == "BOTTOM" then
			powerBar:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT")
			powerBar:SetPoint("TOPRIGHT", healthBar, "BOTTOMRIGHT")
		else
			powerBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 4, 0)
			powerBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -4, 0)
		end
		powerBar:SetHeight(self.db.profile.size)
		powerBar:SetOrientation("HORIZONTAL")
	elseif position == "LEFT" then
		powerBar:SetPoint("TOPRIGHT", GameTooltip, "TOPLEFT", 0, -4)
		powerBar:SetPoint("BOTTOMRIGHT", GameTooltip, "BOTTOMLEFT", 0, 4)
		powerBar:SetWidth(self.db.profile.size)
		powerBar:SetOrientation("VERTICAL")
	elseif position == "RIGHT" then
		local healthBar = _G.CowTip_HealthBar_Bar
		if healthBar and healthBar.side == "RIGHT" then
			powerBar:SetPoint("TOPLEFT", healthBar, "TOPRIGHT")
			powerBar:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMRIGHT")
		else
			powerBar:SetPoint("TOPLEFT", GameTooltip, "TOPRIGHT", 0, -4)
			powerBar:SetPoint("BOTTOMLEFT", GameTooltip, "BOTTOMRIGHT", 0, 4)
		end
		powerBar:SetWidth(self.db.profile.size)
		powerBar:SetOrientation("VERTICAL")
	end
end

function CowTip_PowerBar:SetPosition(position)
	self.db.profile.position = position
	if not powerBar then
		return
	end
	self:Reposition()
	if CowTip:HasModule("HealthBar") and CowTip:IsModuleActive("HealthBar") then
		CowTip:GetModule("HealthBar"):Reposition()
	end
end

function CowTip_PowerBar:SetTexture(value)
	self.db.profile.texture = value
	if not powerBar then
		return
	end
	powerBar:SetStatusBarTexture(SharedMedia:Fetch('statusbar', value))
end

CowTip_PowerBar:RegisterCowTipOption({
	name = L["Power bar"],
	desc = L["Change settings for the power bar."],
	type = 'group',
	args = {
		size = {
			type = 'number',
			name = L["Size"],
			desc = L["The size of the power bar."],
			get = function()
				return CowTip_PowerBar.db.profile.size
			end,
			set = "SetSize",
			min = 1,
			max = 20,
			step = 1,
		},
		position = {
			type = 'choice',
			name = L["Position"],
			desc = L["The position of the power bar relative to the tooltip."],
			get = function()
				return CowTip_PowerBar.db.profile.position
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
			desc = L["The texture which the power bar uses."],
			get = function()
				return CowTip_PowerBar.db.profile.texture
			end,
			set = "SetTexture",
			choices = SharedMedia:List('statusbar'),
			choiceTextures = SharedMedia:HashTable('statusbar'),
		},
	}
})