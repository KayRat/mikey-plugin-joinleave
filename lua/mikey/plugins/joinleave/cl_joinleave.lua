hook.Add("ChatText", "mikey.plugins.joinleave", function(iIndex, strNick, strText, strType)
  if(strType == "joinleave") then return true end
end)

mikey.network.receive("joinleave.join", function(tblData)
  local strNick     = tblData["nick"]
  local strSteamID  = tblData["steamid"]
  local bIsBot      = tblData["bot"]
  local iUserID     = tblData["userid"]

  local tblMessage = {}

  if(bIsBot) then
    tblMessage = {
      mikey.colors.alt,     "→ ",
      color_white,          "A silly bot named ",
      mikey.colors.alt,    strNick,
      color_white,          " has joined",
    }
  else
    tblMessage = {
      mikey.colors.alt,       "→ ",
      mikey.colors.primary,   strNick,
      color_white,            " has",
      mikey.colors.alt,       " connected",
    }
  end

  chat.AddText(unpack(tblMessage))
end)


local tblTranslate = {
  ["Disconnect by user."] = "left the game",
  ["%s timed out"]        = "timed out",
  ["Connection closing"]  = "lost connection",
  ["Map is missing"]      = {"was booted:", "missing map"},
}

local function tryTranslation(strNick, strReason)
  if(tblTranslate[strReason]) then
    return "has", tblTranslate[strReason]
  end

  for k,v in pairs(tblTranslate) do
    if(string.format(k, strNick) == strReason) then
      if(type(v) == "table") then
        return v[1], v[2]
      end

      return "has", v
    end
  end

  return "has", "disconnected: "..strReason
end

mikey.network.receive("joinleave.leave", function(tblData)
  local strNick     = tblData["nick"]
  local strSteamID  = tblData["steamid"]
  local bIsBot      = tblData["bot"]
  local iUserID     = tblData["userid"]

  local tblMessage = {}

  local strPrefix, strReason = tryTranslation(strNick, tblData["reason"])

  tblMessage = {
    mikey.colors.secondary, "← ",
    mikey.colors.primary,   strNick,
    color_white,            " "..strPrefix.." ",
    mikey.colors.secondary,  strReason,
  }

  chat.AddText(unpack(tblMessage))
end)

mikey.network.receive("joinleave.firstjoin", function(tblData)
  local strNick     = tblData["nick"]
  local strSteamID  = tblData["steam"]

  chat.AddText(
    mikey.colors.alt,       "! ",
    mikey.colors.primary,   strNick,
    color_white,            " has joined ",
    mikey.colors.alt,       "for the first time",
    color_white,            "!"
  )
end)
