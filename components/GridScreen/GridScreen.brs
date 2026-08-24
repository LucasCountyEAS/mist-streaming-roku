' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

sub Init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    m.thumbnailImage = m.top.FindNode("thumbnailimage")
    m.top.ObserveField("visible", "OnVisibleChange")
    m.rowList.ObserveField("rowItemFocused", "OnItemFocused")
    m.thumbnailImage.ObserveField("loadStatus", "OnThumbnailLoadStatusChange")

    ' pain in the ass font
    titleFont = CreateObject("roSGNode", "Font")
    titleFont.uri = "pkg:/fonts/Geist-Bold.ttf"
    titleFont.size = 28

    viewershipFont = CreateObject("roSGNode", "Font")
    viewershipFont.uri = "pkg:/fonts/Geist-Bold.ttf"
    viewershipFont.size = 20

    descriptionFont = CreateObject("roSGNode", "Font")
    descriptionFont.uri = "pkg:/fonts/Geist-Regular.ttf"
    descriptionFont.size = 20

    m.titleLabel = CreateObject("roSGNode", "Label")
    m.titleLabel.translation = [810, 340]
    m.titleLabel.width = 360
    m.titleLabel.color = "0xFFFFFFFF"
    m.titleLabel.font = titleFont
    m.top.AppendChild(m.titleLabel)

    m.viewershipLabel = CreateObject("roSGNode", "Label")
    m.viewershipLabel.translation = [810, 380]
    m.viewershipLabel.width = 360
    m.viewershipLabel.color = "0xFFFFFFFF"
    m.viewershipLabel.font = viewershipFont
    m.top.AppendChild(m.viewershipLabel)

    m.descriptionLabel = CreateObject("roSGNode", "Label")
    m.descriptionLabel.translation = [810, 420]
    m.descriptionLabel.width = 360
    m.descriptionLabel.wrap = true
    m.descriptionLabel.numLines = 8
    m.descriptionLabel.color = "0xFFFFFFFF"
    m.descriptionLabel.font = descriptionFont
    m.top.AppendChild(m.descriptionLabel)
end sub

sub OnThumbnailLoadStatusChange()
    if m.thumbnailImage.loadStatus = "failed"
        m.thumbnailImage.uri = "https://live.mistwx.com/logos/streaming_fallbackicon.png"
    end if
end sub

sub OnVisibleChange()
    if m.top.visible = true
        m.rowList.SetFocus(true)
    end if
end sub

sub OnItemFocused()
    focusedIndex = m.rowList.rowItemFocused
    row = m.rowList.content.GetChild(focusedIndex[0])
    item = row.GetChild(focusedIndex[1])

    m.descriptionLabel.text = item.description
    m.titleLabel.text = item.title

    if item.viewership <> invalid
        if item.viewership = 1
            m.viewershipLabel.text = item.viewership.ToStr() + " viewer"
        else
            m.viewershipLabel.text = item.viewership.ToStr() + " viewers"
        end if
    else
        m.viewershipLabel.text = ""
    end if

    if item <> invalid 
        m.thumbnailImage.uri = item.hdPosterUrl
    end if
end sub

function GetTime(length as Integer) as String
    minutes = (length \ 60).ToStr()
    seconds = length MOD 60
    if seconds < 10
       seconds = "0" + seconds.ToStr()
    else
       seconds = seconds.ToStr()
    end if
    return minutes + ":" + seconds
end function