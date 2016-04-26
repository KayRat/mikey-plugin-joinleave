gameevent.Listen("player_connect")
gameevent.Listen("player_disconnect")

hook.Add("player_connect", "mikey.plugins.joinleave", function(tblData)
  local strNick     = tblData["name"]
  local strSteamID  = tblData["networkid"]
  local strIP       = tblData["address"]
  local iUserID     = tblData["userid"]
  local bIsBot      = tobool(tblData["bot"])
  local iEntIndex   = tblData["index"]

  mikey.network.send("joinleave.join", player.GetAll(), {
    ["nick"]    = strNick,
    ["steamid"] = strSteamID,
    ["bot"]     = bIsBot,
    ["userid"]  = iUserID,
  })
end)

hook.Add("player_disconnect", "mikey.plugins.joinleave", function(tblData)
  local strNick     = tblData["name"]
  local strSteamID  = tblData["networkid"]
  local iUserID     = tblData["userid"]
  local bIsBot      = tobool(tblData["bot"])
  local strReason   = tblData["reason"]

  if(string.sub(strReason, 1, 6) == "Kicked") then return end

  local objPl = Player(iUserID)

  mikey.network.send("joinleave.leave", player.GetAll(), {
    ["nick"]    = strNick,
    ["steamid"] = strSteamID,
    ["bot"]     = bIsBot,
    ["userid"]  = iUserID,
    ["reason"]  = strReason,
  })
end)
