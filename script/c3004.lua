--Hand Summoner
function c3004.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_XMAT_COUNT_LIMIT)
	c:EnableReviveLimit()
	--sp 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3004,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(c3004.spcon1)
	e1:SetOperation(c3004.spop1)
	c:RegisterEffect(e1)
	--sp 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3004,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(POS_FACEUP,0)
	e2:SetCondition(c3004.spcon2)
	e2:SetOperation(c3004.spop2)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3004,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c3004.sumlimit)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(3004,3))
	e4:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c3004.sphcost)
	e4:SetTarget(c3004.sphtarget)
	e4:SetOperation(c3004.sphoperation)
	c:RegisterEffect(e4)
end
function c3004.spcon1(e,c)
	if c==nil then return true end
	local chk1=Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE)>0 and Duel.CheckLPCost(c:GetControler(),500)
	local chk2=Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE)==0 and Duel.IsExistingMatchingCard(Card.IsReleasable,c:GetControler(),0,LOCATION_MZONE,1,nil)
	return chk1 or chk2
end
function c3004.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local chk1=Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE)>0 and Duel.CheckLPCost(c:GetControler(),500)
	local chk2=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 and Duel.IsExistingMatchingCard(Card.IsReleasable,c:GetControler(),0,LOCATION_MZONE,1,nil)
	if chk1 then
		Duel.PayLPCost(c:GetControler(),500)
	elseif chk2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(c:GetControler(),Card.IsReleasable,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Release(g,REASON_COST)
	end
end
function c3004.spcon2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,c:GetControler(),LOCATION_HAND,0,2,c)
end
function c3004.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(c:GetControler(),Card.IsAbleToGraveAsCost,c:GetControler(),LOCATION_HAND,0,2,2,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c3004.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_HAND)
end
function c3004.sphcost(e,tp,eg,ev,ep,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c3004.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()<=5 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,true,false)
end
function c3004.sphtarget(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c3004.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c3004.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c3004.sphoperation(e,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 then g=g:Select(tp,1,1,nil) end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL,tp,tp,true,false,POS_FACEUP)
	end
end