' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Channel entry point

sub Main(args as Dynamic) as Void
    ShowChannelRSGScreen(args)
end sub

sub ShowChannelRSGScreen(args as Dynamic)
    ' The roSGScreen object is a SceneGraph canvas that displays the contents of a Scene node instance
    screen = CreateObject("roSGScreen")
    ' message port is the place where events are sent
    m.port = CreateObject("roMessagePort")
    ' sets the message port which will be used for events from the screen
    screen.SetMessagePort(m.port)

    ' roInput object is required to receive roInputEvent (deep-link/ECP) events
    input = CreateObject("roInput")
    input.SetMessagePort(m.port)

    ' every screen object must have a Scene node, or a node that derives from the Scene node
    scene = screen.CreateScene("MainScene")
    scene.signalBeacon("AppLaunchComplete")

    ' handle deep-link / input launch parameters (required for supports_input_launch)
    if args <> invalid
        if args.contentId <> invalid or args.mediaType <> invalid
            scene.launchArgs = args
        end if
    end if

    screen.Show() ' Init method in MainScene.brs is invoked

    ' event loop
    while(true)
        ' waiting for events from screen
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        else if msgType = "roInputEvent"
            ' handle deep-link events that arrive while the app is already running
            if msg.IsInput()
                info = msg.GetInfo()
                if info <> invalid and info.contentId <> invalid
                    scene.launchArgs = info
                end if
            end if
        end if
    end while
end sub