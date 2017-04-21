--loli 3 the supreme wizard
function c3002.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--summon with 5 tribute + alternatiive
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c3002.ttcon)
	e1:SetOperation(c3002.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--spell gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c3002.scon)
	e2:SetOperation(c3002.scop)
	c:RegisterEffect(e2)
	--set a spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3002,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c3002.cs1)
	e3:SetTarget(c3002.tg1)
	e3:SetOperation(c3002.op1)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3002,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c3002.con2)
	e4:SetTarget(c3002.tg2)
	e4:SetOperation(c3002.op2)
	c:RegisterEffect(e4)
	if not c3002.globalcheck then
		c3002.globalcheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c3002.carchcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c3002.carchcheck(e,tp)
	if Duel.GetFlagEffect(0,2001) then
		 Duel.CreateToken(0,2001)
		 Duel.RegisterFlagEffect(tp,2001,0,0,0)
	end
end
function c3002.otfilter1(c)
	return c:IsCode(3000) and c:GetCounter(0x1)>=4
end
function c3002.otfilter2(c)
	return c:IsCode(3001) and c:GetCounter(0x1)>=8
end
function c3002.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg1=Duel.GetMatchingGroup(c3002.otfilter1,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(c3002.otfilter2,tp,LOCATION_MZONE,0,nil)
	return (minc<=5 and Duel.CheckTribute(c,5)) or mg1:GetCount()>1 or mg2:GetCount()>0
end
function c3002.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Group.CreateGroup()
	local mg1=Duel.GetMatchingGroup(c3002.otfilter1,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(c3002.otfilter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(mg1)
	mg:Merge(mg2)
	if (mg1:GetCount()>1 or mg2:GetCount()>0) and Duel.SelectYesNo(tp,aux.Stringid(3002,0)) then
		local g=Group.CreateGroup()
		if mg1:GetCount()>1 and mg2:GetCount()>0 then
			local g1=mg:Select(tp,1,1,nil)
			g:Merge(g1)
			mg:Sub(g1)
			mg1:Sub(g1)
			mg2:Sub(g1)
			if c3002.otfilter1(g1:GetFirst()) then
				g1=mg1:Select(tp,1,1,nil)
				g:Merge(g1)
				mg:Sub(g1)
				mg1:Sub(g1)
			end
		elseif mg1:GetCount()>1 then
			g=mg1:Select(tp,2,2,nil)
			mg:Sub(g)
			mg1:Sub(g)
		else
			g=mg2:Select(tp,1,1,nil)
			mg:Sub(g)
			mg2:Sub(g)
		end
		c:SetMaterial(g)
		Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	else
		local g=Duel.SelectTribute(tp,c,5,5)
		c:SetMaterial(g)
		Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	end
end
function c3002.scon(e,tp,eg,ev,ep,re,r,rp)
	return re:GetHandler():IsType(TYPE_SPELL)
end
function c3002.scop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x1,1)
end
function c3002.cs1(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1,1,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1,1,REASON_COST)
end
function c3002.sfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c3002.tg1(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(c3002.sfilter,tp,0,LOCATION_DECK,nil)>0 end
	local tg=Duel.GetMatchingGroup(c3002.sfilter,tp,0,LOCATION_DECK,nil)
	tg=tg:RandomSelect(tp,1)
	Duel.SetTargetCard(tg)
end
function c3002.op1(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if ft<=0 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:GetFirst() and tg:GetFirst():IsRelateToEffect(e) and Duel.SSet(tp,tg,1-tp)>0 then
		c:AddCounter(0x1,1)
	end
end
function c3002.con2(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function c3002.tg2(e,tp,eg,ev,ep,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetCounter(0x1)~=0 and c:IsCanRemoveCounter(tp,0x1,1,REASON_EFFECT) end
end
function c3002.spfilter(c,e,tp,dam)
	return c:IsType(TYPE_MONSTER) and c2001.lolicolection[c:GetCode()] and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,true,false) and c:GetAttack()<=dam
end
function c3002.op2(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local dam=Duel.GetBattleDamage(tp)
	if dam==0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(3002,1)) then
		local maxc=math.min(math.floor(dam/100),c:GetCounter(0x1))
		local r={}
		for i=1,maxc do
			r[i]=i
		end
		local opt=Duel.AnnounceNumber(tp,table.unpack(r))
		local spc0=c:GetCounter(0x1)
		c:RemoveCounter(tp,0x1,opt,REASON_EFFECT)
		local spc1=c:GetCounter(0x1)
		if spc1==spc0 then return end
		Duel.ChangeBattleDamage(tp,dam-100*opt)
		if dam<Duel.GetBattleDamage(tp) then return end
		dam=dam-Duel.GetBattleDamage(tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c3002.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,dam) and Duel.SelectYesNo(tp,aux.Stringid(3002,2)) then
			local tg=Duel.SelectMatchingCard(tp,c3002.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,dam)
			Duel.SpecialSummon(tg,SUMMON_TYPE_SPECIAL,tp,tp,true,false,POS_FACEUP)
		end
	end
end