' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowVideoScreen(content as Object, itemIndex as Integer)
    m.videoPlayer = CreateObject("roSGNode", "Video")

    selectedItem = content.GetChild(itemIndex)

    node = CreateObject("roSGNode", "ContentNode")
    node.url = selectedItem.url
    node.streamFormat = "hls"
    m.videoPlayer.content = node
    m.videoPlayer.contentIsPlaylist = false

    ShowScreen(m.videoPlayer)
    m.videoPlayer.control = "play"
    m.videoPlayer.ObserveField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.ObserveField("visible", "OnVideoVisibleChange")

    ' memory check timer every 15 minutes
    m.memTimer = CreateObject("roSGNode", "Timer")
    m.memTimer.duration = 900
    m.memTimer.repeat = true
    m.memTimer.ObserveField("fire", "OnMemCheck")
    m.memTimer.control = "start"
end sub

sub OnMemCheck()
    now = CreateObject("roDateTime")
    timestamp = now.GetHours().ToStr() + ":" + now.GetMinutes().ToStr() + ":" + now.GetSeconds().ToStr()
    memLevel = CreateObject("roDeviceInfo").GetGeneralMemoryLevel()
    print "[MEMCHECK "; timestamp; "] Memory level: "; memLevel; " | Video state: "; m.videoPlayer.state
end sub

sub OnVideoPlayerStateChange()
    state = m.videoPlayer.state
    memLevel = CreateObject("roDeviceInfo").GetGeneralMemoryLevel()
    print "Video state changed to: "; state; " | Memory level: "; memLevel
    if state = "error"
        print "Video error code: "; m.videoPlayer.errorCode
        print "Video error message: "; m.videoPlayer.errorMsg
    end if
    if state = "error" or state = "finished"
        CloseScreen(m.videoPlayer)
    end if
end sub

sub OnVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        m.videoPlayer.control = "stop"
        m.videoPlayer.content = invalid
        m.GridScreen.SetFocus(true)
    end if
end sub