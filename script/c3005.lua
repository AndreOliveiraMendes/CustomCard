--soul transference
local cif,cid=c3005,3005
function cif.initial_effect(c)
   --
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_ATTACK_ANNOUNCE)
   e1:SetCondition(cif.condition)
   e1:SetTarget(cif.target)
   e1:SetOperation(cif.operation)
   c:RegisterEffect(e1)
end
function cif.condition(e,tp)
   local a=Duel.GetAttacker()
   local d=Duel.GetAttackTarget()
   e:SetLabelObject(d)
   return a:IsControler(1-tp) and d and d:IsControler(tp)
end
function cif.filter(c,e)
   return c:IsAbleToRemoveAsCost() and not c:IsImmuneToEffect(e)
end
function cif.target(e,tp,eg,ev,ep,re,r,rp,chk)
   local d=e:GetLabelObject()
   if chk==0 then return Duel.IsExistingMatchingCard(cif.filter,tp,LOCATION_GRAVE,0,1,nil,e) end
   local tg=Duel.SelectMatchingCard(tp,cif.filter,tp,LOCATION_GRAVE,0,1,1,nil,e)
   local tc=tg:GetFirst()
   local atk=0
   while tc do
	   if Duel.Remove(tc,0,REASON_COST)~=0 then atk=atk+tc:GetAttack() end
	   tc=tg:GetNext()
   end
   Duel.SetTargetCard(d)
   Duel.SetTargetParam(atk)
   Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,d,1,0,atk)
end
function cif.operation(e,tp,eg,ev,ep,re,r,rp)
   local c=e:GetHandler()
   local tg,atk=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PARAM)
   local tc=tg:GetFirst()
   while tc do
	   if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_UPDATE_ATTACK)
		   e1:SetValue(atk)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   tc:RegisterEffect(e1)
	   end
	   tc=tg:GetNext()
   end  
end