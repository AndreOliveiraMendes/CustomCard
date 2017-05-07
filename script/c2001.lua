--loli archetype token
function c2001.initial_effect(c)   
end
c2001.lolicolection={
	[3000]=true;[3001]=true;[3002]=true;[3006]=true;
	[3007]=true;[3008]=true;
}
function c2001.IsLoli(c)
	return c:IsSetCard(0xf910) or c2001.lolicolection[c:GetCode()]
end