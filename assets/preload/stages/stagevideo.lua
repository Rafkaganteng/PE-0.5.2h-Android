--[[
	Made By BBPanzu
	Improved By Cherry

	How To Use:
		Put script in scripts folder
		if you want to use it on a certain script add a local or global variable called video sprite which equals
		dofile("mods/scripts/videoSprite.lua")
		to make the sprite do 
			variable("tag", "path", x, y)
]]--

local videoSprites = {}
function makeVideoSprite(tag, videoPath, x, y)
	makeLuaSprite(tag, '', x, y)
	addLuaSprite(tag)

	addHaxeLibrary('MP4Handler', 'vlc')
	addHaxeLibrary('Event', 'openfl.events')
	runHaxeCode(
		'setVar("'..tag..'", new MP4Handler());\n'.. 
		-- create the video and also set the global variable 
		'getVar("'..tag..'").playVideo(Paths.video("'..videoPath..'"));\n'.. 
		-- play the video file 
		'getVar("'..tag..'").visible = false;\n'.. 
		-- make the video object overlay invisible
		'FlxG.stage.removeEventListener("enterFrame", getVar("'..tag..'").update);'
		-- removes the native update event the video has (disables skipping pressing enter)
	)
	table.insert(videoSprites, tag)
end

function onUpdatePost()
	for _, __ in pairs(videoSprites) do
		runHaxeCode(
			'game.getLuaObject("'..__..'").loadGraphic(getVar("'..__..'").bitmapData);\n'.. 
			-- set video sprite's graphic as the video's bitmap data
			'getVar("'..__..'").volume = FlxG.sound.volume + 0.4;\n'..
			-- set video volume as the game's volume (plus 0.4 idk psych has that for some reason)
			'if (game.paused)\n	getVar("'..__..'").pause;'
			-- pause video if the game is paused
		)
	end
end
function onResume()
	for _, __ in pairs(videoSprites) do
		runHaxeCode(
			'getVar("'..__..'").resume();'
			-- resume video when game is resumed
		)
	end
end
function onCreatePost()
    setProperty('boyfriend.visible', false)
    setProperty('gf.visible', false)
    setProperty('dad.visible', false)
    setProperty('healthBar.visible')
    setProperty('healthBarBG.visible')
    setProperty('iconP1.visible')
    setProperty('iconP2.visible')
end
function onSongStart()
    makeVideoSprite('stagevideo', 'stagevideo', 0, 0)
    setScrollFactor('stagevideo', 0, 0)
    scaleObject('stagevideo', 1.2, 1.2)
end

return makeVideoSprite