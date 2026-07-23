' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' entry point of GridScreen
' Note that we need to import this file in GridScreen.xml using relative path.
sub Init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    m.thumbnailImage = m.top.FindNode("thumbnailImage")
    m.top.ObserveField("visible", "OnVisibleChange")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.viewershipLabel = m.top.FindNode("viewershipLabel")
    m.rowList.ObserveField("rowItemFocused", "OnItemFocused")
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

' this method convert seconds to mm:ss format
' getTime(138) returns 2:18
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
