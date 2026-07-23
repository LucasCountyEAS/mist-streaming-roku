' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    ' request the content feed from the API
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://partners.weatherscan.net/api/channels")
    rsp = xfer.GetToString()
    rootChildren = []
    rows = {}

    ' parse the feed and build a tree of ContentNodes to populate the GridView
    json = ParseJson(rsp)
    if json <> invalid
        row = {}
        row.title = "Channels"
        row.children = []
        for each item in json ' parse items and push them to row
            itemData = GetItemData(item)
            row.children.Push(itemData)
        end for
        rootChildren.Push(row)
        ' set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        ' populate content field with root content node.
        ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
        m.top.content = contentNode
    end if
end sub

function GetItemData(video as Object) as Object
    item = {}
    ' populate some standard content metadata fields to be displayed on the GridScreen
    ' https://developer.roku.com/docs/developer-program/getting-started/architecture/content-metadata.md
    item.description = video.title
    item.hdPosterURL = "https://cdn-preview2.weatherscan.net/snapshot_" + video.id + ".jpg"
    item.icon = "https://live.mistweather.com/channels/logos/" + video.id + ".jpg"
    item.title = video.id
    item.releaseDate = 0
    item.id = video.id
    if video.content <> invalid
        ' populate length of content to be displayed on the GridScreen
        item.length = 100
        ' populate meta-data for playback
        item.url = "https://streaming.weatherscan.net/hls/" + video.id + "/index.m3u8"
        item.streamFormat = "m3u8"
    end if
    return item
end function
