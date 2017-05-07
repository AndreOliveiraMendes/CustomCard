--Odd-Eyes Synchro loli
function c3007.initial_effect(c)
	aux.AddSynchroProcedure(c,c3007.mat,nil,1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3007,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c3007.negcondition)
	e1:SetTarget(c3007.negtarget)
	e1:SetOperation(c3007.negoperation)
	c:RegisterEffect(e1)
	--double
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c3007.damcon)
	e2:SetOperation(c3007.damop)
	c:RegisterEffect(e2)
	if not c3007.globalcheck then
		c3007.globalcheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c3007.carchcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c3007.carchcheck(e,tp)
	if Duel.GetFlagEffect(0,2001) then
		 Duel.CreateToken(0,2001)
		 Duel.RegisterFlagEffect(tp,2001,0,0,0)
	end
end
function c3007.mat(c)
	return c2001.IsLoli(c)
end
function c3007.negfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp)
end
function c3007.negcondition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and (g:FilterCount(c3007.negfilter,nil,tp)~=0 and g:FilterCount(c3007.negfilter,nil,1-tp)~=0)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c3007.negtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c3007.negoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(re:GetHandler():GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c3007.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c3007.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*e:GetHandler():GetMaterialCount())
end