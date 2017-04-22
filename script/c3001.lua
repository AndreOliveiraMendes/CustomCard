--loli #2 the spell wizard intermediary
function c3001.initial_effect(c)
	--spell counter
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,13)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c3001.spctop)
	c:RegisterEffect(e1)
	--atk/def update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function (e,c) return 300*e:GetHandler():GetCounter(0x1) end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(function (e,c) return 250*e:GetHandler():GetCounter(0x1) end)
	c:RegisterEffect(e3)
	--alternative summon method
	e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3001,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c3001.otcon)
	e3:SetOperation(c3001.otop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	--destroy avoid
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c3001.reptg)
	e4:SetValue(c3001.repval)
	c:RegisterEffect(e4)
	--spell effect
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(2)
	e5:SetTarget(c3001.tg)
	e5:SetOperation(c3001.op)
	c:RegisterEffect(e5)
	if not c3001.globalcheck then
		c3001.globalcheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c3001.carchcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c3001.carchcheck(e,tp)
	if Duel.GetFlagEffect(0,2001) then
		 Duel.CreateToken(0,2001)
		 Duel.RegisterFlagEffect(tp,2001,0,0,0)
	end
end
function c3001.spctop(e,tp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x1,1)
end
function c3001.otfilter(c)
	return c:IsCode(3000) and c:GetCounter(0x1)>=4
end
function c3001.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c3001.otfilter,tp,LOCATION_MZONE,0,nil)
	return mg:GetCount()>0
end
function c3001.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c3001.otfilter,tp,LOCATION_MZONE,0,nil)
	g=mg:Select(tp,1,1,nil)
	mg:Sub(g)  
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c3001.repfilter(c,tp)
	return c:IsFaceup() and c2001.IsLoli(c) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c3001.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)
	if chk==0 then return ct>=1 and c:IsCanRemoveCounter(tp,0x1,1,REASON_REPLACE) and eg:IsExists(c3001.repfilter,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(3001,1)) then
		c:RemoveCounter(tp,0x1,1,REASON_REPLACE)
		return true
	else return false end
end
function c3001.repval(e,c)
	return c3001.repfilter(c,e:GetHandlerPlayer())
end
function c3001.filter1(c)
	return c:IsFaceup()
end
function c3001.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c3001.filter3(c)
	return c:IsFacedown()
end
function c3001.tg(e,tp,eg,ev,ep,re,r,rp,chk)
	local d1=aux.Stringid(3001,2)
	local d2=aux.Stringid(3001,3)
	local d3=aux.Stringid(3001,4)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)
	local a1=ct>=1 and c:IsCanRemoveCounter(tp,0x1,1,REASON_COST) and Duel.IsExistingMatchingCard(c3001.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c)
	local a2=ct>=3 and c:IsCanRemoveCounter(tp,0x1,3,REASON_COST) and Duel.IsExistingMatchingCard(c3001.filter2,tp,LOCATION_GRAVE,0,1,nil)
	local a3=ct>=9 and c:IsCanRemoveCounter(tp,0x1,9,REASON_COST) and Duel.IsExistingMatchingCard(c3001.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
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
		local tg=Duel.SelectMatchingCard(tp,c3001.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,c)
		Duel.SetTargetCard(tg)
		ct=1
	elseif opt==1 then
		local tg=Duel.SelectMatchingCard(tp,c3001.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetTargetCard(tg)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
		ct=3
	elseif opt==2 then
		local tg=Duel.SelectMatchingCard(tp,c3001.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetTargetCard(tg)
		Duel.ConfirmCards(tp,tg)
		if tg:GetFirst():IsType(TYPE_SPELL) then
			Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,tg,1,0,0)
		end
		ct=9
	end
	e:SetLabel(opt)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,0,ct)
end
function c3001.op(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	if opt==0 then
		c:RemoveCounter(tp,0x1,1,REASON_COST)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc1=tg:GetFirst()
		local tc2=tg:GetNext()
		if not tc1 or not tc2 then return end
		local code1=tc1:GetCode()
		local code2=tc2:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code1)
		e1:SetReset(RESET_EVENT+0x1e0000+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetValue(code2)
		tc1:RegisterEffect(e2)
	elseif opt==1 then
		c:RemoveCounter(tp,0x1,3,REASON_COST)
		local tg=Duel.GetFirstTarget()
		if not tg then return end
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	elseif opt==2 then
		c:RemoveCounter(tp,0x1,9,REASON_COST)
		local tg=Duel.GetFirstTarget()
		if not tg then return end
		if tg:IsType(TYPE_SPELL) then
			Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		end
	end
end