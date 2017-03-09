local VERSION = tonumber(("$Revision: 65841 $"):match("%d+"))

local CowTip = Rock:NewAddon("CowTip", "LibRockDB-1.0", "LibRockEvent-1.0", "LibRockConsole-1.0", "LibRockHook-1.0", "LibRockModuleCore-1.0", "LibRockConfig-1.0", "LibRockTimer-1.0")
_G.CowTip = CowTip
local self = CowTip
CowTip.version = "3.0r" .. VERSION
CowTip.revision = VERSION
CowTip.date = ("$Date: 2008-03-25 20:28:54 +0000 (Tue, 25 Mar 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")

local _G = _G
local GameTooltip = _G.GameTooltip
local geterrorhandler = _G.geterrorhandler
local pcall = _G.pcall
local ipairs = _G.ipairs
local InCombatLockdown = _G.InCombatLockdown
local UIParent = _G.UIParent
local rawget = _G.rawget
local pairs = _G.pairs
local setmetatable = _G.setmetatable
local type = _G.type

local localeTables = {}
function CowTip:L(name, defaultTable)
	if not localeTables[name] then
		localeTables[name] = setmetatable(defaultTable or {}, {__index = function(self, key)
			self[key] = key
			return key
		end})
	end
	return localeTables[name]
end

local localization = (GetLocale() == "koKR") and {
	["Tooltip of awesomeness. Moo. It'll graze your pasture."] = "두려움이 없는 툴팁입니다. 움머~. 이것은 당신의 방목지에 풀을 뜯어먹을 것입니다.",
	["Waterfall-1.0 is required to access the GUI."] = "GUI 메뉴는 Waterfall-1.0 라이브러리가 필요합니다.",
	["Never"] = "없음",
	["Out of combat"] = "비전투 시",
	["Always"] = "항상",
	["Show tooltips"] = "툴팁 표시",
	["Show tooltips in specific situations only."] = "특정 상황에만 툴팁을 표시합니다.",
	["World units"] = "월드 유닛",
	["Show the tooltip for world units if..."] = "월드 유닛에 대한 툴팁 표시 시점",
	["World objects"] = "월드 객체",
	["Show the tooltip for world objects if..."] = "월드 객체에 대한 툴팁 표시 시점",
	["Unit frames"] = "유닛 프레임",
	["Show the tooltip for unit frames if..."] = "유닛 프레임에 대한 툴팁 표시 시점",
	["Non-unit frames"] = "비유닛 프레임",
	["Show the tooltip for non-unit frames if..."] = "비유닛 프레임에 대한 툴팁 표시 시점",
	["Only show with modifier"] = "특정키를 이용한 보기",
	["Only show tooltip if the specified modifier is being held down."] = "지정된 특정키가 눌러지는 경우에 툴팁을 보이게 합니다.",
	["Enable"] = "사용",
	["Enable this module"] = "해당 모듈을 사용합니다.",
	["No modifier"] = "항상 표시",
	["Alt"] = "알트",
	["Control"] = "콘트롤",
	["Shift"] = "쉬프트",
} or (GetLocale()  == "zhCN") and {
	["Tooltip of awesomeness. Moo. It'll graze your pasture."] = "很牛的提示信息框。哞～～这牛会吃你的草～～",
	["Never"] = "从不显示",
	["Out of combat"] = "只在战斗外显示",
	["Always"] = "总是显示",
	["Show tooltips"] = "提示框显示",
	["Show tooltips in specific situations only."] = "只在指定的情况才显示提示信息。",
	["World units"] = "世界单位",
	["Show the tooltip for world units if..."] = "显示世界中其他玩家或者NPC的提示信息。",
	["World objects"] = "世界物品",
	["Show the tooltip for world objects if..."] = "显示世界中各种物体，例如邮箱，尸体等的提示信息。",
	["Unit frames"] = "对象框架",
	["Show the tooltip for unit frames if..."] = "显示自己或者队友等的提示信息。",
	["Non-unit frames"] = "非对象框架",
	["Show the tooltip for non-unit frames if..."] = "显示法术或者背包内物品等的提示信息。",
	["Only show with modifier"] = "只在按下功能键时显示",
	["Only show tooltip if the specified modifier is being held down."] = "只在指定的功能键按住不动时才显示。",
	["Enable"] = "启用",
	["Enable this module"] = "启用此模块",
	["No modifier"] = "无功能键",
	["Alt"] = "Alt",
	["Control"] = "Ctrl",
	["Shift"] = "Shift",
} or (GetLocale()  == "zhTW") and {
	["Tooltip of awesomeness. Moo. It'll graze your pasture."] = "Tooltip of awesomeness. Moo. It'll graze your pasture.",
	["Never"] = "永不",
	["Out of combat"] = "戰鬥外",
	["Always"] = "總是",
	["Show tooltips"] = "顯示提示訊息",
	["Show tooltips in specific situations only."] = "只在特定的情況顯示提示訊息。",
	["World units"] = "世界單位",
	["Show the tooltip for world units if..."] = "顯示世界單位 (其他玩家，NPC...) 的提示訊息",
	["World objects"] = "世界物件",
	["Show the tooltip for world objects if..."] = "顯示世界物件 (郵箱，屍體...) 的提示訊息",
	["Unit frames"] = "單位框架",
	["Show the tooltip for unit frames if..."] = "顯示單位框架的提示訊息",
	["Non-unit frames"] = "非單位框架",
	["Show the tooltip for non-unit frames if..."] = "顯示非單位框架 (法術，物品...) 的提示訊息",
	["Only show with modifier"] = "只在按下調整鍵時顯示",
	["Only show tooltip if the specified modifier is being held down."] = "只在按下調整鍵時顯示提示訊息",
	["Enable"] = "啟用",
	["Enable this module"] = "啟用此模組",
	["No modifier"] = "無調整鍵",
	["Alt"] = "Alt",
	["Control"] = "Ctrl",
	["Shift"] = "Shift",
} or (GetLocale()  == "frFR") and {
	["Tooltip of awesomeness. Moo. It'll graze your pasture."] = "Infobulles incroyablement incroyables. Meuh. Elles vont paître dans vos pâturages.",
	["Never"] = "Jamais",
	["Out of combat"] = "Hors combat",
	["Always"] = "Toujours",
	["Show tooltips"] = "Afficher les infobulles",
	["Show tooltips in specific situations only."] = "Affiche les infobbules dans des conditions spécifiques uniquement.",
	["World units"] = "Unités du jeu",
	["Show the tooltip for world units if..."] = "Affiche les infobulles des unités du jeu si...",
	["World objects"] = "Objets du jeu",
	["Show the tooltip for world objects if..."] = "Affiche les infobulles des objets du jeu si...",
	["Unit frames"] = "Fenêtres d'unité",
	["Show the tooltip for unit frames if..."] = "Affiche les infobulles des fenêtres d'unité si...",
	["Non-unit frames"] = "Fenêtres de non-unité",
	["Show the tooltip for non-unit frames if..."] = "Affiche les infobulles des fenêtres de non-unité si...",
	["Only show with modifier"] = "Afficher uniquement avec modificateur",
	["Only show tooltip if the specified modifier is being held down."] = "Affiche les infobulles uniquement si le modificateur spécifié est maintenu enfoncé.",
	["Enable"] = "Activer",
	["Enable this module"] = "Active ce module.",
	["No modifier"] = "Pas de modificateur",
	["Alt"] = "Alt",
	["Control"] = "Ctrl",
	["Shift"] = "Shift",
} or {}

local L = CowTip:L("CowTip", localization)

CowTip:SetDatabase("CowTipDB")
CowTip:SetDatabaseDefaults('profile', {
	unitShow = "always",
	unitFrameShow = "always",
	otherFrameShow = "always",
	objectShow = "always",
	modifier = "NONE",
})

local leftGameTooltipStrings, rightGameTooltipStrings = {}, {}
setmetatable(leftGameTooltipStrings, {__index=function(self, key)
	for i = #self, key do
		if i > GameTooltip:NumLines() then
			GameTooltip:AddDoubleLine(' ', ' ')
		end
		leftGameTooltipStrings[i] = _G["GameTooltipTextLeft" .. i]
		rightGameTooltipStrings[i] = _G["GameTooltipTextRight" .. i]
	end
	return self[key]
end})
setmetatable(rightGameTooltipStrings, getmetatable(leftGameTooltipStrings))
CowTip.leftGameTooltipStrings = leftGameTooltipStrings
CowTip.rightGameTooltipStrings = rightGameTooltipStrings
local what  -- for Talismonger

function CowTip:OnInitialize()
	self:SetConfigTable(self.options)
	self:SetConfigSlashCommand('/CowTip', '/Cow')
	
	GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	for i = 1, 50 do
		GameTooltip:AddDoubleLine(' ', ' ')
		leftGameTooltipStrings[i] = _G["GameTooltipTextLeft" .. i]
		rightGameTooltipStrings[i] = _G["GameTooltipTextRight" .. i]
	end
	GameTooltip:Show()
	GameTooltip:Hide()
end

function CowTip:OnEnable()
	self:AddScriptHook(GameTooltip, "OnShow", "GameTooltip_OnShow")
	self:AddScriptHook(GameTooltip, "OnHide", "GameTooltip_OnHide")
	self:AddScriptHook(GameTooltip, "OnTooltipSetUnit", "GameTooltip_OnTooltipSetUnit")
	self:AddScriptHook(GameTooltip, "OnTooltipSetItem", "GameTooltip_OnTooltipSetItem")
	self:AddScriptHook(GameTooltip, "OnTooltipSetSpell", "GameTooltip_OnTooltipSetSpell")
	
	self:AddHook(GameTooltip, "FadeOut", "GameTooltip_FadeOut")
	
	self:AddEventListener("MODIFIER_STATE_CHANGED")
	
	local previousDead = false
	self:AddRepeatingTimer(0.05, function()
		if UnitExists("mouseover") then
			if UnitIsDeadOrGhost("mouseover") then
				if previousDead == false then
					GameTooltip:Hide()
					GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
					GameTooltip:SetUnit("mouseover")
					GameTooltip:Show()
				end
				previousDead = true
			else
				previousDead = false
			end
		else
			previousDead = nil
		end
	end)
end

function CowTip:OnDisable()
	self:GameTooltip_OnHide(GameTooltip)
end

local function OnTooltipMethod(self, method)
	for i = 1, 3 do
		local methodName
		if i == 1 then
		 	methodName = "PreTooltip" .. method
		elseif i == 2 then
			methodName = "OnTooltip" .. method
		else
			methodName = "PostTooltip" .. method
		end
		self:CallMethodOnAllModules(true, methodName)
	end
end

local doneOnTooltipMethod = false

local forgetNextOnTooltipMethod = false
function CowTip:GameTooltip_OnTooltipSetUnit(this, ...)
	doneOnTooltipMethod = true
	self.hooks[this].OnTooltipSetUnit(this, ...)
	
	if forgetNextOnTooltipMethod then
		forgetNextOnTooltipMethod = false
	else
		OnTooltipMethod(self, "SetUnit")
	end
end

function CowTip:GameTooltip_OnTooltipSetItem(this, ...)
	forgetNextOnTooltipMethod = true
	self.hooks[this].OnTooltipSetItem(this, ...)
	
	if forgetNextOnTooltipMethod then
		forgetNextOnTooltipMethod = false
	else
		OnTooltipMethod(self, "SetItem")
	end
end

function CowTip:GameTooltip_OnTooltipSetSpell(this, ...)
	doneOnTooltipMethod = true
	self.hooks[this].OnTooltipSetSpell(this, ...)
	
	if forgetNextOnTooltipMethod then
		forgetNextOnTooltipMethod = false
	else
		OnTooltipMethod(self, "SetSpell")
	end
end

function CowTip:MODIFIER_STATE_CHANGED(ns, event, modifier, down)
	local mod = self.db.profile.modifier
	if mod ~= modifier then
		return
	end
	local frame = GetMouseFocus()
	if frame == WorldFrame or frame == UIParent then
		if not UnitExists("mouseover") then
			GameTooltip:Hide()
			return
		end
		GameTooltip:Hide()
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
		GameTooltip:SetUnit("mouseover")
		GameTooltip:Show()
	else
		local OnLeave, OnEnter = frame:GetScript("OnLeave"), frame:GetScript("OnEnter")
		if OnLeave then
			_G.this = frame
			OnLeave(frame)
			_G.this = nil
		end
		if OnEnter then
			_G.this = frame
			OnEnter(frame)
			_G.this = nil
		end
	end
end

function CowTip:GameTooltip_OnShow(this, ...)
	what = leftGameTooltipStrings[1]:GetText()  -- Store the item for Talismonger to read
	if not doneOnTooltipMethod then
		if this:GetUnit() then
			OnTooltipMethod(self, "SetUnit")
			forgetNextOnTooltipMethod = true
		elseif this:GetItem() then
			OnTooltipMethod(self, "SetItem")
			forgetNextOnTooltipMethod = true
		elseif this:GetSpell() then
			OnTooltipMethod(self, "SetSpell")
			forgetNextOnTooltipMethod = true
		end
	end
	local show
	if this:IsOwned(UIParent) then
		if this:GetUnit() then
			-- world unit
			show = self.db.profile.unitShow
		else
			-- world object
			show = self.db.profile.objectShow
		end
	else
		if this:GetUnit() then
			-- unit frame
			show = self.db.profile.unitFrameShow
		else
			-- non-unit frame
			show = self.db.profile.otherFrameShow
		end
	end
	
	local modifier = self.db.profile.modifier
	if modifier == "ALT" then
		if not IsAltKeyDown() then
			this:Hide()
			return
		end
	elseif modifier == "SHIFT" then
		if not IsShiftKeyDown() then
			this:Hide()
			return
		end
	elseif modifier == "CTRL" then
		if not IsControlKeyDown() then
			this:Hide()
			return
		end
	end
	
	if show == "notcombat" then
		if InCombatLockdown() then
			this.justHide = true
			this:Hide()
			this.justHide = nil
			return
		end
	elseif show == "never" then
		this.justHide = true
		this:Hide()
		this.justHide = nil
		return
	end
	self.hooks[this].OnShow(this, ...)
	
	self:CallMethodOnAllModules(true, "OnTooltipShow")
end

function CowTip:GameTooltip_FadeOut(this, ...)
	self.hooks[this].FadeOut(this, ...)
end

function CowTip:GameTooltip_OnHide(this, ...)
	leftGameTooltipStrings[1]:SetText(what) -- Restore the item for Talismonger to read
	doneOnTooltipMethod = false
	forgetNextOnTooltipMethod = false
	
	self:CallMethodOnAllModules(true, "OnTooltipHide")
	
	if self.hooks[this] and self.hooks[this].OnHide then
		self.hooks[this].OnHide(this, ...)
	end
end

local showWhenChoices = {
	never = L["Never"],
	notcombat = L["Out of combat"],
	always = L["Always"],
}

local function getShowTooltip(key)
	return CowTip.db.profile[key]
end

local function setShowTooltip(key, value)
	CowTip.db.profile[key] = value
end

CowTip.options = {
	type = 'group',
	name = "CowTip",
	desc = L["Tooltip of awesomeness. Moo. It'll graze your pasture."],
	icon = [[Interface\AddOns\CowTip\icon]],
	args = {
		showTooltips = {
			type = 'group',
			name = L["Show tooltips"],
			desc = L["Show tooltips in specific situations only."],
			args = {
				unitShow = {
					name = L["World units"],
					desc = L["Show the tooltip for world units if..."],
					type = 'choice',
					choices = showWhenChoices,
					get = getShowTooltip,
					set = setShowTooltip,
					passValue = 'unitShow',
				},
				objectShow = {
					name = L["World objects"],
					desc = L["Show the tooltip for world objects if..."],
					type = 'choice',
					choices = showWhenChoices,
					get = getShowTooltip,
					set = setShowTooltip,
					passValue = 'objectShow',
				},
				unitFrameShow = {
					name = L["Unit frames"],
					desc = L["Show the tooltip for unit frames if..."],
					type = 'choice',
					choices = showWhenChoices,
					get = getShowTooltip,
					set = setShowTooltip,
					passValue = 'unitFrameShow',
				},
				otherFrameShow = {
					name = L["Non-unit frames"],
					desc = L["Show the tooltip for non-unit frames if..."],
					type = 'choice',
					choices = showWhenChoices,
					get = getShowTooltip,
					set = setShowTooltip,
					passValue = 'otherFrameShow',
				},
				showByModifier = {
					name = L["Only show with modifier"],
					desc = L["Only show tooltip if the specified modifier is being held down."],
					type = 'choice',
					choices = {
						NONE = L["No modifier"],
						ALT = L["Alt"],
						CTRL = L["Control"],
						SHIFT = L["Shift"],
					},
					get = getShowTooltip,
					set = setShowTooltip,
					passValue = 'modifier',
				},
			}
		},
	}
}

function CowTip.modulePrototype:RegisterCowTipOption(data)
	local args = CowTip.options.args
	local name = self.name
	if args[name] then
		local i = 1
		while args[name .. i] do
			i = i + 1
		end
		name = name .. i
	end
	args[name] = data
	if not data.handler then
		data.handler = self
	end
	if data.args then
		data.args.active = {
			type = 'boolean',
			name = L["Enable"],
			desc = L["Enable this module"],
			get = "IsModuleActive",
			set = "ToggleModuleActive",
			handler = CowTip,
			passValue = self,
			order = 1,
		}
	end
end
