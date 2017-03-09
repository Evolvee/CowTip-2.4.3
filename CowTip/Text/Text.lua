if select(6, GetAddOnInfo("CowTip_" .. (debugstack():match("[C%.][o%.][w%.]Tip\\Modules\\(.-)\\") or debugstack():match("[C%.][o%.][w%.]Tip\\(.-)\\") or ""))) ~= "MISSING" then return end

local VERSION = tonumber(("$Revision: 67123 $"):match("%d+"))

local CowTip = CowTip
local CowTip_Text = CowTip:NewModule("Text", "LibRockTimer-1.0", "LibRockEvent-1.0", "LibRockHook-1.0")
local self = CowTip_Text
if CowTip.revision < VERSION then
	CowTip.version = "r" .. VERSION
	CowTip.revision = VERSION
	CowTip.date = ("$Date: 2008-03-30 18:04:07 +0000 (Sun, 30 Mar 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")
end
CowTip_Text.desc = "Allow for customized text on the tooltip"

local localization = (GetLocale() == "koKR") and {
	["Target:"] = "대상:", -- [2]
	["Guild:"] = "길드:", -- [3]
	["Guild rank:"] = "길드 계급:", -- [4]
	["Level:"] = "레벨:", -- [5]
	["Race:"] = "종족:", -- [6]
	["Class:"] = "직업:", -- [7]
	["Faction:"] = "진영:", -- [8]
	["Status:"] = "상태:", -- [9]
	["Health:"] = "생명력:", -- [10]
	["Experience:"] = "경험치:", -- [12]
	["Threat:"] = "위협:", -- [13]
	["Happiness:"] = "만족도:", -- [14]
	["Zone:"] = "지역:", -- [15]
	["You"] = "당신",
	["None"] = "없음",
	["Line texts"] = "라인 글자",
	["Here you can describe the text on the assorted lines of the tooltip."] = "여기서 당신은 툴팁을 다양하게 나타낼수 있습니다.",
	["Edit"] = "편집",
	["Edit the line texts."] = "라인에 표시할 글자들을 편집합니다.",
	["Edit lines."] ="라인 편집",
	["Edit the line texts."] ="라인 글자 편집",
	["DogTag help"] ="DogTag 도움말",
	["Open"] ="열기",
	["Click to pop up helpful DogTag documentation."] ="DogTag 도움이 되는 문서를 팝업할려면 클릭하세요.",
} or (GetLocale() == "zhCN") and {
	["Target:"] = "目标:",
	["Guild:"] = "公会:",
	["Guild rank:"] = "公会级别:",
	["Level:"] = "等级:",
	["Race:"] = "种族:",
	["Class:"] = "职业:",
	["Faction:"] = "阵营:",
	["Status:"] = "状态:",
	["Health:"] = "生命值:",
	["Experience:"] = "经验值:",
	["Threat:"] = "仇恨值:",
	["Happiness:"] = "快乐值:",
	["Zone:"] = "所处地区:",
	["You"] = "你",
	["None"] = "无",
	["Line texts"] = "提示信息文字",
	["Here you can describe the text on the assorted lines of the tooltip."] = "在这个选项里你可以自定义提示信息上都显示一些什么内容。",
	["Edit lines."] = "编辑提示信息文字",
	["Edit the line texts."] = "编辑提示信息框中所显示的文字。",
	["Edit"] = "编辑",
	["DogTag help"] = "DogTag帮助文档",
	["Open"] = "打开",
} or (GetLocale() == "zhTW") and {
	["Target:"] = "目標:",
	["Guild:"] = "公會:",
	["Guild rank:"] = "公會會階:",
	["Level:"] = "等級:",
	["Race:"] = "種族:",
	["Class:"] = "職業:",
	["Faction:"] = "陣營:",
	["Status:"] = "狀態:",
	["Health:"] = "生命力:",
	["Experience:"] = "經驗值:",
	["Threat:"] = "威脅值:",
	["Happiness:"] = "快樂值:",
	["Zone:"] = "地區:",
	["You"] = "你",
	["None"] = "無",
	["Line texts"] = "提示訊息文字",
	["Here you can describe the text on the assorted lines of the tooltip."] = "在這裡使用 LibDogTag-2.0 標籤設定提示訊息文字。瀏覽 http://www.wowace.com/wiki/LibDogTag-2.0 參考標籤用法。",
	["Edit lines."] = "編輯提示訊息文字",
	["Edit the line texts."] = "編輯提示訊息文字。",
	["Edit"] = "編輯",
} or (GetLocale() == "frFR") and {
	["Target:"] = "Cible :",
	["Guild:"] = "Guilde :",
	["Guild rank:"] = "Rang de guilde :",
	["Level:"] = "Niveau :",
	["Race:"] = "Race :",
	["Class:"] = "Classe :",
	["Faction:"] = "Faction :",
	["Status:"] = "Statut :",
	["Health:"] = "Vie :",
	["Experience:"] = "Expérience :",
	["Threat:"] = "Menace :",
	["Happiness:"] = "Humeur :",
	["Zone:"] = "Zone :",
	["You"] = "Vous",
	["None"] = "Aucune",
	["Line texts"] = "Texte des lignes",
	["Here you can describe the text on the assorted lines of the tooltip."] = "Vous pouvez ici configurer les différentes lignes de l'infobulle.",
	["Edit lines."] = "Éditer les lignes",
	["Edit the line texts."] = "Édite le texte des lignes.",
	["Edit"] = "Éditer",
	["DogTag help"] ="Aide DogTag",
	["Open"] ="Ouvrir",
	["Click to pop up helpful DogTag documentation."] ="Cliquez pour ouvrir la documentation de DogTag.",
	["Help"] = "Aide",
} or {}

local L = CowTip:L("CowTip_Text", localization)

local DogTag = Rock("LibDogTag-3.0")
Rock("LibDogTag-Unit-3.0")

local leftGameTooltipStrings = CowTip.leftGameTooltipStrings
local rightGameTooltipStrings = CowTip.rightGameTooltipStrings

local _G = _G
local IsShiftKeyDown = _G.IsShiftKeyDown
local ChatFontNormal = _G.ChatFontNormal
local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local GameTooltip = _G.GameTooltip
local ipairs = _G.ipairs
local GetNumFactions = _G.GetNumFactions
local GetFactionInfo = _G.GetFactionInfo
local UnitPlayerControlled = _G.UnitPlayerControlled
local UnitIsPlayer = _G.UnitIsPlayer
local UnitFactionGroup = _G.UnitFactionGroup
local UnitIsConnected = _G.UnitIsConnected
local UnitIsVisible = _G.UnitIsVisible
local UnitIsPVP = _G.UnitIsPVP
local UnitExists = _G.UnitExists

local kwargs = { unit = 'mouseover' }

function CowTip_Text:OnInitialize()
	self.db = CowTip:GetDatabaseNamespace("Text")
	CowTip:SetDatabaseNamespaceDefaults("Text", "profile", {
		lefts = {
			['*'] = "",
			"[if [IsPlayer or [IsEnemy and not IsPet]] then ClassColor][NameRealm]", -- [1]
			L["Target:"], -- [2]
			L["Guild:"], -- [3]
			L["Guild rank:"], -- [4]
			L["Level:"], -- [5]
			L["Race:"], -- [6]
			L["Class:"], -- [7]
			L["Faction:"], -- [8]
			L["Status:"], -- [9]
			L["Health:"], -- [10]
			"[if HasMP then TypePower ':']", -- [11]
			L["Experience:"], -- [12]
			L["Threat:"], -- [13]
			L["Happiness:"], -- [14]
			L["Zone:"], -- [15]
			(_G.TALENTS or "Talents") .. ":", -- [16]
		},
		rights = {
			['*'] = "",
			"", -- [1]
			"[if Target:IsPlayer or (Target:IsEnemy and not Target:IsPet) then ClassColor(unit=Target)][if IsUnit('player', Target) then '<<" .. L["You"] .. ">>' else Target:NameRealm or '" .. L["None"] .. "']", -- [2]
			"[if Guild and Guild = 'player':Guild then Green][Guild:Angle]", -- [3]
			"[GuildRank]", -- [4]
			"[Classification] [Level]", -- [5]
			"[if IsPlayer then Race else Creature]", -- [6]
			"[if IsPlayer or [IsEnemy and not IsPet] then Class:ClassColor]", -- [7]
			"[Faction]", -- [8]
			"[Status]", -- [9]
			"[FractionalHP:Short] [PercentHP:Percent:Paren]", -- [10]
			"[if HasMP then FractionalMP:Short ' ' PercentMP:Percent:Paren]", -- [11]
			"[if XP ~= 0 then FractionalXP:Short ' ' PercentXP:Percent:Paren]", -- [12]
			"[if HasThreat then FractionalThreat:Short ' ' PercentThreat:Percent:Paren]", -- [13]
			"[if IsUnit('pet') then HappyText]", -- [14]
			"[Zone]", -- [15]
			"[if TalentSpec then TalentTree ' ' TalentSpec:Paren]", -- [16]
		}
	})
end

function CowTip_Text:OnEnable()
	self:AddEventListener("UPDATE_FACTION")
	
	self:AddHook(GameTooltip, "GetUnit", "GameTooltip_GetUnit")
	self:UPDATE_FACTION()
end

local factionList = {}

function CowTip_Text:UPDATE_FACTION()
	for i = 1, GetNumFactions() do
		local name = GetFactionInfo(i)
		factionList[name] = true
	end
end

--[[
How normal tooltips look:
{Name}
{[Guild] : ~~~}
Level {Num} {[(Classification)]}
{NPC? [Faction] : ~~~}
{Offline? Offline : !IsVisible? [Zone] : IsPVP? [PvP] : ~~~}
]]

local lastNumRegistered = 0
local linesToAdd = {}
local linesToAddR = {}
local linesToAddG = {}
local linesToAddB = {}
local linesToAddRight = {}
local linesToAddRightR = {}
local linesToAddRightG = {}
local linesToAddRightB = {}

local lastUnitName, lastUnit

function CowTip_Text:RefixLines(lastLine)
	for i = 1, lastNumRegistered do
		DogTag:RemoveFontString(leftGameTooltipStrings[i])
		DogTag:RemoveFontString(rightGameTooltipStrings[i])
	end
	lastNumRegistered = 0
	
	for i = lastLine, GameTooltip:NumLines() do
		local left = leftGameTooltipStrings[i]
		local j = i - lastLine + 1
		linesToAdd[j] = left:GetText()
		local r, g, b = left:GetTextColor()
		linesToAddR[j] = r
		linesToAddG[j] = g
		linesToAddB[j] = b
		local right = rightGameTooltipStrings[i]
		if right:IsShown() then
			linesToAddRight[j] = right:GetText()
			local r, g, b = right:GetTextColor()
			linesToAddRightR[j] = r
			linesToAddRightG[j] = g
			linesToAddRightB[j] = b
		end
	end
	
	GameTooltip:ClearLines()
	local db = self.db.profile
	local lefts, rights = db.lefts, db.rights
	local num = 0
	for i = 1, 30 do
		local left, right = lefts[i], rights[i]
		local left_ev, right_ev
		if left and left:trim() == "" then
			left = nil
		else
			left_ev = tostring(DogTag:Evaluate(left, "Unit", kwargs) or '')
			if left_ev:trim() == "" then
				left_ev = nil
			end
		end
		if right and right:trim() == "" then
			right = nil
		else
			right_ev = tostring(DogTag:Evaluate(right, "Unit", kwargs) or '')
			if right_ev:trim() == "" then
				right_ev = nil
			end
		end
		if right then
			if right_ev or (left and left_ev and left:find("%[")) then
				num = num + 1
				GameTooltip:AddDoubleLine(left_ev or ' ', right_ev, 1, 1, 1, 1, 1, 1)
				local leftFS = leftGameTooltipStrings[num]
				local rightFS = rightGameTooltipStrings[num]
				DogTag:AddFontString(leftFS, GameTooltip, left or ' ', "Unit", kwargs)
				DogTag:AddFontString(rightFS, GameTooltip, right, "Unit", kwargs)
			end
		elseif left then
			if left_ev then
				num = num + 1
				GameTooltip:AddLine(left_ev, 1, 1, 1, true)
				local leftFS = leftGameTooltipStrings[num]
				leftFS:SetTextColor(1, 1, 1)
				DogTag:AddFontString(leftFS, GameTooltip, left, "Unit", kwargs)
			end
		end
	end
	if lastNumRegistered < num then
		lastNumRegistered = num
	end

	for i,left in ipairs(linesToAdd) do
		local right = linesToAddRight[i]
		if right then
			GameTooltip:AddDoubleLine(left, right, linesToAddR[i], linesToAddG[i], linesToAddB[i], linesToAddRightR[i], linesToAddRightG[i], linesToAddRightB[i])
		else
			GameTooltip:AddLine(left, linesToAddR[i], linesToAddG[i], linesToAddB[i], true)
		end
		linesToAdd[i] = nil
		linesToAddR[i] = nil
		linesToAddG[i] = nil
		linesToAddB[i] = nil
		linesToAddRight[i] = nil
		linesToAddRightR[i] = nil
		linesToAddRightG[i] = nil
		linesToAddRightB[i] = nil
	end
end

function CowTip_Text:GameTooltip_GetUnit(this)
	if not lastUnitName then
		return self.hooks[GameTooltip].GetUnit(GameTooltip)
	end
	return lastUnitName, lastUnit
end

local LEVEL_start = "^" .. _G.LEVEL
local PVP = _G.PVP

function CowTip_Text:OnTooltipSetUnit()
	lastUnitName, lastUnit = self.hooks[GameTooltip].GetUnit(GameTooltip)
	
	local num = 2
	local text_2 = leftGameTooltipStrings[2]:GetText()
	if not text_2 then
		num = num - 1
	elseif not text_2:find(LEVEL_start) then
		-- has a guild
		num = num + 1
	end
	if not UnitPlayerControlled("mouseover") and not UnitIsPlayer("mouseover") then
		-- npc, faction line
		local factionText = leftGameTooltipStrings[num+1]:GetText()
		if factionText == PVP then
			factionText = nil
		end
		if factionText and (factionList[factionText] or UnitFactionGroup("mouseover")) then
			num = num + 1
		end
	end
	if not UnitIsConnected("mouseover") or not UnitIsVisible("mouseover") or UnitIsPVP("mouseover") then
		-- offline, zone, or pvp
		num = num + 1
	end
	
	self:RefixLines(num+1)
	
	self:AddRepeatingTimer("CowTip_Text_UpdateTexts", 1, "UpdateTexts")
end

function CowTip_Text:UpdateTexts()
	if not lastUnit or not UnitExists("mouseover") then
		return
	end
	self:RefixLines(lastNumRegistered+1)
	
	GameTooltip:Show()
end

function CowTip_Text:OnTooltipHide()
	for i = 1, lastNumRegistered do
		DogTag:RemoveFontString(leftGameTooltipStrings[i])
		DogTag:RemoveFontString(rightGameTooltipStrings[i])
	end
	lastNumRegistered = 0
	lastUnitName, lastUnit = nil, nil
	
	self:RemoveTimer("CowTip_Text_UpdateTexts")
end

local function CleanCode(text)
	text = DogTag:CleanCode(text)
	text = text:gsub("%s%s*", " ")
	return text
end

local lineConfigBox
function CowTip_Text:CreateLineConfigBox()
	if not lineConfigBox then
		lineConfigBox = CreateFrame("Frame", "CowTipLineConfigFrame", UIParent, "DialogBoxFrame")
		lineConfigBox:SetFrameStrata("FULLSCREEN_DIALOG")
		lineConfigBox:SetFrameLevel(40)
		CowTipLineConfigFrameButton:SetFrameStrata("FULLSCREEN_DIALOG")
		CowTipLineConfigFrameButton:SetFrameLevel(41)

		lineConfigBox:SetToplevel(false)
		lineConfigBox:SetWidth(750)
		lineConfigBox:SetHeight(630)
		lineConfigBox:SetPoint("CENTER")
		lineConfigBox:SetBackdrop({
			bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]], 
		    edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], 
		    tile = true, tileSize = 16, edgeSize = 16, 
		    insets = { left = 5, right = 5, top = 5, bottom = 5 }
		})
		lineConfigBox:SetBackdropColor(0,0,0,1)
		
		lineConfigBox:EnableMouse(true)
		lineConfigBox:SetMovable(true)
		lineConfigBox:RegisterForDrag("LeftButton")
		lineConfigBox:SetClampedToScreen(true)
		lineConfigBox:SetScript("OnDragStart", function(this)
			this:StartMoving()
		end)
		lineConfigBox:SetScript("OnDragStop", function(this)
			this:StopMovingOrSizing()
		end)
		
		local helpButton = CreateFrame("Button", lineConfigBox:GetName() .. "_HelpButton", lineConfigBox, "UIPanelButtonTemplate2")
		helpButton:SetText(L["Help"])
		helpButton:SetScript("OnClick", function(this)
			DogTag:OpenHelp()
		end)
		helpButton:SetPoint("BOTTOMRIGHT", -12, 12)
		
		local GetCaretPosition, SetCaretPosition
		
		local hasFocus
		local lastText
		local function OnEditFocusGained(this)
			hasFocus = this
			lastText = this:GetText()
		end
		
		local function OnEditFocusLost(this)
			if hasFocus == this then
				hasFocus = nil
				lastText = nil
			end
			local num, side = this.num, this.side
			local text = this:GetText() or ''
			
			text = CleanCode(text)
			this:SetText(DogTag:ColorizeCode(text))
			
			self.db.profile[side == 'left' and 'lefts' or 'rights'][num] = text
		end
		
		local pipe_byte = ("|"):byte()
		local c_byte = ("c"):byte()
		local r_byte = ("r"):byte()
		
		local function OnTextChanged(this)
			if hasFocus == this then
				local text = this:GetText()
			 	if lastText ~= text then
					lastText = text
					local position = GetCaretPosition(this)
					local skip = 0
					for i = 1, position do
						if text:byte(i) == pipe_byte then
							if text:byte(i+1) == c_byte then
								skip = skip + 10
							elseif text:byte(i+1) == r_byte then
								skip = skip + 2
							end
						end
					end
					position = position - skip
					lastText = DogTag:ColorizeCode(lastText)
					this:SetText(lastText)
					local betterPosition = 0
					for i = 1, position do
						betterPosition = betterPosition + 1
						while lastText:byte(betterPosition) == ("|"):byte() do
							if lastText:byte(betterPosition+1) == ("c"):byte() then
								betterPosition = betterPosition + 10
							elseif lastText:byte(betterPosition+1) == ("r"):byte() then
								betterPosition = betterPosition + 2
							else
								break
							end
						end
					end
					
					SetCaretPosition(this, betterPosition)
				end
			end
		end
		
		function GetCaretPosition(this)
			local text = this:GetText()
			if #text == 0 then
				return 0
			end
			this:SetScript("OnTextChanged", nil)
			this:Insert("\001")
			local position = this:GetText():find("\001", 1, 1)
			this:SetText(text)
			
			if position then
				this:SetText(text:sub(1, position - 1) .. "X" .. text:sub(position))
				this:HighlightText(position - 1, position)
				this:Insert("\000")
			end	
			this:SetScript("OnTextChanged", OnTextChanged)
			
			return (position or 0) - 1
		end
		
		function SetCaretPosition(this, position)
			local text = this:GetText()
			if #text == 0 then
				return
			end
			this:SetScript("OnTextChanged", nil)
			this:SetText(text:sub(1, position) .. "X" .. text:sub(position + 1))
			this:HighlightText(position, position + 1)
			this:Insert("\000")
			this:SetScript("OnTextChanged", OnTextChanged)
		end
		
		local function OnEnterPressed(this)
			this:ClearFocus()
		end
		
		local function OnTabPressed(this)
			local num, side = this.num, this.side
			
			this:ClearFocus()
			
			if not IsShiftKeyDown() then
				if side == "left" then
					this:GetParent()["right" .. num]:SetFocus()
				elseif num < 30 then
					this:GetParent()["left" .. (num+1)]:SetFocus()
				end
			else
				if side == "right" then
					this:GetParent()["left" .. num]:SetFocus()
				elseif num > 1 then
					this:GetParent()["right" .. (num-1)]:SetFocus()
				end
			end
		end
		
		for i = 1, 30 do
			for j = 1, 2 do
				local leftSide = j == 1
				local editBox = CreateFrame("EditBox", "CowTipLineConfigFrameEditBox" .. (leftSide and "Left" or "Right") .. i, lineConfigBox)
				local last
				if leftSide then
					lineConfigBox["left" .. i] = editBox
					last = lineConfigBox["left" .. i-1]
				else
					lineConfigBox["right" .. i] = editBox
					last = lineConfigBox["right" .. i-1]
				end
				editBox:SetFontObject(ChatFontNormal)
				editBox:SetHeight(13)
				if last then
					editBox:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -5)
					editBox:SetPoint("TOPRIGHT", last, "BOTTOMRIGHT", 0, -5)
				else
					if leftSide then
						editBox:SetPoint("TOPLEFT", lineConfigBox, "TOPLEFT", 16, -20)
						editBox:SetPoint("TOPRIGHT", lineConfigBox, "TOP", -8, -20)
					else
						editBox:SetPoint("TOPLEFT", lineConfigBox, "TOP", 8, -20)
						editBox:SetPoint("TOPRIGHT", lineConfigBox, "TOPRIGHT", -16, -20)
					end
				end
				editBox:SetJustifyH("LEFT")
		
				local width = editBox:GetWidth()/2 + 10
				local underline = editBox:CreateTexture(nil, "BACKGROUND")
				editBox.underline = underline
				underline:SetTexture("Interface\\Buttons\\WHITE8X8")
				underline:SetHeight(1)
				underline:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", 0, -1)
				underline:SetPoint("TOPRIGHT", editBox, "BOTTOMRIGHT", 0, -1)
				editBox:SetAutoFocus(false)
				
				editBox:SetScript("OnEscapePressed", editBox.ClearFocus)
				editBox.num = i
				editBox.side = leftSide and "left" or "right"
				
				editBox:SetScript("OnEnterPressed", OnEnterPressed)
				editBox:SetScript("OnEditFocusLost", OnEditFocusLost)
				editBox:SetScript("OnEditFocusGained", OnEditFocusGained)
				editBox:SetScript("OnTextChanged", OnTextChanged)
				
				editBox:SetScript("OnTabPressed", OnTabPressed)
			end
		end
	end
	lineConfigBox:Show()
	for i = 1, 30 do
		local left = self.db.profile.lefts[i]
		local right = self.db.profile.rights[i]
		lineConfigBox["left" .. i]:SetText(DogTag:ColorizeCode(CleanCode(left)))
		lineConfigBox["right" .. i]:SetText(DogTag:ColorizeCode(CleanCode(right)))
	end
end

local function fixColor()
	GameTooltipTextLeft1:SetTextColor(1, 1, 1)
end

function CowTip_Text:PostTooltipSetUnit()
	self:AddTimer(0, fixColor)
end

CowTip_Text:RegisterCowTipOption({
	name = L["Line texts"],
	desc = L["Here you can describe the text on the assorted lines of the tooltip."],
	type = 'group',
	args = {
		edit = {
			name = L["Edit lines."],
			desc = L["Edit the line texts."],
			buttonText = L["Edit"],
			type = 'execute',
			func = "CreateLineConfigBox",
		},
		help = {
			name = L["DogTag help"],
			buttonText = L["Open"],
			desc = L["Click to pop up helpful DogTag documentation."],
			type = 'execute',
			func = function()
				DogTag:OpenHelp()
			end
		}
	}
})
