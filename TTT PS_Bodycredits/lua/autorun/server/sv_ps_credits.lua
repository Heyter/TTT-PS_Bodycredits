local YobaCode = YobaCode
local PS_CORPSE = PS_CORPSE
local hook_Add = hook.Add
local ServerLog = ServerLog
local math_floor, math_random = math.floor, math.random
local IsValid = IsValid

local ps = {
	chance = 20 -- 20% шанс выпадение кредитов.
	percent = 0.05 -- 5% кредитов теряет при смерти игрок. (0.10 = 10%; 1.00 = 100%)
	minCredits = 50 -- Если у игрока меньше чем minCredits кредитов, тогда они не выпадут.
}

function PS_CORPSE.PS_SetCredits(rag, credits)
   rag:SetDTInt(1, credits)
end

hook_Add("TTTOnCorpseCreated", "TTTOnCorpseCreated_PS_credits", function(rag, victim, attacker)
	if (victim == attacker) or !attacker:IsPlayer() or !victim:IsPlayer() then return end
	if (attacker:GetRole() == victim:GetRole()) or (attacker:GetRole() == ROLE_INNOCENT and victim:GetDetective()) then return end
	
	local math_chance = 100 * math_random()
	if math_chance > ps.chance then return end
	
	local points = 1
	local getPoints = victim:PS_GetPoints()
	if getPoints < ps.minCredits then return end
	
	points = getPoints * ps.percent
	PS_CORPSE.PS_SetCredits(rag, math_floor(points))
end)

hook_Add("TTTBodyFound", "TTTBodyFound_PS_credits", function(ply, body, rag, nick)
	if !IsValid(ply) or !ply:Alive() or (ply:IsSpec() and ply:GetForceSpec()) then return end
	
	local credits = PS_CORPSE.PS_GetCredits(rag, 0)
	if credits > 0 then
		ply:PS_GivePoints(credits)
		PS_CORPSE.PS_SetCredits(rag, 0)
		ply:ChatPrint("Вы собрали с тела "..credits.." кредитов")
		ServerLog(ply:Nick().." took "..credits.." ps_credits from the body of "..nick.."\n")
	end
end)
