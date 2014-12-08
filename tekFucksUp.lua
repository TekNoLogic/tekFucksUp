
local myname, ns = ...


local frame = CreateFrame("Frame", "tekFucksUp", UIParent)
frame:SetHeight(2)
frame:SetPoint("BOTTOMLEFT", WorldFrame)
frame:SetPoint("RIGHT", WorldFrame)

local notex = frame:CreateTexture(nil, "BACKGROUND")
notex:SetTexture("Interface\\AddOns\\tekFucksUp\\textures\\texture")
notex:SetVertexColor(.5, .5, .5)
notex:SetAllPoints()


local bar = CreateFrame("Frame", nil, frame)
bar:SetPoint("TOPLEFT", frame)
bar:SetPoint("BOTTOM", frame)

local tex = bar:CreateTexture(nil, "BORDER")
tex:SetTexture("Interface\\AddOns\\tekFucksUp\\textures\\texture")
tex:SetVertexColor(0, .4, .9)
tex:SetAllPoints()

local spark = bar:CreateTexture(nil, "OVERLAY")
spark:SetTexture("Interface\\AddOns\\tekFucksUp\\textures\\glow")
spark:SetVertexColor(0, .4, .9)
spark:SetWidth(128)
spark:SetHeight(16)
spark:SetBlendMode("ADD")
spark:SetPoint("RIGHT", bar, "RIGHT", 11, 0)

local spark2 = bar:CreateTexture(nil, "OVERLAY")
spark2:SetTexture("Interface\\AddOns\\tekFucksUp\\textures\\glow2")
spark2:SetWidth(128)
spark2:SetHeight(16)
spark2:SetBlendMode("ADD")
spark2:SetPoint("RIGHT", bar, "RIGHT", 11, 0)


local rested = CreateFrame("Frame", nil, frame)
rested:SetPoint("TOPLEFT", bar, "TOPRIGHT")
rested:SetPoint("BOTTOM", bar)

local rtex = rested:CreateTexture(nil, "BORDER")
rtex:SetTexture("Interface\\AddOns\\tekFucksUp\\textures\\texture")
rtex:SetVertexColor(1, .2, 1)
rtex:SetAllPoints()


local MAX_PLAYER_LEVEL
function ns.OnLoad()
	MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]

	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		ns.RegisterEvent('UPDATE_FACTION')
		ns.UPDATE_FACTION()
	else
		ns.RegisterEvent('PLAYER_XP_UPDATE')
		ns.PLAYER_XP_UPDATE()
	end
end


function ns.PLAYER_XP_UPDATE()
	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		ns.UnregisterEvent('PLAYER_XP_UPDATE')
		ns.RegisterEvent('UPDATE_FACTION')
		ns.UPDATE_FACTION()
		return
	end

	local currentXP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP, width = GetXPExhaustion() or 0, UIParent:GetWidth()
	bar:SetWidth(currentXP/maxXP * width)
	rested:SetWidth( math.min(restXP, maxXP-currentXP)/maxXP * width + 0.001)
end


function ns.UPDATE_FACTION()
	rested:Hide()

	local name, standingID, barMin, barMax, barValue = GetWatchedFactionInfo()
	if not name then return	frame:Hide() end

	frame:Show()

	local color = FACTION_BAR_COLORS[standingID]
	tex:SetVertexColor(color.r, color.g, color.b)
	spark:SetVertexColor(color.r, color.g, color.b)

	local width = UIParent:GetWidth()
	local adjValue, adjMax = barValue - barMin, barMax - barMin
	bar:SetWidth(adjValue/adjMax * width)
end
