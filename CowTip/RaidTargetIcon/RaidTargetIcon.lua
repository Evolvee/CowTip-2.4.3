if select(6, GetAddOnInfo("CowTip_" .. (debugstack():match("[C%.][o%.][w%.]Tip\\Modules\\(.-)\\") or debugstack():match("[C%.][o%.][w%.]Tip\\(.-)\\") or ""))) ~= "MISSING" then return end

local VERSION = tonumber(("$Revision: 60160 $"):match("%d+"))

local CowTip = CowTip
local CowTip_RaidTargetIcon = CowTip:NewModule("RaidTargetIcon", "LibRockEvent-1.0")
local self = CowTip_PowerBar
if CowTip.revision < VERSION then
	CowTip.version = "r" .. VERSION
	CowTip.revision = VERSION
	CowTip.date = ("$Date: 2008-02-03 18:25:10 +0000 (Sun, 03 Feb 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")
end
CowTip.desc = "Show an icon on the toltip based on which Raid Target the unit is."

local localization = (GetLocale() == "koKR") and {
	["Raid target icon"] = "공격대 대상 아이콘",
	["Change how the raid target icon shows."] = "공격대 대상 아이콘의 표시를 변경합니다.",
	["Position"] = "위치",
	["Position of the raid target icon."] = "공격대 대상 아이콘의 위치입니다.",
	["Size"] = "크기",
	["Size of the raid target icon."] = "공격대 대상 아이콘의 크기입니다.",
	["Left"] = "왼쪽",
	["Right"] = "오른쪽",
	["Top"] = "위",
	["Bottom"] = "아래",
	["Top-left"] = "왼쪽-위",
	["Top-right"] = "오른쪽-위",
	["Bottom-left"] = "왼쪽-아래",
	["Bottom-right"] = "오른쪽-아래",
} or (GetLocale() == "zhCN") and {
	["Raid target icon"] = "团队标志",
	["Change how the raid target icon shows."] = "更改团队标志显示的方式。",
	["Position"] = "位置",
	["Position of the raid target icon."] = "更改团队标志显示的位置。",
	["Size"] = "大小",
	["Size of the raid target icon."] = "更改团队标志显示的大小。",
	["Left"] = "左",
	["Right"] = "右",
	["Top"] = "上",
	["Bottom"] = "下",
	["Top-left"] = "左上",
	["Top-right"] = "右上",
	["Bottom-left"] = "左下",
	["Bottom-right"] = "右下",
} or (GetLocale() == "zhTW") and {
	["Raid target icon"] = "團隊圖示",
	["Change how the raid target icon shows."] = "更改顯示團隊圖示設定。",
	["Position"] = "位置",
	["Position of the raid target icon."] = "團隊圖示的位置。",
	["Size"] = "大小",
	["Size of the raid target icon."] = "團隊圖示的大小。",
	["Left"] = "左",
	["Right"] = "右",
	["Top"] = "上",
	["Bottom"] = "下",
	["Top-left"] = "左上",
	["Top-right"] = "右上",
	["Bottom-left"] = "左下",
	["Bottom-right"] = "右下",
} or (GetLocale() == "frFR") and {
	["Raid target icon"] = "Icône de cible de raid",
	["Change how the raid target icon shows."] = "Modifie la façon dont est affiché l'icône de cible de raid.",
	["Position"] = "Position",
	["Position of the raid target icon."] = "La position de l'icône de cible de raid.",
	["Size"] = "Taille",
	["Size of the raid target icon."] = "La taille de l'icône de cible de raid.",
	["Left"] = "Gauche",
	["Right"] = "Droite",
	["Top"] = "Haut",
	["Bottom"] = "Bas",
	["Top-left"] = "Haut-gauche",
	["Top-right"] = "Haut-droite",
	["Bottom-left"] = "Bas-gauche",
	["Bottom-right"] = "Bas-droite",
} or {}

local L = CowTip:L("CowTip_RaidTargetIcon", localization)

local _G = _G
local GameTooltip = _G.GameTooltip
local UnitExists = _G.UnitExists
local GetRaidTargetIndex = _G.GetRaidTargetIndex
local SetRaidTargetIconTexture = _G.SetRaidTargetIconTexture

function CowTip_RaidTargetIcon:OnInitialize()
	self.db = CowTip:GetDatabaseNamespace("RaidTargetIcon")
	CowTip:SetDatabaseNamespaceDefaults("RaidTargetIcon", "profile", {
		position = "TOP",
		size = 20,
	})
end

local raidTargetIcon

function CowTip_RaidTargetIcon:OnEnable()
	self:AddEventListener("RAID_TARGET_UPDATE")
end

function CowTip_RaidTargetIcon:OnDisable()
	if raidTargetIcon then
		raidTargetIcon:Hide()
	end
end

function CowTip_RaidTargetIcon:Update()
	if not raidTargetIcon then
		raidTargetIcon = GameTooltip:CreateTexture("CowTip_RaidTargetIcon_Icon", "ARTWORK")
		raidTargetIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
		raidTargetIcon:Hide()
		raidTargetIcon:SetWidth(self.db.profile.size)
		raidTargetIcon:SetHeight(self.db.profile.size)
		self:Reposition()
	end
	if not GameTooltip:GetUnit() then
		raidTargetIcon:Hide()
		return
	end
	if not UnitExists("mouseover") then
		return
	end
	local index = GetRaidTargetIndex("mouseover")
	if index then
		SetRaidTargetIconTexture(raidTargetIcon, index)
		raidTargetIcon:Show()
	else
		raidTargetIcon:Hide()
	end
end

function CowTip_RaidTargetIcon:OnTooltipShow()
	self:Update()
end

function CowTip_RaidTargetIcon:RAID_TARGET_UPDATE()
	self:Update()
end

function CowTip_RaidTargetIcon:Reposition()
	if not raidTargetIcon then
		return
	end
	raidTargetIcon:SetPoint("CENTER", GameTooltip, self.db.profile.position)
end

function CowTip_RaidTargetIcon:SetPosition(value)
	self.db.profile.position = value
	
	self:Reposition()
end

function CowTip_RaidTargetIcon:SetSize(value)
	self.db.profile.size = value
	
	if raidTargetIcon then
		raidTargetIcon:SetWidth(value)
		raidTargetIcon:SetHeight(value)
	end
end

CowTip_RaidTargetIcon:RegisterCowTipOption({
	name = L["Raid target icon"],
	desc = L["Change how the raid target icon shows."],
	type = 'group',
	args = {
		position = {
			name = L["Position"],
			desc = L["Position of the raid target icon."],
			type = 'choice',
			get = function()
				return CowTip_RaidTargetIcon.db.profile.position
			end,
			set = "SetPosition",
			choices = {
				LEFT = L["Left"],
				RIGHT = L["Right"],
				TOP = L["Top"],
				BOTTOM = L["Bottom"],
				TOPLEFT = L["Top-left"],
				TOPRIGHT = L["Top-right"],
				BOTTOMLEFT = L["Bottom-left"],
				BOTTOMRIGHT = L["Bottom-right"],
			}
		},
		size = {
			name = L["Size"],
			desc = L["Size of the raid target icon."],
			type = 'number',
			get = function()
				return CowTip_RaidTargetIcon.db.profile.size
			end,
			set = "SetSize",
			min = 5,
			max = 50,
			step = 1,
			bigStep = 5,
		}
	}
})
