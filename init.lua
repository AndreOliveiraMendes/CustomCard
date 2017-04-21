Yuudachi={}
poi=Yuudachi
--function to collect info
Card.info=function (c)
	local code=c:GetCode()
	local t=c:GetType()
	local p=c:GetPosition()
	local pb=c:GetBattlePosition()
	local lv=c:GetLevel()
	local rk=c:GetRank()
	local race=c:GetRace()
	local ls=c:GetLeftScale()
	local rs=c:GetRightScale()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	Debug.Message("card code:" .. tostring(code))
	Debug.Message("card type:" .. tostring(t))
	if p==POS_FACEDOWN then
		Debug.Message("card position:FACEDOWN")
	elseif p==POS_FACEDOWN_ATTACK then
		Debug.Message("card position:FACEDOWN ATTACK")
	elseif p==POS_FACEDOWN_DEFENSE then
		Debug.Message("card position:FACEDOWN DEFENSE")
	elseif p==POS_FACEUP then
		Debug.Message("card position:FACEUP")
	elseif p==POS_FACEUP_ATTACK then
		Debug.Message("card position:FACEUP ATTACK")
	elseif p==POS_FACEUP_DEFENSE then
		Debug.Message("card position:FACEUP DEFENSE")
	end
	if pb~=b then
		if pb==POS_FACEDOWN then
			Debug.Message("card position:FACEDOWN")
		elseif pb==POS_FACEDOWN_ATTACK then
			Debug.Message("card position:FACEDOWN ATTACK")
		elseif pb==POS_FACEDOWN_DEFENSE then
			Debug.Message("card position:FACEDOWN DEFENSE")
		elseif pb==POS_FACEUP then
			Debug.Message("card position:FACEUP")
		elseif pb==POS_FACEUP_ATTACK then
			Debug.Message("card position:FACEUP ATTACK")
		elseif pb==POS_FACEUP_DEFENSE then
			Debug.Message("card position:FACEUP DEFENSE")
		end
	end
	Debug.Message("this card level is " .. tostring(lv))
	Debug.Message("this card rank is " .. tostring(rk))
	Debug.Message("this card race is " .. tostring(race))
	Debug.Message("this card ls is " .. tostring(ls))
	Debug.Message("this card rs is " .. tostring(rs))
	Debug.Message("this card atk is " .. tostring(atk))
	Debug.Message("this card def is " .. tostring(def))
end
--custom puzzle
function Yuudachi.BeginPuzzle(otp,skdp,sksp,effect)
	if otp==nil or otp==true then
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TURN_END)
		e1:SetCountLimit(1)
		e1:SetOperation(aux.PuzzleOp)
		Duel.RegisterEffect(e1,0)
	end
	if skdp==nil or skdp==true then
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_SKIP_DP)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,0)
	end
	if sksp==nil or sksp==true then
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_SKIP_SP)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,0)
	end
end
--custom function
function Yuudachi.dm(a,d,lp,tp)
    if not d then
        if a:IsPosition(POS_FACEUP_ATTACK) and a:IsControler(1-tp) then
            if a:GetAttack()>0 then
                return a:GetAttack(),tp
            else
                return 0,PLAYER_NONE
            end
        elseif a:IsPosition(POS_FACEUP_DEFENSE) and a:IsControler(1-tp) then
            if a:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
                if a:GetDefense()>0 then
                    return a:GetDefense(),tp
                else
                    return 0,PLAYER_NONE
                end
            elseif a:IsHasEffect(75372290) then
                if a:GetAttack()>0 then
                    return a:GetAttack(),tp
                else
                    return 0,PLAYER_NONE
                end
            end
        elseif a:IsPosition(POS_FACEUP_ATTACK) and a:IsControler(tp) then
            if a:GetAttack()>0 then
                return a:GetAttack(),1-tp
            else
                return 0,PLAYER_NONE
            end
        elseif a:IsPosition(POS_FACEUP_DEFENSE) and a:IsControler(tp) then
            if a:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
                if a:GetDefense()>0 then
                    return a:GetDefense(),1-tp
                else
                    return 0,PLAYER_NONE
                end
            elseif a:IsHasEffect(75372290) then
                if a:GetAttack()>0 then
                    return a:GetAttack(),1-tp
                else
                    return 0,PLAYER_NONE
                end
            end
        end
    else
        if a:IsPosition(POS_FACEUP_ATTACK) and a:IsControler(1-tp) then
            if d:IsPosition(POS_ATTACK) then
                if a:GetAttack()>d:GetAttack() then
                    return a:GetAttack()-d:GetAttack(),tp
                elseif a:GetAttack()==d:GetAttack() then
                    return 0,PLAYER_NONE
                else
                    return d:GetAttack()-a:GetAttack(),1-tp
                end
            elseif d:IsPosition(POS_DEFENSE) then
                if a:GetAttack()>d:GetDefense() and a:IsHasEffect(EFFECT_PIERCE) then
                    return a:GetAttack()-d:GetDefense(),tp
                elseif a:GetAttack()>=d:GetDefense() then
                    return 0,PLAYER_NONE
                else
                    return d:GetDefense()-a:GetAttack(),1-tp
                end
            end
        elseif a:IsPosition(POS_FACEUP_DEFENSE) and a:IsControler(1-tp) then
            if a:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
                if d:IsPosition(POS_ATTACK) then
                    if a:GetDefense()>d:GetAttack() then
                        return a:GetDefense()-d:GetAttack(),tp
                    elseif a:GetDefense()>=d:GetAttack() then
                        return 0,PLAYER_NONE
                    else
                        return d:GetAttack()-a:GetDefense(),1-tp
                    end
                elseif d:IsPosition(POS_DEFENSE) then
                    if a:GetDefense()>d:GetDefense() and a:IsHasEffect(EFFECT_PIERCE) then
                        return a:GetDefense()-d:GetDefense(),tp
                    elseif a:GetDefense()>=d:GetDefense() then
                        return 0,PLAYER_NONE
                    else
                        return d:GetDefense()-a:GetDefense(),1-tp
                    end
                end
            elseif a:IsHasEffect(75372290) then
                if d:IsPosition(POS_ATTACK) then
                    if a:GetAttack()>d:GetAttack() then
                        return a:GetAttack()-d:GetAttack(),tp
                    elseif a:GetAttack()>=d:GetAttack() then
                        return 0,PLAYER_NONE
                    else
                        return d:GetAttack()-a:GetAttack(),1-tp
                    end
                elseif d:IsPosition(POS_DEFENSE) then
                    if a:GetAttack()>d:GetDefense() and a:IsHasEffect(EFFECT_PIERCE) then
                        return a:GetDefense()-d:GetDefense(),tp
                    elseif a:GetAttack()>=d:GetDefense() then
                        return 0,PLAYER_NONE
                    else
                        return d:GetDefense()-a:GetAttack(),1-tp
                    end
                end
            end
        elseif a:IsPosition(POS_FACEUP_ATTACK) and a:IsControler(tp) then
            if d:IsPosition(POS_ATTACK) then
                if a:GetAttack()>d:GetAttack() then
                    return a:GetAttack()-d:GetAttack(),1-tp
                elseif a:GetAttack()==d:GetAttack() then
                    return 0,PLAYER_NONE
                else
                    return d:GetAttack()-a:GetAttack(),tp
                end
            elseif d:IsPosition(POS_DEFENSE) then
                if a:GetAttack()>d:GetDefense() and a:IsHasEffect(EFFECT_PIERCE) then
                    return a:GetAttack()-d:GetDefense(),1-tp
                elseif a:GetAttack()>=d:GetDefense() then
                    return 0,PLAYER_NONE
                else
                    return d:GetDefense()-a:GetAttack(),tp
                end
            end
        elseif a:IsPosition(POS_FACEUP_DEFENSE) and a:IsControler(tp) then
            if a:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
                if d:IsPosition(POS_ATTACK) then
                    if a:GetDefense()>d:GetAttack() then
                        return a:GetDefense()-d:GetAttack(),1-tp
                    elseif a:GetDefense()>=d:GetAttack() then
                        return 0,PLAYER_NONE
                    else
                        return d:GetAttack()-a:GetDefense(),tp
                    end
                elseif d:IsPosition(POS_DEFENSE) then
                    if a:GetDefense()>d:GetDefense() and a:IsHasEffect(EFFECT_PIERCE) then
                        return a:GetDefense()-d:GetDefense(),1-tp
                    elseif a:GetDefense()>=d:GetDefense() then
                        return 0,PLAYER_NONE
                    else
                        return d:GetDefense()-a:GetDefense(),tp
                    end
                end
            elseif a:IsHasEffect(75372290) then
                if d:IsPosition(POS_ATTACK) then
                    if a:GetAttack()>d:GetAttack() then
                        return a:GetAttack()-d:GetAttack(),1-tp
                    elseif a:GetAttack()>=d:GetAttack() then
                        return 0,PLAYER_NONE
                    else
                        return d:GetAttack()-a:GetAttack(),tp
                    end
                elseif d:IsPosition(POS_DEFENSE) then
                    if a:GetAttack()>d:GetDefense() and a:IsHasEffect(EFFECT_PIERCE) then
                        return a:GetDefense()-d:GetDefense(),1-tp
                    elseif a:GetAttack()>=d:GetDefense() then
                        return 0,PLAYER_NONE
                    else
                        return d:GetDefense()-a:GetAttack(),tp
                    end
                end
            end
        end
    end
end
