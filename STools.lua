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
    script_version('1.0')
    
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

    function split(str, delim, plain)
        local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
        repeat
            local npos, epos = string.find(str, delim, pos, plain)
            table.insert(tokens, string.sub(str, pos, npos and npos - 1))
            pos = epos and epos + 1
        until not pos
        return tokens
      end