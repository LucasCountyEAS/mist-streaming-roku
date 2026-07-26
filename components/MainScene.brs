' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' entry point of  MainScene
' Note that we need to import this file in MainScene.xml using relative path.
sub Init()
    m.top.backgroundColor = "0x662D91"
    m.top.backgroundUri= "pkg:/images/background.jpg"
    m.loadingIndicator = m.top.FindNode("loadingIndicator")

    ' pick the right overhang logo based on actual display resolution
    overhang = m.top.FindNode("overhang")
    di = CreateObject("roDeviceInfo")
    uiResolution = di.GetUIResolution()
    if uiResolution.name = "FHD"
        overhang.logoUri = "pkg:/images/fhd_overhang_logo.png"
    end if

    InitScreenStack()
    ShowGridScreen()
    RunContentTask()

    if m.top.launchArgs <> invalid
        OnLaunchArgsChanged()
    end if
end sub

' invoked when the app is launched or already-running and receives deep link parameters
sub OnLaunchArgsChanged()
    args = m.top.launchArgs
    if args = invalid or args.contentId = invalid then return

    if m.GridScreen = invalid or m.GridScreen.content = invalid
        ' content hasn't loaded yet — try again once it does
        return
    end if

    LaunchContentById(args.contentId)
end sub

' searches the loaded grid content for a channel matching the given id and plays it
sub LaunchContentById(contentId as String)
    row = m.GridScreen.content.GetChild(0) ' single row containing all channels
    if row = invalid then return

    for i = 0 to row.GetChildCount() - 1
        item = row.GetChild(i)
        if item.id = contentId
            ShowVideoScreen(row, i)
            return
        end if
    end for
end sub

' The OnKeyEvent() function receives remote control key events
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        ' handle "back" key press
        if key = "back"
            numberOfScreens = m.screenStack.Count()
            ' close top screen if there are two or more screens in the screen stack
            if numberOfScreens > 1
                CloseScreen(invalid)
                result = true
            end if
        end if
    end if
    ' The OnKeyEvent() function must return true if the component handled the event,
    ' or false if it did not handle the event.
    return result
end function