---------- ��������� � ���������� ---------->>
    local imgui = require 'imgui'
    local inicfg = require 'inicfg'
    local key = require 'vkeys'
    local vkeys = require 'vkeys'
    local sampev = require 'lib.samp.events'
    local encoding = require "encoding" 
    require 'lib.sampfuncs'
    require 'lib.moonloader'
    encoding.default = 'CP1251'
    u8 = encoding.UTF8
    script_name('Support Tools')
    script_version('03.08.2021')
    
----------- ���������� ------->>

    local main_window_state = imgui.ImBool(false)
    local question = imgui.ImBool(false)
    local lovim_ans = false
    local fileGPS = 'moonloader/config/gps.txt'
    local fileGPS1 = io.open('moonloader/config/gps.txt')
    local all = {
        vazhnoe = {},
        raboti = {},
        gosski = {},
        nelegal = {},
        avto = {},
        prochee = {},
        poisk = {}
    }
    local cfg = inicfg.load(all, 'GPS.ini')
    local dialog_now = 0

----------- ����� ------------>>
   
    function imgui.OnDrawFrame()
        if not question.v then
            imgui.Process = false
        end
        local entered_text = sampGetCurrentDialogEditboxText()
        if question.v then
            local so, sp = getScreenResolution()
            imgui.Process = question.v
            imgui.SetNextWindowPos(imgui.ImVec2(so / 1.3, sp / 7), imgui.Cond.Once)
            imgui.SetNextWindowSize(imgui.ImVec2(300, 600))
            imgui.Begin(u8'STools by Dexter_Martelli', question)
            if imgui.CollapsingHeader(u8'�����������') then
                if imgui.Button(u8'������������', imgui.ImVec2(130, 25)) then
                    sampSetCurrentDialogEditboxText(entered_text .. '������������, ')
                end
                imgui.SameLine()
                if imgui.Button(u8'������� ������� �����', imgui.ImVec2(130, 25)) then
                    sampSetCurrentDialogEditboxText(entered_text .. '������� ������� �����, ')
                end
                if imgui.Button(u8'������ ����', imgui.ImVec2(130, 25)) then
                    sampSetCurrentDialogEditboxText(entered_text .. '������ ����,')
                end
                imgui.SameLine()
                if imgui.Button(u8'������ ����', imgui.ImVec2(130, 25)) then
                    sampSetCurrentDialogEditboxText(entered_text .. '������ ����,')
                end
                if imgui.Button(u8'������ �����', imgui.ImVec2(130, 25)) then
                    sampSetCurrentDialogEditboxText(entered_text .. '������ �����, ')
                end
                imgui.SameLine()
                if imgui.Button(u8'������ ����', imgui.ImVec2(130, 25)) then
                    sampSetCurrentDialogEditboxText(entered_text .. '������ ����,')
                end
            end
            if imgui.CollapsingHeader(u8'GPS') then
                imgui.BeginChild('##GPS', imgui.ImVec2(285, 370), true)
                if imgui.CollapsingHeader(u8'������') then
                    for i=1, #all.vazhnoe do
                        if imgui.Button(u8(all.vazhnoe[i]), imgui.ImVec2(260, 25)) then
                            sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 1. ������ -> ' .. all.vazhnoe[i])
                        end
                    end
                end
                if imgui.CollapsingHeader(u8'������') then
                    for i=1, #all.raboti do
                        if imgui.Button(u8(all.raboti[i]), imgui.ImVec2(280, 25)) then
                            sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 2. ������ -> ' .. all.raboti[i])
                        end
                    end
                end
                if imgui.CollapsingHeader(u8'���. ���') then
                    for i=1, #all.gosski do
                        if imgui.Button(u8(all.gosski[i]), imgui.ImVec2(280, 25)) then
                            sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 3. ���. ��� -> ' .. all.gosski[i])
                        end
                    end
                end
                if imgui.CollapsingHeader(u8'�����. ���') then
                    for i=1, #all.nelegal do
                        if imgui.Button(u8(all.nelegal[i]), imgui.ImVec2(280, 25)) then
                            sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 4. �������. ��� -> ' .. all.nelegal[i])
                        end
                    end
                end
                if imgui.CollapsingHeader(u8'�����������') then
                    for i=1, #all.avto do
                        if imgui.Button(u8(all.avto[i]), imgui.ImVec2(280, 25)) then
                            sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 5. ���������� -> ' .. all.avto[i])
                        end
                    end
                end
                if imgui.CollapsingHeader(u8'������') then
                    for i=1, #all.prochee do
                        if imgui.Button(u8(all.prochee[i]), imgui.ImVec2(280, 25)) then
                            sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 6. ������ -> ' .. all.prochee[i])
                        end
                    end
                end
                if imgui.CollapsingHeader(u8'�����') then
                    for i=1, #all.poisk do
                        if imgui.Button(u8(all.poisk[i]), imgui.ImVec2(280, 25)) then
                            sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 7. ����� ���� -> ' .. all.poisk[i])
                        end
                    end
                end
                imgui.EndChild()
            end
            imgui.SetCursorPosY(525)
            if imgui.Button(u8'�������� ����', imgui.ImVec2(280, 25)) then
                sampSetCurrentDialogEditboxText(entered_text .. '�������� ����!')
            end
            if imgui.Button(u8'������� ������', imgui.ImVec2(280, 25)) then
                lovim_ans = not lovim_ans
                if lovim_ans then
                info_msg('�������� ������ ������!')
                sampSendChat('/ans')
                else
                info_msg('����� ������� ����������!')
                end
            end
            imgui.End()
        end 
    end

----------- ������� ---------->>
    
    function main()
        while not isSampAvailable() do wait(50) end
        if not isSampfuncsLoaded() or not isSampLoaded() then
            return
            end
        if doesFileExist('moonloader\\config\\STools.ini') then
            inicfg.save(cfg, 'STools.ini')
        end
        sampRegisterChatCommand('update_stools', update("https://gist.githubusercontent.com/M0rtelli/44ea4b212e724f82803647bb87f257d5/raw", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/M0rtelli/STools/main/STools.lua"))
        while true do
            wait(0)

            if wasKeyPressed(46) and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() then
                question.v = not question.v
                imgui.Process = question.v
            end

            if isKeyJustPressed(VK_F3) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() then
                sampSendChat('/ans')
            end
        end

    end

---------- ���� ------------>>

    function sampev.onServerMessage(color, text)
        local _, my_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local my_nick = sampGetPlayerNickname(my_id)
        if text:match('�����!') then
            if lovim_ans and not sampIsDialogActive() then
                lua_thread.create(function()
                    wait(700)
                    sampSendChat('/ans')    
                end)
                return false
            else
            info_msg('��� �� ������ �������!')
            return false
            end
        end
        if text:match('������ ����� ���-�� �������������') then
            if lovim_ans then
                lua_thread.create(function()
                    sampSendDialogResponse(dialog_now, 0, nil, nil)
                    wait(700)
                    sampSendChat('/ans')    
                end)
                return false
            else
            info_msg('������ ������ ��� ���-�� ����!')
            return false
            end
        end
        if text:match('������ ' .. my_nick .. '%[%d+%] ������� ������') then
            if lovim_ans then
                info_msg('Debug!')
                lua_thread.create(function()
                    wait(700)
                    sampSendChat('/ans')    
                end)
            else
            end
        end
    end

    function sampev.onConnectionRequestAccepted(ip, port, playerId, challenge)
        if ip == '80.66.82.227' then
            check_upd("https://gist.githubusercontent.com/M0rtelli/44ea4b212e724f82803647bb87f257d5/raw", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/M0rtelli/STools/main/STools.lua")
            print('challe - ' .. challenge)
        else
            info_msg('�� ������������ � ' .. ip .. ':' .. port .. ', ��� �� �������� SanTrope RP 1 server. ������ ��� ��������!')
            thisScript():unload()
        end
    end

    function sampev.onShowDialog(id, style, title, button1, button2, text)
        dialog_now = id
        if title:match('������') and lovim_ans then
            local is_is = false
            local tLines = split(text, "\n")
            for k, v in ipairs(tLines) do
                if v:find("^%{......%}%[�]") then
                    local number_list = tonumber(k)
                    number_list = number_list - 1
                    sampSendDialogResponse(id, 1, number_list, nil)
                    is_is = true
                end
            end 
            if is_is == false and lovim_ans then
                lua_thread.create(function()
                    sampSendDialogResponse(id, 0, nil, nil)
                    is_is = false
                    wait(700)
                    sampSendChat('/ans')
                end)
                return false
            end 
        end
    end


--------- �������� --------->>
    function info_msg(text)
        sampAddChatMessage('{8A2BE2}[STools]:{00CED1} ' .. text)
    end

    function update(json_url, prefix, url)
        local dlstatus = require('moonloader').download_status
        local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
        if doesFileExist(json) then os.remove(json) end
        downloadUrlToFile(json_url, json,
          function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
              if doesFileExist(json) then
                local f = io.open(json, 'r')
                if f then
                  local info = decodeJson(f:read('*a'))
                  updatelink = info.updateurl
                  updateversion = info.latest
                  f:close()
                  os.remove(json)
                  if updateversion ~= thisScript().version then
                    lua_thread.create(function(prefix)
                      local dlstatus = require('moonloader').download_status
                      local color = -1
                      info_msg('������� ���������� c {4682B4}'..thisScript().version..'{00CED1} �� {4682B4}'..updateversion)
                      wait(250)
                      downloadUrlToFile(updatelink, thisScript().path,
                        function(id3, status1, p13, p23)
                          if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                            print(string.format('��������� %d �� %d.', p13, p23))
                          elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                            print('�������� ���������� ���������.')
                            info_msg('���������� ������ �������! ���������������...')
                            goupdatestatus = true
                            lua_thread.create(function() wait(500) thisScript():reload() end)
                          end
                          if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                            if goupdatestatus == nil then
                              info_msg(prefix..'���������� ������ ��������. �������� ���������� ������..')
                              update = false
                            end
                          end
                        end
                      )
                      end, prefix
                    )
                  else
                    update = false
                    info_msg('v'..thisScript().version..': ���������� �� ���������.')
                  end
                end
              else
                info_msg('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
                update = false
              end
            end
          end
        )
        while update ~= false do wait(100) end
      end

    function check_upd(json_url, prefix, url)
        local dlstatus = require('moonloader').download_status
        local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
        if doesFileExist(json) then os.remove(json) end
        downloadUrlToFile(json_url, json,
          function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
              if doesFileExist(json) then
                local f = io.open(json, 'r')
                if f then
                  local info = decodeJson(f:read('*a'))
                  updatelink = info.updateurl
                  updateversion = info.latest
                  f:close()
                  os.remove(json)
                  if updateversion ~= thisScript().version then
                    lua_thread.create(function()
                      local color = -1
                      info_msg('���������� ����������! �������� ������ ����� �������� /update_stools')
                      end
                    )
                  else
                    update = false
                    info_msg('v'..thisScript().version..': ���������� �� ���������.')
                  end
                end
              else
                info_msg('v'..thisScript().version..': �� ���� ��������� ����������. ���������, ����� ����!')
                update = false
              end
            end
          end
        )
        while update ~= false do wait(100) end
      end

    function split(str, delim, plain)
        local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
        repeat
            local npos, epos = string.find(str, delim, pos, plain)
            table.insert(tokens, string.sub(str, pos, npos and npos - 1))
            pos = epos and epos + 1
        until not pos
        return tokens
      end