if select(6, GetAddOnInfo("CowTip_" .. (debugstack():match("[C%.][o%.][w%.]Tip\\Modules\\(.-)\\") or debugstack():match("[C%.][o%.][w%.]Tip\\(.-)\\") or ""))) ~= "MISSING" then return end

local VERSION = tonumber(("$Revision: 62844 $"):match("%d+"))

local CowTip = CowTip
local CowTip_Fade = CowTip:NewModule("Fade", "LibRockEvent-1.0", "LibRockHook-1.0", "LibRockTimer-1.0")

local self = CowTip_Fade
if CowTip.revision < VERSION then
	CowTip.version = "r" .. VERSION
	CowTip.revision = VERSION
	CowTip.date = ("$Date: 2008-02-25 08:30:23 +0000 (Mon, 25 Feb 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")
end
CowTip_Fade.desc = "Allow for positioning of the tooltip"

local localization = (GetLocale() == "koKR") and {
	["Immediate hide"] = "즉시 사라짐",
	["Fade out"] = "서서히 사라짐",
	["Fade"] = "사라짐",
	["Change how the tooltip fades."] = "툴팁이 사라지는 방법을 변경합니다.",
	["World units"] = "월드 유닛",
	["What kind of fade to use for world units (other players, non-player characters in the world, etc.)"] = "월드 유닛의 사라짐 방법을 선택합니다. (월드 내 다른 플레이어, NPC, 등.)",
	["World objects"] = "월드 객체",
	["What kind of fade to use for world objects (mailboxes, corpses, etc.)"] = "월드 객체의 사라짐 방법을 선택합니다. (우편함, 시체, 등.)",
	["Note: some objects cannot fade out immediately and a lag may be noticed from between the time you move your cursor away and hide."] = "경고: 당신의 마우스 커서가 움직이거나 사라지는 시간에 렉이 발생 되어, 종종 객체가 즉시 사라지지 않을 수 있습니다.",
	["Unit frames"] = "유닛 프레임",
	["What kind of fade to use for unit frames."] = "유닛 프레임의 사라짐 방법을 선택합니다.",
	["Non-unit frames"] = "비유닛 프레임",
	["What kind of fade to use for non-unit frames (spells, items, etc.)"] = "비유닛 프레임의 사라짐 방법을 선택합니다. (주문, 아이템, 등.)",
} or (GetLocale() == "zhCN") and {
	["Immediate hide"] = "立刻隐藏",
	["Fade out"] = "淡出",
	["Fade"] = "提示框消失",
	["Change how the tooltip fades."] = "设定提示信息框消失的形式。",
	["World units"] = "世界单位",
	["What kind of fade to use for world units (other players, non-player characters in the world, etc.)"] = "世界中其他玩家或者NPC的提示信息消失的形式。",
	["World objects"] = "世界物品",
	["What kind of fade to use for world objects (mailboxes, corpses, etc.)"] = "世界中各种物体，例如邮箱，尸体等的提示信息消失的形式。",
	["Unit frames"] = "对象框架",
	["What kind of fade to use for unit frames."] = "自己或者队友等的提示信息消失的形式。",
	["Non-unit frames"] = "非对象框架",
	["What kind of fade to use for non-unit frames (spells, items, etc.)"] = "法术或者背包内物品等的提示信息消失的形式。",
} or (GetLocale() == "zhTW") and {
	["Immediate hide"] = "立即隱藏",
	["Fade out"] = "淡出",
	["Fade"] = "消失",
	["Change how the tooltip fades."] = "更改提示訊息消失方法。",
	["World units"] = "世界單位",
	["What kind of fade to use for world units (other players, non-player characters in the world, etc.)"] = "世界單位 (其他玩家，NPC...) 的消失方法。",
	["World objects"] = "世界物件",
	["What kind of fade to use for world objects (mailboxes, corpses, etc.)"] = "世界物件 (郵箱，屍體...) 的消失方法。",
	["Unit frames"] = "單位框架",
	["What kind of fade to use for unit frames."] = "單位框架的消失方法。",
	["Non-unit frames"] = "非單位框架",
	["What kind of fade to use for non-unit frames (spells, items, etc.)"] = "非單位框架 (法術，物品...) 的消失方法。",
} or (GetLocale() == "frFR") and {
	["Immediate hide"] = "Masquer immédiatement",
	["Fade out"] = "Fondu progressif",
	["Fade"] = "Disparition",
	["Change how the tooltip fades."] = "Modifie la façon dont l'infobulle disparaît.",
	["World units"] = "Unités du jeu",
	["What kind of fade to use for world units (other players, non-player characters in the world, etc.)"] = "Détermine le type de fondu à utiliser pour les unités du jeu (les autres joueurs, les PNJs, etc.)",
	["World objects"] = "Objets du jeu",
	["What kind of fade to use for world objects (mailboxes, corpses, etc.)"] = "Détermine le type de fondu à utiliser pour les objets du jeu (boîtes aux lettres, cadavres, etc.)",
	["Unit frames"] = "Fenêtres d'unité",
	["What kind of fade to use for unit frames."] = "Détermine le type de fondu à utiliser pour les fenêtres d'unité.",
	["Non-unit frames"] = "Fenêtres de non-unité",
	["What kind of fade to use for non-unit frames (spells, items, etc.)"] = "Détermine le type de fondu à utiliser pour les fenêtres de non-unité (sorts, objets, etc.).",
} or {}

local L = CowTip:L("CowTip_Fade", localization)

local _G = _G
local GetScreenWidth = _G.GetScreenWidth
local GetScreenHeight = _G.GetScreenHeight
local UIParent = _G.UIParent
local CreateFrame = _G.CreateFrame
local GetCursorPosition = _G.GetCursorPosition
local UnitExists = _G.UnitExists
local GameTooltip = _G.GameTooltip

function CowTip_Fade:OnInitialize()
	self.db = CowTip:GetDatabaseNamespace("Fade")
	CowTip:SetDatabaseNamespaceDefaults("Fade", "profile", {
		units = "fade",
		objects = "fade",
		unitFrames = "hide",
		otherFrames = "hide",
	})
end

function CowTip_Fade:OnEnable()
	self:AddHook(GameTooltip, 'Hide', "GameTooltip_Hide")
	self:AddHook(GameTooltip, 'FadeOut', "GameTooltip_FadeOut")
	
	self:AddEventListener("CURSOR_UPDATE")
end

function CowTip_Fade:GameTooltip_Hide(this, ...)
	if this.justHide then
		return self.hooks[this].Hide(this, ...)
	end
	local kind
	if GameTooltip:GetUnit() then
		if GameTooltip:IsOwned(UIParent) then -- world unit
			kind = CowTip_Fade.db.profile.units
		else
			kind = CowTip_Fade.db.profile.unitFrames
		end
	else
		if GameTooltip:IsOwned(UIParent) then -- world object
			kind = CowTip_Fade.db.profile.objects
		else
			kind = CowTip_Fade.db.profile.otherFrames
		end
	end
	if kind == "fade" then
		return GameTooltip:FadeOut()
	else
		return self.hooks[this].Hide(this, ...)
	end
end

function CowTip_Fade:GameTooltip_FadeOut(this, ...)
	local kind
	if GameTooltip:GetUnit() then
		if GameTooltip:IsOwned(UIParent) then -- world unit
			kind = CowTip_Fade.db.profile.units
		else
			kind = CowTip_Fade.db.profile.unitFrames
		end
	else
		if GameTooltip:IsOwned(UIParent) then -- world object
			kind = CowTip_Fade.db.profile.objects
		else
			kind = CowTip_Fade.db.profile.otherFrames
		end
	end
	if kind == "fade" then
		self.hooks[this].FadeOut(this, ...)
	else
		GameTooltip:Hide()
	end
end

local function CheckUnitExistence()
	if not GameTooltip:GetUnit() or not UnitExists("mouseover") then
		self:RemoveTimer("CowTip_Fade_CheckExistence")
		local kind
		if GameTooltip:IsOwned(UIParent) then -- world unit
			kind = CowTip_Fade.db.profile.units
		else -- unit frames
			kind = CowTip_Fade.db.profile.unitFrames
		end
		if kind == "fade" then
			GameTooltip:FadeOut()
		else
			GameTooltip:Hide()
		end
	end
end

local function CheckTooltipAlpha()
	if GameTooltip:GetAlpha() < 1 then
		self:RemoveTimer("CowTip_Fade_CheckExistence")
		
		local kind
		if GameTooltip:IsOwned(UIParent) then -- world object
			kind = CowTip_Fade.db.profile.objects
		else -- unit frames
			kind = CowTip_Fade.db.profile.otherFrames
		end
		if kind == "fade" then
			GameTooltip:FadeOut()
		else
			GameTooltip:Hide()
		end
	end
end

local cursorChangedWithTooltip = false

function CowTip_Fade:OnTooltipShow()
	self:RemoveTimer("CowTip_Fade_runHide")
	if GameTooltip:GetUnit() then
		self:AddRepeatingTimer("CowTip_Fade_CheckExistence", 0, CheckUnitExistence)
	else
		if GameTooltip:IsOwned(UIParent) and self:HasTimer("CowTip_Fade_CursorUpdate") then
			cursorChangedWithTooltip = true
		end
		self:AddRepeatingTimer("CowTip_Fade_CheckExistence", 0, CheckTooltipAlpha)
	end
end

function CowTip_Fade:OnTooltipHide()
	cursorChangedWithTooltip = nil
	self:RemoveTimer("CowTip_Fade_CheckExistence")
end

local function donothing() end

local function runHide()
	if CowTip_Fade.db.profile.objects == "fade" then
		GameTooltip:FadeOut()
	else
		GameTooltip:Hide()
	end
end

function CowTip_Fade:CURSOR_UPDATE(...)
	if cursorChangedWithTooltip then
		self:AddTimer("CowTip_Fade_runHide", 0, runHide)
	else
		self:AddTimer("CowTip_Fade_CursorUpdate", 0, donothing)
	end
end

local choices = {
	hide = L["Immediate hide"],
	fade = L["Fade out"],
}

local function getFadeKind(style)
	return CowTip_Fade.db.profile[style]
end

local function setFadeKind(style, value)
	CowTip_Fade.db.profile[style] = value
end

CowTip_Fade:RegisterCowTipOption({
	name = L["Fade"],
	desc = L["Change how the tooltip fades."],
	type = 'group',
	child_type = 'choice',
	child_get = getFadeKind,
	child_set = setFadeKind,
	child_choices = choices,
	args = {
		units = {
			name = L["World units"],
			desc = L["What kind of fade to use for world units (other players, non-player characters in the world, etc.)"],
			passValue = "units",
		},
		objects = {
			name = L["World objects"],
			desc = L["What kind of fade to use for world objects (mailboxes, corpses, etc.)"] .. "\n" .. L["Note: some objects cannot fade out immediately and a lag may be noticed from between the time you move your cursor away and hide."],
			passValue = "objects",
		},
		unitFrames = {
			name = L["Unit frames"],
			desc = L["What kind of fade to use for unit frames."],
			passValue = "unitFrames",
		},
		otherFrames = {
			name = L["Non-unit frames"],
			desc = L["What kind of fade to use for non-unit frames (spells, items, etc.)"],
			passValue = "otherFrames",
		},
	}
})
