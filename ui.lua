local screen = UI.ScreenSize()
local center = {x = screen.width / 2, y = screen.height / 2}

PlayerDirection = {

    sync = nil

    , uiContainer = {}

    , Init = function (self)
        self:CreateUI()
        self:SetUI(
			PlayerDirectionUI.x
			, PlayerDirectionUI.y
			, PlayerDirectionUI.width
			, PlayerDirectionUI.height
		)
        self:CreateUISync()
    end

    , CreateUI = function (self)
        self.uiContainer.Background = UI.Box.Create()
        self.uiContainer.Text = {
              {"北", UI.Text.Create()}
			, {"東",  UI.Text.Create()}
            , {"南", UI.Text.Create()}
			, {"西",  UI.Text.Create()}
        }
        self.uiContainer.Display = UI.Text.Create()
        self.uiContainer.Pointer = UI.Box.Create()
    end

    , SetUI = function (self, x, y, width, height)
        self.uiContainer.Background:Set({
            x = x
            , y = y
            , width = width
            , height = height
            , r = 0, g = 0, b = 0, a = 160
        })

		local count = 0
		local boxSize = 16
		local TextOffsetY = 12
		local centerX, centerY = x + width / 2, y + height / 2
		local radius = math.min(width, height) / 2 - 8
        for _,v in pairs(self.uiContainer.Text) do
			local angle = math.rad(count * 90 - 90)
			local offset = {
				  x = math.cos(angle)
				, y = math.sin(angle)
			}
            v[2]:Set({
                  x = centerX + offset.x * radius - boxSize / 2
                , y = centerY + offset.y * radius - boxSize / 2 + TextOffsetY
                , width = boxSize
                , height = boxSize
                , r = 255, g = 255, b = 255

                , text = v[1]
                , font = "small"
                , align = "center"
            })
			count = count + 1
        end

		self.uiContainer.Display:Set({
            x = x
            , y = y + TextOffsetY
            , width = width
            , height = height
            , r = 255, g = 0, b = 0

			, text = "360.000"
			, font = "small"
			, align = "center"
        })

		self.uiContainer.Pointer:Set({
			width = 5, height = 5
            , r = 0, g = 220, b = 0, a = 0
        })
    end

	, SetUIData = function (self, angle)
		local value = string.format("%.3f", angle)
		self.uiContainer.Display:Set({text = value})

		local x = PlayerDirectionUI.x
		local y = PlayerDirectionUI.y
		local width = PlayerDirectionUI.width
		local height = PlayerDirectionUI.height
		local radius = math.min(width, height) / 2 * 0.5
		local centerX, centerY = x + width / 2, y + height / 2
		self.uiContainer.Pointer:Set({
			  x = centerX + math.cos(-math.rad(angle)) * radius
			, y = centerY + math.sin(-math.rad(angle)) * radius
			, a = 255
		})

        self:SetUIColor(angle)
	end

    , SetUIColor = function (self, angle)
        local ui = self.uiContainer.Text
        local color = {r = 255, g = 255, b = 255}
        for k,v in pairs(ui) do
            v[2]:Set(color)
        end

        if angle == 0 then return end

        if     angle >= 225 and angle <= 315 then --[[ 南 ]] ui[3][2]:Set({r = 0, g = 128, b = 255})
		elseif angle >= 135 and angle <= 225 then --[[ 西 ]] ui[4][2]:Set({r = 0, g = 128, b = 255})
		elseif angle >=  45 and angle <= 135 then --[[ 北 ]] ui[1][2]:Set({r = 0, g = 128, b = 255})
        else                                      --[[ 東 ]] ui[2][2]:Set({r = 0, g = 128, b = 255}) end
    end

    , CreateUISync = function (self)
        self.sync = UI.SyncValue.Create("PlayerDirection" .. UI.PlayerIndex())
        self.sync.OnSync = function (this)
           self:SetUIData(this.value)
        end
    end
}


--[[=========================================================
--  [GAME] Post-loading
=========================================================--]]


PlayerDirection:Init()