--loli #1
function c3000.initial_effect(c)
	--spell counter
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,12)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c3000.spctcon)
	e1:SetOperation(c3000.spctop)
	c:RegisterEffect(e1)
	--atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function (e,c) return 200*e:GetHandler():GetCounter(0x1) end)
	c:RegisterEffect(e2)
	--spell effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c3000.tg)
	e3:SetOperation(c3000.op)
	c:RegisterEffect(e3)
	if not c3000.globalcheck then
		c3000.globalcheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c3000.carchcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c3000.carchcheck(e,tp)
	if Duel.GetFlagEffect(0,2001) then
		 Duel.CreateToken(0,2001)
		 Duel.RegisterFlagEffect(tp,2001,0,0,0)
	end
end
function c3000.spctcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function c3000.spctop(e,tp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x1,1)
end
function c3000.filter1(c)
	return c:IsFaceup()
end
function c3000.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c3000.tg(e,tp,eg,ev,ep,re,r,rp,chk)
	local d1=aux.Stringid(3000,0)
	local d2=aux.Stringid(3000,1)
	local d3=aux.Stringid(3000,2)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)
	local a1=ct>=1 and c:IsCanRemoveCounter(tp,0x1,1,REASON_COST)
	local a2=ct>=2 and c:IsCanRemoveCounter(tp,0x1,2,REASON_COST) and Duel.IsExistingMatchingCard(c3000.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	local a3=ct>=5 and c:IsCanRemoveCounter(tp,0x1,5,REASON_COST) and Duel.IsExistingMatchingCard(c3000.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return a1 or a2 end
	local opt=0
	if a1 and a2 and a3 then
		opt=Duel.SelectOption(tp,d1,d2,d3)
	elseif a1 and a2 then
		opt=Duel.SelectOption(tp,d1,d2)
	elseif a1 and a3 then
		opt=Duel.SelectOption(tp,d1,d3)
		if opt==1 then opt=opt+1 end
	elseif a2 and a3 then
		opt=Duel.SelectOption(tp,d2,d3)+1
	elseif a1 then
		opt=Duel.SelectOption(tp,d1)
	elseif a2 then
		opt=Duel.SelectOption(tp,d2)+1
	elseif a3 then
		opt=Duel.SelectOption(tp,d3)+2
	end
	if opt==0 then
		Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,c,1,0,100)
		ct=1
	elseif opt==1 then
		local tg=Duel.SelectMatchingCard(tp,c3000.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		Duel.SetTargetCard(tg)
		ct=2
	elseif opt==2 then
		local tg=Duel.SelectMatchingCard(tp,c3000.filter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SetTargetCard(tg)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,tg,1,0,0)
		ct=5
	end
	e:SetLabel(opt)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,0,ct)
end
function c3000.op(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	if opt==0 then
		c:RemoveCounter(tp,0x1,1,REASON_COST)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+0x1e0000)
		c:RegisterEffect(e1)
	elseif opt==1 then
		c:RemoveCounter(tp,0x1,2,REASON_COST)
		local tg=Duel.GetFirstTarget()
		if not tg then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(tg:GetCode())
		e1:SetReset(RESET_EVENT+0x1e0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif opt==2 then
		c:RemoveCounter(tp,0x1,5,REASON_COST)
		local tg=Duel.GetFirstTarget()
		if not tg then return end
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
end