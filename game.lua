Game.Rule.respawnable = true


--[[ from this link: https://github.com/FWGS/xash3d/blob/master/engine/common/mathlib.c#L351 ]]
-- Converts a vector into angles.
function VectorAngles( forward )
    local tmp, yaw, pitch

    if forward.y == 0 and forward.x == 0
	then
		yaw = 0
        if forward.z > 0
        then
			pitch = 90.0
		else pitch = 270.0 end
	else
		yaw = (math.atan( forward.y, forward.x ) * 180 / math.pi)
		if yaw < 0 then yaw =  yaw + 360 end

		tmp = math.sqrt(forward.x * forward.x + forward.y * forward.y)
		pitch = (math.atan( forward.z, tmp ) * 180 / math.pi)
		if pitch < 0 then pitch = pitch + 360 end
    end

    return {x = pitch, y = yaw, z = 0}
end


PlayerDirection = {

    sync = {}

    , Init = function (self)
        self:CreateGameSync()
    end

    , CreateGameSync = function (self)
        for i = 1, MAX_PLAYER do
            self.sync[i] = Game.SyncValue.Create("PlayerDirection" .. i)
        end
    end

    , SetSync = function (self, index, value)
        self.sync[ index ].value = value
    end

    , GetSync = function (self, index)
        return self.sync[ index ]
    end

    , OnUpdate = function (self, time, player)
		local index = player.index
		local angles = VectorAngles(player.velocity)
		if angles.y ~= self:GetSync(index).value then
			self:SetSync(index, angles.y)
		end
    end
}

function Game.Rule:OnUpdate(time)
	for i = 1, 24 do
		local player = Game.Player.Create(i)
		if player and player.health > 0 then
			PlayerDirection:OnUpdate(time, player)
		end
	end
end


--[[=========================================================
--  [GAME] Post-loading
=========================================================--]]


PlayerDirection:Init()