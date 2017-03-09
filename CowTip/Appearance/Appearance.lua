if select(6, GetAddOnInfo("CowTip_" .. (debugstack():match("[C%.][o%.][w%.]Tip\\Modules\\(.-)\\") or debugstack():match("[C%.][o%.][w%.]Tip\\(.-)\\") or ""))) ~= "MISSING" then return end

local VERSION = tonumber(("$Revision: 64217 $"):match("%d+"))

local CowTip = CowTip
local CowTip_Appearance = CowTip:NewModule("Appearance", "LibRockEvent-1.0", "LibRockTimer-1.0")
local self = CowTip_Appearance
if CowTip.revision < VERSION then
	CowTip.version = "r" .. VERSION
	CowTip.revision = VERSION
	CowTip.date = ("$Date: 2008-03-11 07:41:35 -0400 (Tue, 11 Mar 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")
end
CowTip_Appearance.desc = "Allow for a customized look of the tooltip"

local localization = (GetLocale() == "koKR") and {
	["Appearance"] = "외형",
	["Change how the tooltip Appearance in general."] = "일반적인 툴팁의 외형을 변경합니다.",
	["Background color"] = "배경 색상",
	["Set what color the tooltip's background is."] = "대상에 따른 툴팁의 배경 색상을 설정합니다.",
	["Guild and friends"] = "길드원과 친구",
	["Background color for your guildmates and friends."] = "길드원과 친구에 대한 배경 색상입니다.",
	["Currently watched faction"] = "현재 주시 진영",
	["Background color for the currently watched faction."] = "현재 주시 진영에 대한 배경 색상입니다.",
	["Hostile players"] = "적대적 플레이어",
	["Background color for hostile players."] = "적대적 플레이어에 대한 배경 색상입니다.",
	["Hostile non-player characters"] = "적대적 NPC",
	["Background color for hostile non-player characters."] = "적대적 NPC에 대한 배경 색상입니다.",
	["Neutral non-player characters"] = "중립적 NPC",
	["Background color for neutral non-player characters."] = "중립적 NPC에 대한 배경 색상입니다.",
	["Friendly players"] = "우호적 플레에어",
	["Background color for friendly players."] = "우호적 플레이어에 대한 배경 색상입니다.",
	["Friendly non-player characters"] = "우호적 NPC",
	["Background color for friendly non-player characters."] = "우호적 NPC에 대한 배경 색상입니다.",
	["Dead"] = "죽음",
	["Background color for dead units."] = "죽은 유닛에 대한 배경 색상입니다.",
	["Tapped"] = "선점",
	["Background color for when a unit is tapped by another."] = "타인에 의해 선점된 유닛의 배경 색상입니다.",
	["Other"] = "기타",
	["Background color for non-units."] = "유닛이 아닌 것의 배경 색상입니다.",
	["Border color"] = "테두리 색상",
	["Set what color the tooltip's border is."] = "툴팁의 테두리 색상을 설정합니다.",
	["Border style"] = "태두리 형태",
	["Change the border style."] = "배경의 형태를 변경합니다.",
	["Background style"] = "배경 형태",
	["Change the background style.\n\nNote: You may need to change the Background color to white to see some of the backgrounds properly."] = "배경의 형태를 변경합니다.\n\n주의: 하얀 배경이 보일때 적당히 색을 변화시킬 필요가 있을 수도 있습니다.",
	["Border padding"] = "테두리 간격",
	["The size of the border insets."] = "테두리에 추가할 간격을 설정합니다.",
	["Border size"] = "테두리 크기",
	["The size the border takes up."] = "테두리의 크기를 설정합니다.",
	["Size"] = "크기",
	["Set how large the tooltip is"] = "툴팁의 크기를 설정합니다.",
	["Font"] = "글꼴",
	["What font face to use."] = "사용할 글꼴을 선택합니다.",
} or (GetLocale() == "zhCN") and {
	["Appearance"] = "外观",
	["Change how the tooltip Appearance in general."] = "更改提示信息框的基本外观。",
	["Background color"] = "背景颜色",
	["Set what color the tooltip's background is."] = "设定提示信息框的背景颜色。",
	["Guild and friends"] = "公会和好友",
	["Background color for your guildmates and friends."] = "目标是你公会成员或者好友时的背景颜色。",
	["Currently watched faction"] = "当前正跟踪的阵营",
	["Background color for the currently watched faction."] = "目标如果属于你当前正跟踪的阵营时的背景颜色。",
	["Hostile players"] = "敌方玩家",
	["Background color for hostile players."] = "目标是敌方玩家时的背景颜色。",
	["Hostile non-player characters"] = "敌对NPC",
	["Background color for hostile non-player characters."] = "目标是敌对NPC时的背景颜色。",
	["Neutral non-player characters"] = "中立NPC",
	["Background color for neutral non-player characters."] = "目标是中立NPC时的背景颜色。",
	["Friendly players"] = "己方玩家",
	["Background color for friendly players."] = "目标是己方玩家时的背景颜色。",
	["Friendly non-player characters"] = "友善NPC",
	["Background color for friendly non-player characters."] = "目标是友善NPC时的背景颜色。",
	["Dead"] = "死亡",
	["Background color for dead units."] = "目标已经死亡时的背景颜色。",
	["Tapped"] = "已被攻击的NPC",
	["Background color for when a unit is tapped by another."] = "当目标已经被其它玩家攻击了时的背景颜色。",
	["Other"] = "其他",
	["Background color for non-units."] = "目标属于静态物件时的背景颜色。",
	["Border color"] = "边框颜色",
	["Set what color the tooltip's border is."] = "设定提示信息框的边框颜色。",
	["Border style"] = "边框样式",
	["Change the border style."] = "更改提示信息框的边框样式。",
	["Background style"] = "背景样式",
	["Change the background style.\n\nNote: You may need to change the Background color to white to see some of the backgrounds properly."] = "更改提示信息框的背景样式。\n\n注意：你可能要更改背景颜色为白色才可以使得部分背景看起来正常。",
	["Border padding"] = "边框间距",
	["The size of the border insets."] = "信息提示框的边框的间距大小。",
	["Border size"] = "边框宽度",
	["The size the border takes up."] = "信息提示框的边框宽度。",
	["Size"] = "大小",
	["Set how large the tooltip is"] = "信息提示框的大小。",
	["Font"] = "字体",
	["What font face to use."] = "信息提示框显示文字所用的字体。",
} or (GetLocale() == "zhTW") and {
	["Appearance"] = "外觀",
	["Change how the tooltip Appearance in general."] = "更改提示訊息基本外觀。",
	["Background color"] = "背景顏色",
	["Set what color the tooltip's background is."] = "設定提示訊息背景顏色。",
	["Guild and friends"] = "公會和好友",
	["Background color for your guildmates and friends."] = "公會和好友的背景顏色。",
	["Currently watched faction"] = "目前監察陣營",
	["Background color for the currently watched faction."] = "目前監察陣營的背景顏色。",
	["Hostile players"] = "敵對玩家",
	["Background color for hostile players."] = "敵對玩家的背景顏色。",
	["Hostile non-player characters"] = "敵對NPC",
	["Background color for hostile non-player characters."] = "敵對NPC的背景顏色。",
	["Neutral non-player characters"] = "中立NPC",
	["Background color for neutral non-player characters."] = "中立NPC的背景顏色。",
	["Friendly players"] = "友好玩家",
	["Background color for friendly players."] = "友好玩家的背景顏色。",
	["Friendly non-player characters"] = "友好NPC",
	["Background color for friendly non-player characters."] = "友好NPC的背景顏色。",
	["Dead"] = "死亡",
	["Background color for dead units."] = "死亡單位的背景顏色。",
	["Tapped"] = "支配",
	["Background color for when a unit is tapped by another."] = "被支配單位的背景顏色。",
	["Other"] = "其他",
	["Background color for non-units."] = "非單位的背景顏色。",
	["Border color"] = "邊框顏色",
	["Set what color the tooltip's border is."] = "設定提示訊息邊框顏色。",
	["Border style"] = "邊框樣式",
	["Change the border style."] = "更改邊框樣式。",
	["Background style"] = "背景樣式",
	["Change the background style.\n\nNote: You may need to change the Background color to white to see some of the backgrounds properly."] = "更改背景樣式。\n\n注意: 你可能要更改背景顏色為白色。",
	["Border padding"] = "邊框間距",
	["The size of the border insets."] = "邊框間距大小",
	["Border size"] = "邊框大小",
	["The size the border takes up."] = "邊框大小",
	["Size"] = "大小",
	["Set how large the tooltip is"] = "提示訊息大小",
	["Font"] = "字型",
	["What font face to use."] = "提示訊息字型",
} or (GetLocale() == "frFR") and {
	["Appearance"] = "Apparence",
	["Change how the tooltip Appearance in general."] = "Modifie l'apparence de l'infobulle en général.",
	["Background color"] = "Couleur de l'arrière-plan",
	["Set what color the tooltip's background is."] = "Détermine la couleur de l'arrière-plan de l'infobulle.",
	["Guild and friends"] = "Guilde et amis",
	["Background color for your guildmates and friends."] = "La couleur de l'arrière-plan pour vos compagnons de guilde et vos amis.",
	["Currently watched faction"] = "Faction actuellement suivie",
	["Background color for the currently watched faction."] = "La couleur de l'arrière-plan pour la faction actuellement suivie.",
	["Hostile players"] = "Joueurs hostiles",
	["Background color for hostile players."] = "La couleur de l'arrière-plan pour les joueurs hostiles.",
	["Hostile non-player characters"] = "PNJs hostiles",
	["Background color for hostile non-player characters."] = "La couleur de l'arrière-plan pour les personnages non-joueurs hostiles.",
	["Neutral non-player characters"] = "PNJs neutres",
	["Background color for neutral non-player characters."] = "La couleur de l'arrière-plan pour les personnages non-joueurs neutres.",
	["Friendly players"] = "Joueurs amicaux",
	["Background color for friendly players."] = "La couleur de l'arrière-plan pour les joueurs amicaux.",
	["Friendly non-player characters"] = "PNJs amicaux",
	["Background color for friendly non-player characters."] = "La couleur de l'arrière-plan pour les personnages non-joueurs amicaux.",
	["Dead"] = "Mort",
	["Background color for dead units."] = "La couleur de l'arrière-plan pour les unités mortes.",
	["Tapped"] = "Engagé",
	["Background color for when a unit is tapped by another."] = "La couleur de l'arrière-plan pour les unités engagées par d'autres.",
	["Other"] = "Autre",
	["Background color for non-units."] = "La couleur de l'arrière-plan pour les non-unités.",
	["Border color"] = "Couleur de la bordure",
	["Set what color the tooltip's border is."] = "Détermine la couleur de la bordure de l'infobulle.",
	["Border style"] = "Style de bordure",
	["Change the border style."] = "Modifie le style de la bordure de l'infobulle.",
	["Background style"] = "Style d'arrière-plan",
	["Change the background style.\n\nNote: You may need to change the Background color to white to see some of the backgrounds properly."] = "Modifie le style de l'arrière-plan.\n\nNote : vous devrez peut-être mettre la couleur de l'arrière-plan en blanc pour voir certains arrière-plans correctement.",
	["Border padding"] = "Décalage de la bordure",
	["The size of the border insets."] = "La taille du décalage intérieur de l'infobulle.",
	["Border size"] = "Taille de la bordure",
	["The size the border takes up."] = "La taille de la bordure de l'infobulle.",
	["Size"] = "Taille",
	["Set how large the tooltip is"] = "Détermine la largeur de l'infobulle.",
	["Font"] = "Police d'écriture",
	["What font face to use."] = "La police d'écriture à utiliser.",
} or {}

local L = CowTip:L("CowTip_Appearance", localization)

local LibSharedMedia = Rock("LibSharedMedia-3.0")

local leftGameTooltipStrings = CowTip.leftGameTooltipStrings
local rightGameTooltipStrings = CowTip.rightGameTooltipStrings

local _G = _G
local unpack = _G.unpack
local GameTooltip = _G.GameTooltip
local UnitIsFriend = _G.UnitIsFriend
local GetFriendInfo = _G.GetFriendInfo
local GetNumFriends = _G.GetNumFriends
local UnitName = _G.UnitName
local UnitIsUnit = _G.UnitIsUnit
local UnitIsPlayer = _G.UnitIsPlayer
local GetGuildInfo = _G.GetGuildInfo
local UnitIsTappedByPlayer = _G.UnitIsTappedByPlayer
local UnitIsTapped = _G.UnitIsTapped
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local UnitReaction = _G.UnitReaction
local UnitExists = _G.UnitExists

function CowTip_Appearance:OnInitialize()
	self.db = CowTip:GetDatabaseNamespace("Appearance")
	CowTip:SetDatabaseNamespaceDefaults("Appearance", "profile", {
		scale = 1,
		font = "Friz Quadrata TT",
		border = "Blizzard Tooltip",
		background = "Solid",
		bgColor = {
			guild = {0, 0.15, 0, 1},
			faction = {0.25, 0.25, 0, 1},
			hostilePC = {0.25, 0, 0, 1},
			hostileNPC = {0.15, 0, 0, 1},
			neutralNPC = {0.15, 0.15, 0, 1},
			friendlyPC = {0, 0, 0.25, 1},
			friendlyNPC = {0, 0, 0.15, 1},
			other = {0, 0, 0, 1},
			dead = {0.15, 0.15, 0.15, 1},
			tapped = {0.25, 0.25, 0.25, 1},
		},
		borderColor = { 1, 1, 1, 1 },
		padding = 4,
		edgeSize = 16,
	})
end

function CowTip_Appearance:OnEnable()
	self:SetScale(nil)
	self:SetFont(nil)
	self:SetTexture(nil, nil, nil, nil)
	
	self:AddTimer(1, "SetTexture")
	
	self:AddEventListener("PLAYER_ENTERING_WORLD")
	
	self:AddEventListener("LibRockEvent-1.0", "FullyInitialized")
	
	self:AddEventListener("ADDON_LOADED")
	self:ADDON_LOADED()
end

function CowTip_Appearance:OnDisable()
	self:SetScale(nil)
	self:SetFont(nil)
	self:SetTexture(nil, nil, nil, nil)
	
	self:AddEventListener("ADDON_LOADED")
end

function CowTip_Appearance:PLAYER_ENTERING_WORLD()
	self:SetScale(nil)
end

local hookOnShow
do
	local hooked = {}
	function hookOnShow(tooltip)
		if hooked[tooltip] then
			return
		end
		hooked[tooltip] = true
		local OnShow = tooltip:GetScript("OnShow")
		tooltip:SetScript("OnShow", function(this, ...)
			if OnShow then
				OnShow(this, ...)
			end
			self:SetScale(nil, this)
			self:SetFont(nil, this)
			self:SetTexture(nil, nil, nil, nil, this)
		end)
		local Show = tooltip.Show
		function tooltip.Show(this, ...)
			if Show then
				Show(this, ...)
			end
			self:SetScale(nil, this)
			self:SetFont(nil, this)
			self:SetTexture(nil, nil, nil, nil, this)
		end
		if tooltip:IsShown() then
			tooltip:GetScript("OnShow")(tooltip)
		end
	end
end

local EnhancedTooltip = nil
function CowTip_Appearance:ADDON_LOADED()
	if _G.EnhancedTooltip ~= EnhancedTooltip then
		EnhancedTooltip = _G.EnhancedTooltip
		hookOnShow(EnhancedTooltip)
	end
end

local tooltips = {}
function CowTip_Appearance:FullyInitialized()
	local function run()
		local f
		local EnumerateFrames = _G.EnumerateFrames
		while true do
			f = EnumerateFrames(f)
			if not f then
				break
			end
			if f:GetObjectType() == "GameTooltip" and f ~= GameTooltip then
				hookOnShow(f)
			end
		end
	end
	run()
	local OnTooltipSetItem = ItemRefTooltip:GetScript("OnTooltipSetItem")
	ItemRefTooltip:SetScript("OnTooltipSetItem", function(this, ...)
		if OnTooltipSetItem then
			OnTooltipSetItem(this, ...)
		end
		self:AddTimer(0, run)
	end)
end

function CowTip_Appearance:OnTooltipShow()
	self:SetBackgroundColor(nil)
	self:SetBorderColor(nil)
end

local currentSameFaction = false
function CowTip_Appearance:PreTooltipSetUnit()
	local myWatchedFaction = GetWatchedFactionInfo()
	currentSameFaction = false
	if myWatchedFaction then
		for i = 1, 10 do
			local left = leftGameTooltipStrings[i]
			if left:GetText() == myWatchedFaction then
				currentSameFaction = true
				break
			end
		end
	end
end

function CowTip_Appearance:SetScale(value, tooltip)
	if not tooltip then
		tooltip = GameTooltip
	end
	if value then
		self.db.profile.scale = value
	else
		value = self.db.profile.scale
	end
	if not CowTip:IsModuleActive(self) then
		value = 1
	end
	
	tooltip:SetScale(value)
end

local tmp = {}
local function fillTmp(...)
	for i = 1, select('#', ...) do
		tmp[i] = select(i, ...)
	end
end
function CowTip_Appearance:SetFont(value, tooltip)
	if value then
		self.db.profile.font = value
	else
		value = self.db.profile.font
	end
	if not CowTip:IsModuleActive(self) then
		value = "Friz Quadrata TT"
	end
	
	local font = LibSharedMedia:Fetch('font', value)
	
	if not tooltip then -- GameTooltip
		local text = leftGameTooltipStrings[1]
		if text:GetFont() == font then
			return
		end
		for i = 1, 50 do
			local left = leftGameTooltipStrings[i]
			local right = rightGameTooltipStrings[i]
			local _, size, style = left:GetFont()
			left:SetFont(font, size, style)
			local _, size, style = right:GetFont()
			right:SetFont(font, size, style)
		end
	else
		fillTmp(tooltip:GetRegions())
		for i,v in ipairs(tmp) do
			tmp[i] = nil
			if v:GetObjectType() == "FontString" then
				local _, size, style = v:GetFont()
				v:SetFont(font, size, style)
			end
		end
	end
end

local function isClose(alpha, bravo)
	return math.abs(alpha - bravo) < 1/100
end

local tmp = {}
local tmp2 = {}
function CowTip_Appearance:SetTexture(border, background, padding, edgeSize, tooltip)
	if border then
		self.db.profile.border = border
	else
		border = self.db.profile.border
	end
	if background then
		self.db.profile.background = background
	else
		background = self.db.profile.background
	end
	if padding then
		self.db.profile.padding = padding
	else
		padding = self.db.profile.padding
	end
	if edgeSize then
		self.db.profile.edgeSize = edgeSize
	else
		edgeSize = self.db.profile.edgeSize
	end
	if not tooltip then
		tooltip = GameTooltip
	end
	if not CowTip:IsModuleActive(self) then
		border = "Blizzard Tooltip"
		background = "Blizzard Tooltip"
		padding = 4
		edgeSize = 16
	end
	
	local bg, side
	for i = select('#', tooltip:GetRegions()), 1, -1 do
		local region = select(i, tooltip:GetRegions())
		if not region:GetName() and region:GetObjectType() == "Texture" then
			local points, drawLayer = region:GetNumPoints(), region:GetDrawLayer()
			if points == 4 and drawLayer == "BACKGROUND" then
				bg = region
			elseif points <= 2 and drawLayer == "BORDER" then
				side = region
			end
		end
		if bg and side then
			break
		end
	end
	local bgFile = LibSharedMedia:Fetch('background', background)
	local edgeFile = LibSharedMedia:Fetch('border', border)
	
	local changed = false
	if not bg or not side then
		changed = true
	elseif bg:GetTexture() ~= bgFile or side:GetTexture() ~= edgeFile then
		changed = true
	elseif not isClose(side:GetWidth(), edgeSize) and not isClose(side:GetHeight(), edgeSize) then
		changed = true
	else
		local point, parent, relpoint, x, y = bg:GetPoint(1)
		x, y = math.abs(x), math.abs(y)
		if not isClose(x, padding) and not isClose(y, padding) then
			changed = true
		end
	end
	
	if changed then
		tmp.bgFile = LibSharedMedia:Fetch('background', background)
		tmp.edgeFile = LibSharedMedia:Fetch('border', border)
		tmp.tile = false
		tmp.edgeSize = edgeSize
		tmp.insets = tmp2
		tmp2.left = padding
		tmp2.right = padding
		tmp2.top = padding
		tmp2.bottom = padding
		tooltip:SetBackdrop(tmp)
	end
	
	self:SetBackgroundColor(nil, nil, nil, nil, nil, tooltip)
	self:SetBorderColor(nil, nil, nil, nil, tooltip)
end

function CowTip_Appearance:SetBorder(value)
	self:SetTexture(value, nil, nil, nil)
end

function CowTip_Appearance:SetBackground(value)
	self:SetTexture(nil, value, nil, nil)
end

function CowTip_Appearance:SetPadding(value)
	self:SetTexture(nil, nil, value, nil)
end

function CowTip_Appearance:SetEdgeSize(value)
	self:SetTexture(nil, nil, nil, value)
end

function CowTip_Appearance:SetBackgroundColor(given_kind, r, g, b, a, tooltip)
	if not tooltip then
		tooltip = GameTooltip
	end
	local kind = given_kind
	if not kind then
		kind = 'other'
		local unit
		if type(tooltip.GetUnit) == "function" then
			local _
			_, unit = tooltip:GetUnit()
		end
		if unit and UnitExists(unit) then
			if UnitIsDeadOrGhost(unit) then
				kind = 'dead'
			elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
				kind = 'tapped'
			elseif tooltip == GameTooltip and currentSameFaction then
				kind = 'faction'
			elseif UnitIsPlayer(unit) then
				if UnitIsFriend("player", unit) then
					local playerGuild = GetGuildInfo("player")
					if playerGuild and playerGuild == GetGuildInfo(unit) or UnitIsUnit("player", unit) then
						kind = 'guild'
					else
						local friend = false
						local name = UnitName(unit)
						for i = 1, GetNumFriends() do
							if GetFriendInfo(i) == name then
								friend = true
								break
							end
						end
						if friend then
							kind = 'guild'
						else
							kind = 'friendlyPC'
						end
					end
				else
					kind = 'hostilePC'
				end
			else
				if UnitIsFriend("player", unit) then
					kind = 'friendlyNPC'
				else
					local reaction = UnitReaction(unit, "player")
					if not reaction or reaction <= 2 then
						kind = 'hostileNPC'
					else
						kind = 'neutralNPC'
					end
				end
			end
		end
	end
	local bgColor = self.db.profile.bgColor[kind]
	if r then
		bgColor[1] = r
		bgColor[2] = g
		bgColor[3] = b
		bgColor[4] = a
	else
		r, g, b, a = unpack(bgColor)
	end
	if given_kind then
		self:SetBackgroundColor(nil, nil, nil, nil, nil, tooltip)
		return
	end
	if not CowTip:IsModuleActive(self) then
		r, g, b, a = 0, 0, 0, 1
	end
	tooltip:SetBackdropColor(r, g, b, a)
end

function CowTip_Appearance:SetBorderColor(r, g, b, a, tooltip)
	if not tooltip then
		tooltip = GameTooltip
	end
	local borderColor = self.db.profile.borderColor
	if r then
		borderColor[1] = r
		borderColor[2] = g
		borderColor[3] = b
		borderColor[4] = a
	else
		r, g, b, a = unpack(borderColor)
	end
	if not CowTip:IsModuleActive(self) then
		r, g, b, a = 1, 1, 1, 1
	end
	tooltip:SetBackdropBorderColor(r, g, b, a)
end

CowTip_Appearance:RegisterCowTipOption({
	name = L["Appearance"],
	desc = L["Change how the tooltip Appearance in general."],
	type = 'group',
	args = {
		bgColor = {
			name = L["Background color"],
			desc = L["Set what color the tooltip's background is."],
			type = 'group',
			child_get = function(value)
				return unpack(CowTip_Appearance.db.profile.bgColor[value])
			end,
			child_set = "SetBackgroundColor",
			child_hasAlpha = true,
			child_type = 'color',
			args = {
				guild = {
					name = L["Guild and friends"],
					desc = L["Background color for your guildmates and friends."],
					passValue = "guild",
				},
				faction = {
					name = L["Currently watched faction"],
					desc = L["Background color for the currently watched faction."],
					passValue = "faction",
				},
				hostilePC = {
					name = L["Hostile players"],
					desc = L["Background color for hostile players."],
					passValue = "hostilePC",
				},
				hostileNPC = {
					name = L["Hostile non-player characters"],
					desc = L["Background color for hostile non-player characters."],
					passValue = "hostileNPC",
				},
				neutralNPC = {
					name = L["Neutral non-player characters"],
					desc = L["Background color for neutral non-player characters."],
					passValue = "neutralNPC",
				},
				friendlyPC = {
					name = L["Friendly players"],
					desc = L["Background color for friendly players."],
					passValue = "friendlyPC",
				},
				friendlyNPC = {
					name = L["Friendly non-player characters"],
					desc = L["Background color for friendly non-player characters."],
					passValue = "friendlyNPC",
				},
				dead = {
					name = L["Dead"],
					desc = L["Background color for dead units."],
					passValue = "dead",
				},
				tapped = {
					name = L["Tapped"],
					desc = L["Background color for when a unit is tapped by another."],
					passValue = "tapped",
				},
				other = {
					name = L["Other"],
					desc = L["Background color for non-units."],
					passValue = "other",
				},
			}
		},
		borderColor = {
			name = L["Border color"],
			desc = L["Set what color the tooltip's border is."],
			type = 'color',
			hasAlpha = true,
			get = function()
				return unpack(CowTip_Appearance.db.profile.borderColor)
			end,
			set = "SetBorderColor"
		},
		border = {
			name = L["Border style"],
			desc = L["Change the border style."],
			type = 'choice',
			choices = LibSharedMedia:List('border'),
			get = function()
				return CowTip_Appearance.db.profile.border
			end,
			set = "SetBorder",
		},
		background = {
			name = L["Background style"],
			desc = L["Change the background style.\n\nNote: You may need to change the Background color to white to see some of the backgrounds properly."],
			type = 'choice',
			choices = LibSharedMedia:List('background'),
			get = function()
				return CowTip_Appearance.db.profile.background
			end,
			set = "SetBackground",
		},
		padding = {
			name = L["Border padding"],
			desc = L["The size of the border insets."],
			type = 'number',
			min = 0,
			max = 20,
			step = 1,
			get = function()
				return CowTip_Appearance.db.profile.padding
			end,
			set = "SetPadding",
		},
		edgeSize = {
			name = L["Border size"],
			desc = L["The size the border takes up."],
			type = 'number',
			min = 0,
			max = 20,
			step = 1,
			get = function()
				return CowTip_Appearance.db.profile.edgeSize
			end,
			set = "SetEdgeSize",
		},
		{
			name = L["Size"],
			desc = L["Set how large the tooltip is"],
			type = 'number',
			min = 0.25,
			max = 4,
			step = 0.01,
			bigStep = 0.05,
			get = function()
				return CowTip_Appearance.db.profile.scale
			end,
			set = "SetScale"
		},
		{
			name = L["Font"],
			desc = L["What font face to use."],
			type = 'choice',
			choices = LibSharedMedia:List('font'),
			choiceFonts = LibSharedMedia:HashTable('font'),
			get = function()
				return CowTip_Appearance.db.profile.font
			end,
			set = "SetFont",
		},
	}
})
