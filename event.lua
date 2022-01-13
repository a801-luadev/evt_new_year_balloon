local next = next
local math_floor, math_random = math.floor, math.random
local str_format, str_gmatch, str_gsub, str_match, str_sub = string.format, string.gmatch, string.gsub, string.match, string.sub
local tbl_concat, time, tbl_remove, tonumber, tbl_unpack = table.concat, os.time, table.remove, tonumber, table.unpack

--[[ Module Info ]]--
local module = {
	name = "ny22",
	formalName = "Blooming B'loons",

	team = {
		developer = "Bolodefchoco#0015",
		artist = { "Furianera#0015", "Ricardinhotv#0000", "Albinoska#0000", "Karasu#0010" },
		creative = "Eremia#2246"
	},

	reward = {
		orb = "evt_new_year_balloon_orb",
		pet = {
			dragon = "evt_new_year_balloon_pet_dragon",
			tiger = "evt_new_year_balloon_pet_tiger"
		}
	},
	totalCoinsForReward = 150,
	totalPointsForPet = 10,

	totalStaticDragons = 18,
	totalShooterDragons = 13,

	maxDeaths = 5,

	minPlayers = 5,
	maxPlayers = 60,

	time = 1.5 * 60,
	map = {
		xml = [[<C><P DS="m;100,4935,130,4935,160,4935,190,4935,220,4935,250,4935,280,4935,310,4935,340,4935,370,4935,400,4935,430,4935,460,4935,490,4935,520,4935,550,4935,580,4935,610,4935,640,4935,670,4935,700,4935" H="5000" /><Z><S><S lua="1" L="800" X="400" H="50" Y="4975" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S P="0,0,0.3,0.2,0,0,0,0" L="3000" X="400" c="3" Y="-5" T="12" H="10" /><S H="10" L="3000" X="805" c="3" Y="1500" T="12" P="0,0,0,0,90,0,0,0" /><S P="0,0,0,0,90,0,0,0" L="3000" H="10" c="3" Y="1500" T="12" X="-5" /><S P="0,0,0,0,90,0,0,0" L="3000" H="10" c="3" Y="4500" T="12" X="805" /><S H="10" L="3000" X="-5" c="3" Y="4500" T="12" P="0,0,0,0,90,0,0,0" /><S P="0,0,0,0,90,0,0,0" L="3000" H="10" c="3" Y="7500" T="12" X="-5" /><S H="10" L="3000" X="805" c="3" Y="7500" T="12" P="0,0,0,0,90,0,0,0" /><S P="0,0,0,0,90,0,0,0" L="3000" H="10" c="3" Y="10500" T="12" X="805" /><S H="10" L="3000" X="-5" c="3" Y="10500" T="12" P="0,0,0,0,90,0,0,0" /></S><D /><O /></Z></C>]],
		background = "17e470920d9.jpg"
	},
}

if not tfm.get.room.playerList[module.team.developer]
	and (tfm.get.room.uniquePlayers < module.minPlayers
		or tfm.get.room.uniquePlayers > module.maxPlayers) then
	return system.exit()
end

math.randomseed(time())

--[[ Translations ]]--
local translation
do
	local translations = {
		en = {
			credits = "<O>Thank you for celebrating the Chinese new year with us! This event has been brought to you thanks to the developer <VP>%s</VP>, the artists <VP>%s</VP> and the ideas of <VP>%s</VP>."
		},
		br = {
			credits = "<O>Obrigado por celebrar o ano novo Chinês com a gente! Trazido a vocês graças ao desenvolvedor <VP>%s</VP>, aos artistas <VP>%s</VP> e as ideas de <VP>%s</VP>."
		},
		es = {
			credits = "<O>¡Gracias por celebrar el año nuevo chino con nosotros! Este evento fue creado gracias al desarrollador <VP>%s</VP>, los artistas <VP>%s</VP> y las ideas de <VP>%s</VP>."
		},
		fr = {
			credits = "<O>Merci d'avoir célébré le Nouvel An Chinois avec nous ! Cet événement vous a été présenté par le développeur <VP>%s</VP>, les artistes <VP>%s</VP> et les idées de <VP>%s</VP>."
		},
		pt = {
			credits = "<O>Obrigado por celebrar o novo ano chinês conosco! Créditos aos nossos desenvolvedores <VP>%s</VP>, aos artistas <VP>%s</VP> e as ideas de <VP>%s</VP> pela sua dedicação neste evento!."
		},
		cn = {
			credits = "<O>感謝你跟我們一起慶祝農曆新年! 為你帶來這個活動的開發者是 <VP>%s</VP>, 繪圖 <VP>%s</VP> 以及構思 <VP>%s</VP>."
		},
		it = {
			credits = "<O>Grazie per aver celebrato con noi il Capodanno Cinese! L'evento è stato realizzato dagli sviluppatori <VP>%s</VP>, gli artisti <VP>%s</VP> e le idee di <VP>%s</VP>."
		},
		hu = {
			credits = "<O>Köszönjük, hogy velünk ünnepelted a Kínai újévet! Az event nem valósulhatott volna meg a programozó <VP>%s</VP>, a művész <VP>%s</VP> és az ötletgazda <VP>%s</VP> segítsége nélkül."
		},
		nl = {
			credits = "<O>Dankjewel voor het vieren van het Chinese Nieuwjaar met ons! Deze event is ontwikkeld door de developer <VP>%s</VP, de artiesten <VP>%s</VP> en het idee van <VP>%s</VP>."
		},
		ru = {
			credits = "<O>Спасибо что отпраздновали Китайский Новый Год с нами! Этот ивент был представлен вам благодаря разработчику <VP>%s</VP>, артистам <VP>%s</VP> и идеям <VP>%s</VP>."
		},
		ro = {
			credits = "<O>Mulțumim că ați sărbătorit Anul Nou Chinezesc împreună cu noi! Acest eveniment vă fusese oferit mulțumită creatorului <VP>%s</VP>, artiștilor <VP>%s</VP> și ideilor lui <VP>%s</VP>."
		},
		jp = {
			credits = "<O>ご一緒に旧正月を祝ってくれてありがとうございます！このエベントはデベロッパーの<VP>%s</VP>さん、アーティストの<VP>%s</VP>さんたち、とデザイナーの<VP>%s</VP>さんのおかげさまです。"
		}
	}

	translation = translations[tfm.get.room.community] or translations.en

	translation.credits = str_format(translation.credits, module.team.developer,
		tbl_concat(module.team.artist, "</VP>, <VP>"), module.team.creative)
end

--[[ Data ]]--
-- Laagaadoo's DataHandler
local DataHandler, playerCache = { }, { }
do
	DataHandler.__index = DataHandler

	DataHandler.new = function(moduleID, structure)
		local structureIndexes = { }
		for k, v in next, structure do
			structureIndexes[v.index] = k
			v.type = v.type or type(v.default)
		end

		return setmetatable({
			playerData = { },
			moduleID = moduleID,
			structure = structure,
			structureIndexes = structureIndexes,
			otherPlayerData = { }
		}, DataHandler)
	end

	local extractPlayerData = function(self, dataStr)
		local i, module, j = str_match(dataStr, "()" .. self.moduleID .. "=(%b{})()")
		if i then
			return module, (str_sub(dataStr, 1, i - 1) .. str_sub(dataStr, j + 1))
		end
		return nil, dataStr
	end

	local replaceComma = function(str)
		return str_gsub(str, ',', '\0')
	end

	local getDataNameById = function(structure, index)
		for k, v in next, structure do
			if v.index == index then
				return k
			end
		end
	end

	local strToTable

	strToTable = function(str)
		local out, index = { }, 0

		str = str_gsub(str, "%b{}", replaceComma)

		local tbl
		for value in str_gmatch(str, "[^,]+") do
			value = str_gsub(value, "%z", ',')

			tbl = str_match(value, "^{(.-)}$")

			index = index + 1
			if tbl then
				out[index] = strToTable(tbl)
			else
				out[index] = tonumber(value) or value
			end
		end

		return out
	end

	local getDataValue = function(value, valueType, valueName, valueDefault)
		if valueType == "boolean" then
			if value then
				value = (value == '1')
			else
				value = valueDefault
			end
		elseif valueType == "table" then
			value = str_match(value or '', "^{(.-)}$")
			value = value and strToTable(value) or valueDefault
		else
			if valueType == "number" then
				value = value and tonumber(value, 16)
			elseif valueType == "string" and value then
				value = str_match(value, "^\"(.-)\"$")
			end
			value = value or valueDefault
		end

		return value
	end

	local handleModuleData = function(self, playerName, structure, moduleData)
		local playerData = self.playerData[playerName]
		local valueName

		local dataIndex = 1
		if #moduleData > 0 then
			moduleData = str_gsub(moduleData, "%b{}", replaceComma)

			for value in str_gmatch(moduleData, "[^,]+") do
				value = str_gsub(value, "%z", ',')

				valueName = getDataNameById(structure, dataIndex)
				playerData[valueName] = getDataValue(value, structure[valueName].type, valueName,
					structure[valueName].default)
				dataIndex = dataIndex + 1
			end
		end

		local higherIndex = #self.structureIndexes
		if dataIndex <= higherIndex then
			for i = dataIndex, higherIndex do
				valueName = getDataNameById(structure, i)
				playerData[valueName] = getDataValue(nil, structure[valueName].type, valueName,
					structure[valueName].default)
			end
		end
	end

	DataHandler.newPlayer = function(self, playerName, data)
		data = data or ''

		self.playerData[playerName] = { }

		local module, otherData = extractPlayerData(self, data)
		self.otherPlayerData[playerName] = otherData

		handleModuleData(self, playerName, self.structure, (module and str_sub(module, 2, -2) or ''))

		return self
	end

	local tblToStr
	local transformType = function(valueType, index, str, value)
		if valueType == "number" then
			index = index + 1
			str[index] = str_format("%x", value)
		elseif valueType == "string" then
			index = index + 1
			str[index] = '"'
			index = index + 1
			str[index] = value
			index = index + 1
			str[index] = '"'
		elseif valueType == "boolean" then
			index = index + 1
			str[index] = (value and '1' or '0')
		elseif valueType == "table" then
			index = index + 1
			str[index] = '{'
			index = index + 1
			str[index] = tblToStr(value)
			index = index + 1
			str[index] = '}'
		end
		return index
	end

	tblToStr = function(tbl)
		local str, index = { }, 0

		local valueType
		for k, v in next, tbl do
			index = transformType(type(v), index, str, v)
			index = index + 1
			str[index] = ','
		end

		if str[index] == ',' then
			str[index] = ''
		end

		return tbl_concat(str)
	end

	local dataToStr = function(self, playerName)
		local str, index = { self.moduleID, "={" }, 2

		local playerData = self.playerData[playerName]
		local structureIndexes = self.structureIndexes
		local structure = self.structure

		local valueName, valueType, value
		for i = 1, #structureIndexes do
			valueName = structureIndexes[i]
			index = transformType(structure[valueName].type, index, str, playerData[valueName])
			index = index + 1
			str[index] = ','
		end

		if str[index] == ',' then
			str[index] = '}'
		else
			str[index + 1] = '}'
		end

		return tbl_concat(str)
	end

	DataHandler.dumpPlayer = function(self, playerName)
		local otherPlayerData = self.otherPlayerData[playerName]
		if otherPlayerData == '' then
			return dataToStr(self, playerName)
		else
			return dataToStr(self, playerName) .. "," .. otherPlayerData
		end
	end

	DataHandler.get = function(self, playerName, valueName)
		return self.playerData[playerName][valueName]
	end

	DataHandler.set = function(self, playerName, valueName, newValue, sum, _forceSave)
		playerName = self.playerData[playerName]
		if sum then
			playerName[valueName] = playerName[valueName] + newValue
		else
			playerName[valueName] = newValue
		end
		return self
	end

	DataHandler.save = function(self, playerName)
		system.savePlayerData(playerName, self:dumpPlayer(playerName))

		return self
	end
end

local timer = { }
do
	timer.start = function(self, callback, ms, times, ...)
		local t = self._timers
		t._count = t._count + 1

		t[t._count] = {
			id = t._count,
			callback = callback,
			args = { ... },
			defaultMilliseconds = ms,
			milliseconds = ms,
			times = times
		}
		t[t._count].args[#t[t._count].args + 1] = t[t._count]

		return t._count
	end

	timer.delete = function(self, id)
		local ts = self._timers
		ts[id] = nil
		ts._deleted = ts._deleted + 1
	end

	timer.loop = function(self)
		local ts = self._timers
		if ts._deleted >= ts._count then return end

		local t
		for i = 1, ts._count do
			t = ts[i]
			if t then
				t.milliseconds = t.milliseconds - 500
				if t.milliseconds <= 0 then
					t.milliseconds = t.defaultMilliseconds
					t.times = t.times - 1

					t.callback(tbl_unpack(t.args))

					if t.times == 0 then
						self:delete(i)
					end
				end
			end
		end
	end

	timer.refresh = function()
		timer._timers = {
			_count = 0,
			_deleted = 0
		}
	end
	timer.refresh()
end

local playerData = DataHandler.new(module.name, {
	totalCoins = {
		index = 1,
		default = 0
	},
	finishedEvent = {
		index = 2,
		default = false
	}
})

local images, consumables

local loadAllImages
loadAllImages = function(playerName, _src)
	for k, v in next, (_src or images) do
		if type(v) == "table" then
			loadAllImages(playerName, v)
		else
			tfm.exec.removeImage(tfm.exec.addImage(v, "_0", -10000, -10000, playerName))
		end
	end
end

local isEventWorkingFor = function(playerName, ignoreIsAlive)
	local cache = playerCache[playerName]
	if cache and cache.isDataLoaded and (ignoreIsAlive or cache.isAlive) then
		return cache
	end
end

do
	local giveConsumables = tfm.exec.giveConsumables
	tfm.exec.giveConsumables = function(playerName, id, quantity)
		if id == consumables.dragonPet or id == consumables.tigerPet then
			local pet = id == consumables.dragonPet and module.reward.pet.dragon
				or module.reward.pet.tiger

			for i = 1, quantity do
				system.giveEventGift(playerName, pet)
			end
		else
			return giveConsumables(playerName, id, quantity)
		end
	end
end

--[[ API ]]--
local table_random = function(t)
	return t[math_random(#t)]
end

local math_random_float = function(n, m)
	return n + math_random() * (m - n);
end

local displayLabelWithBorder = function(id, format, value, playerName, x, y, ...)
	local blackValue = format .. "<font color='#000000'>" .. value

	id = id + 1
	for xOffset = -1, 1, 2 do
		for yOffset = -1, 1, 2 do
			id = id - 1
			ui.addTextArea(id, blackValue, playerName, x + xOffset, y + yOffset, ...)
		end
	end
	ui.addTextArea(id - 1, format .. value, playerName, x, y, ...)
end

local displayClickableImage = function(id, event, x, y, w, h, playerName, isFixed)
	ui.addTextArea(id,
		"<textformat leftmargin='1' rightmargin='1'><a href='event:"
		.. event .. "'>\n\n\n\n\n\n\n\n\n\n\n\n", playerName, x - 5, y - 5, w + 5, h + 5, 1, 1, 0,
		isFixed)
end

--[[ Tables ]]--
images = {
	balloons = {
		"17ce1b4f897.png",
		"17ce1b4bc33.png"
	},
	coin = "17ce7a2dbd6.png",
	tokens = {
		coin = "17ce7a2b9af.png",
		checkpoint = "17ce1a47254.png",
		dragonPet = "17ce7f48f5c.png",
		tigerPet = "17d7930dd12.png",
	},
	cloud = "17ce2f762b9.png",
	traps = {
		staticDragon = "17d97dcec39.png",
		shooterDragon = {
			[1] = "17d97e0f67e.png",
			[2] = "17d97e19a56.png"
		},
		dragonBullet = "17d97e7fe0d.png"
	},
	downArrow = {
		[false] = "17ced95657e.png",
		[true] = "17ced967097.png"
	},
	npc = "17d34e32426.png",
	interface = {
		background = "17cf74c254b.png",
		close = "17280a523f6.png",

		unavailable = "17cf7705930.png",
		available = "17cf76a3224.png",

		coin = "17cf76c35bb.png"
	},
	rewards = {
		orb = "17d34e68596.png",
		tigerPet = "17d78b0bf5b.png",
		dragonPet = "17cf74385da.jpg"
	}
}

consumables = {
	dragonPet = 2240,
	tigerPet = 2533
}

local petsByChances = { "dragonPet", "tigerPet", "tigerPet", "tigerPet", "dragonPet" }

local checkpoints = { 1000, 2000, 3000, 4000 }

local tokens = { }
local tokenTypes = {
	checkpoint = 0,
	coin = 1,
	dragonPet = 2,
	tigerPet = 3
}

local dragonShooterState = {
	sleeping = 1,
	shooting = 2
}

local interface = {
	hud = 100,
	npc = 200,
	shop = 300,
}

local grounds = {
	checkpoint = {
		type = 14,

		width = 70,
		height = 15,

		friction = 0.3,

		miceCollision = true,
		groundCollision = false,
	},
	staticDragon = {
		type = 19,

		width = 40,
		height = 60,

		miceCollision = true,
		groundCollision = false
	},
	shooterDragon = {
		type = 19,

		width = 80,
		height = 60,

		miceCollision = true,
		groundCollision = false
	},
	shooterDragonBullet = {
		type = 19,

		width = 25,
		height = 25,

		miceCollision = true,
		groundCollision = false,

		dynamic = true,
		fixedRotation = true
	},
}

local joints = {
	shooterDragonBullet = {
		type = 1,

		axis = nil,
		forceMotor = nil,
		speedMotor = 25
	}
}

--[[ Functions ]]--
local updateCollectedCoins = function(playerName)
	ui.addTextArea(interface.hud,
		"<p align='right'><font color='#FFFFFF' size='20' face='Impact'>"
		.. str_format("%03d", playerCache[playerName].collectedCoins), playerName, 715, 370, 80,
		nil, 1, 1, 0, true)
end

local placeTokenImagesForPlayerLevel = function(playerName, cache, level)
	local tk = cache.tokens
	for k, v in next, tokens do
		if v.level == level then
			tk[k] = tfm.exec.addImage(v.image, "!0", v.x, v.y, playerName)
		end
	end
end

local placeCheckpoint = function(y, level)
	local id
	for t = 0, 800, 20 do
		id = -(y + t)

		tfm.exec.addBonus(0, t, y, id, 0, false)
		tokens[id] = {
			type = tokenTypes.checkpoint,
			image = images.tokens.checkpoint,
			x = t - 15,
			y = y - 15,
			level = level
		}
	end

	y = y - 40

	tfm.exec.addPhysicObject(y, 400, y, grounds.checkpoint)
	tfm.exec.addImage(images.cloud, "!0", 400, y, nil, nil, nil, nil, nil, 0.5, 0.6)
end

local placeTokenByLevel = function(tokenType, total, maximumY, minimumY, level)
	local idBase = minimumY
	maximumY, minimumY = maximumY / 1000, minimumY / 1000

	local id, x, y
	for c = 1, total do
		id = idBase + c

		x, y = math_random(50, 750), math_random_float(minimumY, maximumY) * 1000

		tfm.exec.addBonus(0, x, y, id, 0, false)
		tokens[id] = {
			type = tokenTypes[tokenType],
			image = images.tokens[tokenType],
			x = x - 15,
			y = y - 15,
			level = level
		}
	end
end

local placeTokens = function()
	local totalCheckpoints = #checkpoints

	local inversedLevelNumber, maximumY, minimumY
	for c = 1, totalCheckpoints do
		inversedLevelNumber = (totalCheckpoints - c + 1)
		maximumY, minimumY = checkpoints[c] - 100, checkpoints[c] - 900

		placeCheckpoint(checkpoints[c], c + 1)
		placeTokenByLevel("coin", inversedLevelNumber * 2, maximumY, minimumY, c)
		placeTokenByLevel(table_random(petsByChances), inversedLevelNumber, maximumY,
			minimumY - 100, c)
	end
	placeTokenByLevel("coin", 2, 4800, 4100, totalCheckpoints + 1)
end

local placeStaticDragons = function(total)
	local id, x, y
	for d = 1, total do
		id = -(100 + d)

		x, y = math_random_float(100 / 1000, 700 / 1000) * 1000,
			math_random_float(400 / 1000, 4500 / 1000) * 1000

		tfm.exec.addPhysicObject(id, x, y, grounds.staticDragon)
		tfm.exec.addImage(images.traps.staticDragon, "+" .. id, nil, nil, nil, nil, nil, nil, nil,
			0.5, 0.5)
	end
end

local changeDragonShooterState = function(dragon, stateId)
	if dragon.image then
		tfm.exec.removeImage(dragon.image)
	end

	dragon.image = tfm.exec.addImage(images.traps.shooterDragon[stateId], "+" .. dragon.id, nil,
		nil, nil, 1 * dragon.isFacingRight, nil, nil, nil, 0.5 * dragon.isFacingRight, 0.5)
end

local dragonShoot = function(dragon)
	changeDragonShooterState(dragon, dragonShooterState.shooting)
	timer:start(changeDragonShooterState, 1000, 1, dragon, dragonShooterState.sleeping)

	tfm.exec.addPhysicObject(dragon.bulletId, dragon.x + (dragon.isFacingRight * 100),
		dragon.y + 20, grounds.shooterDragonBullet)

	local joint = joints.shooterDragonBullet
	joint.axis = dragon.isFacingRight .. ",0"
	joint.forceMotor = 9999 * dragon.isFacingRight

	tfm.exec.addJoint(dragon.bulletId, 1, dragon.bulletId, joint)
	tfm.exec.addImage(images.traps.dragonBullet, "+" .. dragon.bulletId, nil, nil, nil,
		1 * dragon.isFacingRight, nil, nil, nil, 0.6 * dragon.isFacingRight, 0.5)
end

local placeShooterDragons = function(total)
	local id, x, y, isFacingRight, dragon
	for d = 1, total * 2, 2 do
		id = -(300 + d)

		isFacingRight = math_random(1, 2) == 1
		x = isFacingRight and 25 or 785

		y = math_random_float(400 / 1000, 4000 / 1000) * 1000

		dragon = {
			id = id,
			bulletId = id + 1,
			x = x,
			y = y,
			isFacingRight = isFacingRight and 1 or -1,
			image = nil
		}

		tfm.exec.addPhysicObject(id, x, y, grounds.shooterDragon)
		changeDragonShooterState(dragon, dragonShooterState.sleeping)

		timer:start(dragonShoot, math_random(5, 12) * 500, 0, dragon)
	end
end

local displayDownArrow
do
	local image
	displayDownArrow = function(timer)
		if image then
			tfm.exec.removeImage(image)
		end
		if timer.times == 0 then return end

		image = tfm.exec.addImage(images.downArrow[timer.times % 2 == 0], "&0", 400, 80, nil, nil,
			nil, nil, nil, 0.5, 0.5)
	end
end

local displayNPC = function()
	ui.addTextArea(interface.npc,
		"<p align='center'><font face='Verdana' size='13' color='#E1FF0A'><B>Nala", nil, 210, 4890,
		80, 18, 1, 1, .1, false)

	tfm.exec.addImage(images.npc, "!1", 240, 4925, nil, nil, nil, nil, nil, 0.5, 0.5)
	displayClickableImage(interface.npc + 1, "open", 210, 4890, 80, 70, nil, false)
end

local shopCallbacks = { }
shopCallbacks["orb"] = function(playerName, cache, item)
	system.giveEventGift(playerName, module.reward.orb)
	playerData:set(playerName, "finishedEvent", true)

	tbl_remove(cache.shopItems, 1)

	tfm.exec.chatMessage(translation.credits, playerName)

	return true
end

shopCallbacks["tigerPet"] = function(playerName, cache, item)
	tfm.exec.giveConsumables(playerName, consumables[item.callback], item.quantity)
end
shopCallbacks["dragonPet"] = shopCallbacks["tigerPet"]

local shop = { }
shop["open"] = function(playerName, cache)
	if cache.interface[1] then return end

	local imageId = 1
	cache.interface[imageId] = tfm.exec.addImage(images.interface.background, ":100", 400, 265,
		playerName, nil, nil, nil, nil, 0.5, 0.5)

	imageId = imageId + 1
	cache.interface[imageId] = tfm.exec.addImage(images.interface.close, ":100", 538, 110,
		playerName)

	local textAreaId = interface.shop
	displayClickableImage(textAreaId, "close", 538, 110, 30, 30, playerName, true)

	local item, y, canBuy
	for i = 1, #cache.shopItems do
		item = cache.shopItems[i]

		y = 115 + (i * 60)

		imageId = imageId + 3

		canBuy = cache.collectedCoins >= item.price
		cache.interface[imageId - 0] = tfm.exec.addImage(
			(canBuy and images.interface.available or images.interface.unavailable),
			":101", 401, y, playerName, nil, nil, nil, 0.9, 0.5, 0.5)
		cache.interface[imageId - 1] = tfm.exec.addImage(images.rewards[item.callback], ":101",
			401, y, playerName, nil, nil, nil, nil, 0.5, 0.5)
		cache.interface[imageId - 2] = tfm.exec.addImage(images.interface.coin, ":101", 516, y,
			playerName, nil, nil, nil, nil, 0.5, 0.5)

		textAreaId = textAreaId + 5
		displayLabelWithBorder(textAreaId,
			"<font size='10' color='#FFFFFF' face='Verdana'><p align='right'><B>",
			item.price, playerName, 512, y + 6, 25, nil, nil, nil, 0, true)

		if item.quantity then
			textAreaId = textAreaId + 5
			displayLabelWithBorder(textAreaId,
				"<font size='10' color='#FFFFFF' face='Verdana'><p align='right'><B>",
				item.quantity, playerName, 397, y + 6, 25, nil, nil, nil, 0, true)
		end

		if canBuy then
			textAreaId = textAreaId + 1
			displayClickableImage(textAreaId, "buy_" .. i, 261, y - 25, 284, 50,
				playerName, true)
		end
	end
end

shop["close"] = function(playerName, cache)
	for i = #cache.interface, 1, -1 do
		tfm.exec.removeImage(cache.interface[i])
		cache.interface[i] = nil
	end

	for i = interface.shop + (16 * 3), interface.shop, -1 do
		ui.removeTextArea(i, playerName)
	end
end

shop["reopen"] = function(playerName, cache)
	shop["close"](playerName, cache)
	shop["open"](playerName, cache)
end

shop["buy"] = function(playerName, cache, parameter)
	if not parameter then return end

	local item = cache.shopItems[parameter]
	if not item or not shopCallbacks[item.callback] then return end

	if cache.collectedCoins < item.price then return end
	cache.collectedCoins = cache.collectedCoins - item.price
	playerData:set(playerName, "totalCoins", cache.collectedCoins)
	updateCollectedCoins(playerName)

	local forceReopen = shopCallbacks[item.callback](playerName, cache, item)
	playerData:save(playerName)

	if forceReopen or cache.collectedCoins < 15 then
		shop["reopen"](playerName, cache)
	end
end

--[[ Events ]]--
local hasLoaded = false
eventNewGame = function()
	if hasLoaded then
		return system.exit()
	end
	hasLoaded = true

	loadAllImages()
	placeTokens()
	placeStaticDragons(module.totalStaticDragons)
	placeShooterDragons(module.totalShooterDragons)

	tfm.exec.setGameTime(module.time)
	ui.setMapName(module.formalName)

	for playerName in next, tfm.get.room.playerList do
		playerCache[playerName] = {
			isDataLoaded = false,
			isAlive = true,

			attachedBalloon = nil,

			currentLevel = 666,
			collectedCoins = 0,

			totalDeaths = 0,

			interface = { },
			tokens = { },

			shopItems = {
				[1] = {
					callback = "orb",
					price = module.totalCoinsForReward
				},
				[2] = {
					callback = "tigerPet",
					price = module.totalPointsForPet,
					quantity = 3
				},
				[3] = {
					callback = "dragonPet",
					price = module.totalPointsForPet - 2,
					quantity = 5
				}
			}
		}

		system.loadPlayerData(playerName)
	end
	tfm.exec.addImage(module.map.background, "?0", 0, 0)

	timer:start(displayDownArrow, 1000, 11)

	displayNPC()
end

eventPlayerDataLoaded = function(playerName, data)
	playerData:newPlayer(playerName, data)

	system.bindKeyboard(playerName, 3, true, true)

	local cache = playerCache[playerName]
	placeTokenImagesForPlayerLevel(playerName, cache, #checkpoints + 1)

	cache.collectedCoins = playerData:get(playerName, "totalCoins")
	if playerData:get(playerName, "finishedEvent") then
		tbl_remove(cache.shopItems, 1)
	end

	tfm.exec.addImage(images.coin, "&100", 730, 372, playerName)
	updateCollectedCoins(playerName)

	cache.isDataLoaded = true
end

eventKeyboard = function(playerName)
	local cache = isEventWorkingFor(playerName)
	if not cache then return end

	if cache.attachedBalloon then
		tfm.exec.removeObject(cache.attachedBalloon)
	end
	cache.attachedBalloon = tfm.exec.attachBalloon(playerName, true, nil, nil,
		math_random_float(2.5, 4))
	tfm.exec.addImage(table_random(images.balloons), "#" .. cache.attachedBalloon, nil, nil, nil,
		nil, nil, nil, nil, 0.5, 0.5)
end

eventPlayerBonusGrabbed = function(playerName, id)
	local cache = isEventWorkingFor(playerName)
	if not cache then return end

	local token = tokens[id]
	tfm.exec.removeImage(cache.tokens[id])

	if token.type == tokenTypes.checkpoint then
		id = math_floor(-id / 1000)
		if id < cache.currentLevel then
			cache.currentLevel = id
			placeTokenImagesForPlayerLevel(playerName, cache, id)
		end
	elseif token.type == tokenTypes.coin then
		cache.collectedCoins = cache.collectedCoins + 1
		playerData:set(playerName, "totalCoins", cache.collectedCoins)
		updateCollectedCoins(playerName)
	elseif token.type == tokenTypes.dragonPet or token.type == tokenTypes.tigerPet then
		tfm.exec.giveConsumables(playerName,
			token.type == tokenTypes.dragonPet and consumables.dragonPet or consumables.tigerPet, 1)
	end
end

eventPlayerDied = function(playerName)
	local cache = isEventWorkingFor(playerName, true)
	if not cache then return end

	if cache.totalDeaths >= module.maxDeaths then
		cache.isAlive = false
		return
	end
	cache.totalDeaths = cache.totalDeaths + 1

	tfm.exec.respawnPlayer(playerName)
	if cache.currentLevel ~= 666 then
		tfm.exec.movePlayer(playerName, 400, checkpoints[cache.currentLevel] - 80)
	end
end

local hasTriggeredRoundEnd, triggerRoundEnd = false, false
local eventRoundEnded = function()
	hasTriggeredRoundEnd = true

	for playerName in next, playerCache do
		eventPlayerLeft(playerName)
	end
end

eventLoop = function(currentTime, remainingTime)
	if (remainingTime < 500 and currentTime > 5000) or triggerRoundEnd then
		if not hasTriggeredRoundEnd then
			return eventRoundEnded()
		end
	end

	timer:loop()
end

eventTextAreaCallback = function(id, playerName, callback)
	local cache = isEventWorkingFor(playerName)
	if not cache then return end

	local cbk, param = str_match(callback, "^(.-)_(.-)$")
	cbk = cbk or callback

	if shop[cbk] then
		shop[cbk](playerName, cache, tonumber(param) or param)
	end
end

eventNewPlayer = function(playerName)
	loadAllImages(playerName)
	tfm.exec.addImage(module.map.background, "?0", 0, 0, playerName)
end

eventPlayerLeft = function(playerName)
	local cache = isEventWorkingFor(playerName, true)
	if not cache then return end
	cache.isAlive = false

	playerData
		:set(playerName, "totalCoins", cache.collectedCoins)
		:save(playerName)
end

--[[ Init ]]--
tfm.exec.disableAfkDeath()
tfm.exec.disableAutoShaman()
tfm.exec.disableAutoNewGame()
tfm.exec.disableAutoTimeLeft()
tfm.exec.disableDebugCommand()
tfm.exec.disableMortCommand()
tfm.exec.disablePhysicalConsumables()

timer:start(function(timer)
	if not next(playerCache) then return end

	for _, p in next, playerCache do
		if p.isAlive then
			return
		end
	end

	timer.times = 0
	triggerRoundEnd = true
end, 2000, 0)

tfm.exec.newGame(module.map.xml)
