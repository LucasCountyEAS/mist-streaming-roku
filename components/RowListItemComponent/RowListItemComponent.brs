' Copyright (c) 2020 Roku, Inc. All rights reserved.

sub Init()
    poster = m.top.FindNode("poster")
    poster.ObserveField("loadStatus", "OnPosterLoadStatusChange")
end sub

sub OnContentSet()
    content = m.top.itemContent
    ' set poster uri if content is valid
    if content <> invalid 
        m.top.FindNode("poster").uri = content.icon
    end if
end sub

sub OnPosterLoadStatusChange()
    poster = m.top.FindNode("poster")
    if poster.loadStatus = "failed"
        poster.uri = "https://live.mistwx.com/logos/streaming_fallbackicon.png"
    end if
end sub