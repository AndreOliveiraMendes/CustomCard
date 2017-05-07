--Synchron Loli
function c3006.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,c3006.matfilter,1)
	--banish Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c3006.spcost)
	e1:SetTarget(c3006.sptarget)
	e1:SetOperation(c3006.spoperation)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3006,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c3006.negcondition)
	e2:SetTarget(c3006.negtarget)
	e2:SetOperation(c3006.negoperation)
	c:RegisterEffect(e2)
	if not c3006.globalcheck then
		c3006.globalcheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c3006.carchcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c3006.carchcheck(e,tp)
	if Duel.GetFlagEffect(0,2001) then
		 Duel.CreateToken(0,2001)
		 Duel.RegisterFlagEffect(tp,2001,0,0,0)
	end
end
function c3006.matfilter(c)
	return c2001.IsLoli(c)
end
function c3006.costfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(c3006.costfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c) and c:IsReleasable() and not c:IsImmuneToEffect(e)
end
function c3006.costfilter2(c,e,tp,tc)
	return c~=tc and c2001.IsLoli(c) and c:GetLevel()+tc:GetLevel()==8 and c:IsReleasable() and not c:IsImmuneToEffect(e)
end
function c3006.spcost(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3006.costfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g1=Duel.SelectMatchingCard(tp,c3006.costfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c3006.costfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,g1:GetFirst())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c3006.sptarget(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3006.spoperation(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP) then
		 local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_CHANGE_LEVEL)
		 e1:SetValue(8)
		 e1:SetReset(RESET_EVENT+0x1fe0000)
		 c:RegisterEffect(e1)
		 local e2=e1:Clone()
		 e2:SetCode(EFFECT_ADD_TYPE)
		 e2:SetValue(TYPE_TUNER)
		 c:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c3006.negfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp)
end
function c3006.negcondition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and (g:GetCount()==g:FilterCount(c3006.negfilter,nil,tp) or g:GetCount()==g:FilterCount(c3006.negfilter,nil,1-tp))
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c3006.negtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c3006.negoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		Duel.Destroy(eg,REASON_EFFECT)
	end
end