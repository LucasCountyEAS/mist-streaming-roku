' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

' invoked from the grid: plays the selected item of the given row
sub ShowVideoScreen(content as Object, itemIndex as Integer)
    if content = invalid then return
    selectedItem = content.GetChild(itemIndex)
    if selectedItem = invalid or selectedItem.url = invalid then return
    PlayStream(selectedItem.url)
end sub

' shared by the grid and deep links
sub PlayStream(url as String)
    if m.videoPlayer <> invalid and m.screenStack.Peek() <> invalid
        if m.screenStack.Peek().IsSameNode(m.videoPlayer) then CloseScreen(m.videoPlayer)
    end if

    m.videoPlayer = CreateObject("roSGNode", "Video")

    node = CreateObject("roSGNode", "ContentNode")
    node.url = url
    node.streamFormat = "hls"
    node.live = true
    m.videoPlayer.content = node
    m.videoPlayer.contentIsPlaylist = false

    ShowScreen(m.videoPlayer)
    m.videoPlayer.control = "play"
    m.videoPlayer.ObserveField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.ObserveField("visible", "OnVideoVisibleChange")

    ' memory check timer every 15 minutes (created once)
    if m.memTimer = invalid
        m.memTimer = CreateObject("roSGNode", "Timer")
        m.memTimer.duration = 900
        m.memTimer.repeat = true
        m.memTimer.ObserveField("fire", "OnMemCheck")
        m.memTimer.control = "start"
    end if
end sub

sub OnMemCheck()
    now = CreateObject("roDateTime")
    timestamp = now.GetHours().ToStr() + ":" + now.GetMinutes().ToStr() + ":" + now.GetSeconds().ToStr()
    memLevel = CreateObject("roDeviceInfo").GetGeneralMemoryLevel()
    state = "n/a"
    if m.videoPlayer <> invalid then state = m.videoPlayer.state
    print "[MEMCHECK "; timestamp; "] Memory level: "; memLevel; " | Video state: "; state
end sub

sub OnVideoPlayerStateChange()
    if m.videoPlayer = invalid then return
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
    if m.videoPlayer = invalid then return
    if m.videoPlayer.visible = false and m.top.visible = true
        m.videoPlayer.control = "stop"
        m.videoPlayer.content = invalid
        m.GridScreen.SetFocus(true)
        m.lastDeepLinkId = invalid
    end if
end sub
