' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    ' request the channel list from the Mist Streaming API
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.InitClientCertificates()
    xfer.SetURL("https://api.mistweather.com/api/v1.5/channels")
    rsp = xfer.GetToString()

    ' request descriptions from the public-channels endpoint
    descXfer = CreateObject("roURLTransfer")
    descXfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    descXfer.InitClientCertificates()
    descXfer.SetURL("https://api.mistweather.com/api/public-channels")
    descRsp = descXfer.GetToString()

    ' build a lookup map of channel_id -> description
    descriptions = {}
    descJson = ParseJson(descRsp)
    if descJson <> invalid
        for each entry in descJson
            if entry.channel_id <> invalid and entry.channel_description <> invalid
                descriptions[entry.channel_id] = entry.channel_description
            end if
        end for
    end if

    ' generate one cache-busting timestamp shared by all thumbnails this refresh
    timestamp = CreateObject("roDateTime")
    cacheBuster = timestamp.GetYear().ToStr() + timestamp.GetMonth().ToStr() + timestamp.GetDayOfMonth().ToStr() + timestamp.GetHours().ToStr() + timestamp.GetMinutes().ToStr() + timestamp.GetSeconds().ToStr()
    ' parse the flat channel array
    json = ParseJson(rsp)
    if json <> invalid
        items = []
        for each channel in json
            ' skip channels that are currently offline
            if channel.online = true
                items.Push(GetItemData(channel, descriptions, cacheBuster))
            end if
        end for

        ' sort items alphabetically by title
        items = SortItemsByTitle(items)

        ' single row containing every channel, sorted alphabetically
        row = {}
        row.title = "All Channels"
        row.children = items

        rootChildren = [row]

        ' set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        m.top.content = contentNode
    else
        print "ParseJson failed - response was not valid JSON"
    end if
end sub

function SortItemsByTitle(items as Object) as Object
    ' simple bubble sort by title, case-insensitive
    n = items.Count()
    for i = 0 to n - 2
        for j = 0 to n - 2 - i
            if LCase(items[j].title) > LCase(items[j + 1].title)
                temp = items[j]
                items[j] = items[j + 1]
                items[j + 1] = temp
            end if
        end for
    end for
    return items
end function

function GetItemData(channel as Object, descriptions as Object, cacheBuster as String) as Object
    item = {}
    item.title = channel.title
    item.id = channel.id
    item.viewership = channel.viewership

    ' pull the description from the lookup map, if available
    if descriptions[channel.id] <> invalid
        item.description = descriptions[channel.id]
    else
        item.description = ""
    end if

    ' auto-updating thumbnail capture with shared cache-busting timestamp
    item.hdPosterURL = "https://capture.mistlive.tv/" + channel.id + ".hq.webp?v=" + cacheBuster

    ' resolve icon UUID to an actual image URL, falling back if missing
    if channel.icon <> invalid
        item.icon = "https://api.mistweather.com/api/v1.5/image/" + channel.icon + "?width=96&height=96&fit=inside"
    else
        item.icon = "https://live.mistwx.com/logos/streaming_fallbackicon.png"
    end if

    ' resolve background UUID if present
    if channel.background <> invalid
        item.backgroundImageUrl = "https://api.mistweather.com/api/v1.5/image/" + channel.background
    end if

    ' build the HLS stream URL — playlist.m3u8 handles rendition selection automatically
    item.url = "https://watch.mistweather.com/hls/" + channel.id + "/playlist.m3u8"
    item.streamFormat = "m3u8"

    return item
end function