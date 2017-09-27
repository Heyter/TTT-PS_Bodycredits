PS_CORPSE = PS_CORPSE or {}
local IsValid = IsValid

function PS_CORPSE.PS_GetCredits(rag, default)
   if !IsValid(rag) then return default end
   return rag:GetDTInt(1)
end