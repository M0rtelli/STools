---------- НАСТРОЙКИ и БИБЛИОТЕКИ ---------->>
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
script_version('05.08.2021')

----------- ПЕРЕМЕННЫЕ ------->>

local main_window_state = imgui.ImBool(false)
local question = imgui.ImBool(false)
local lovim_ans = false
local checked = true
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
local tSelBut = { "Словить репорт" }
local sWindow = tSelBut[1]
local tSelButtons = { "Основное", "Связь с разработчиком", "Информация" }
local sWindows = tSelButtons[1]

----------- ИМГУИ ------------>>

function imgui.OnDrawFrame()
    if not question.v then
        imgui.Process = false
    end
    local entered_text = sampGetCurrentDialogEditboxText()

    if question.v then
        style()
        local so, sp = getScreenResolution()
        imgui.Process = question.v
        imgui.SetNextWindowPos(imgui.ImVec2(so / 1.3, sp / 7), imgui.Cond.Once)
        imgui.SetNextWindowSize(imgui.ImVec2(300, 600))
        imgui.Begin(u8'STools by Dexter_Martelli', question)
        if imgui.CollapsingHeader(u8'Приветствия') then
            if imgui.Button(u8'Здравствуйте', imgui.ImVec2(130, 25)) then
                sampSetCurrentDialogEditboxText(entered_text .. 'Здравствуйте, ')
            end
            imgui.SameLine()
            if imgui.Button(u8'Доброго времени суток', imgui.ImVec2(130, 25)) then
                sampSetCurrentDialogEditboxText(entered_text .. 'Доброго времени суток, ')
            end
            if imgui.Button(u8'Доброе утро', imgui.ImVec2(130, 25)) then
                sampSetCurrentDialogEditboxText(entered_text .. 'Доброе утро,')
            end
            imgui.SameLine()
            if imgui.Button(u8'Добрый день', imgui.ImVec2(130, 25)) then
                sampSetCurrentDialogEditboxText(entered_text .. 'Добрый день,')
            end
            if imgui.Button(u8'Добрый вечер', imgui.ImVec2(130, 25)) then
                sampSetCurrentDialogEditboxText(entered_text .. 'Добрый вечер, ')
            end
            imgui.SameLine()
            if imgui.Button(u8'Доброй ночи', imgui.ImVec2(130, 25)) then
                sampSetCurrentDialogEditboxText(entered_text .. 'Доброй ночи,')
            end
        end
        if imgui.CollapsingHeader(u8'GPS') then
            imgui.BeginChild('##GPS', imgui.ImVec2(285, 337), true)
            if imgui.CollapsingHeader(u8'Важные') then
                for i=1, #all.vazhnoe do
                    if imgui.Button(u8(all.vazhnoe[i]), imgui.ImVec2(260, 25)) then
                        sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 1. Важное -> ' .. all.vazhnoe[i])
                    end
                end
            end
            if imgui.CollapsingHeader(u8'Работы') then
                for i=1, #all.raboti do
                    if imgui.Button(u8(all.raboti[i]), imgui.ImVec2(280, 25)) then
                        sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 2. Работа -> ' .. all.raboti[i])
                    end
                end
            end
            if imgui.CollapsingHeader(u8'Офф. орг') then
                for i=1, #all.gosski do
                    if imgui.Button(u8(all.gosski[i]), imgui.ImVec2(280, 25)) then
                        sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 3. Офф. орг -> ' .. all.gosski[i])
                    end
                end
            end
            if imgui.CollapsingHeader(u8'Неофф. орг') then
                for i=1, #all.nelegal do
                    if imgui.Button(u8(all.nelegal[i]), imgui.ImVec2(280, 25)) then
                        sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 4. Нелегал. орг -> ' .. all.nelegal[i])
                    end
                end
            end
            if imgui.CollapsingHeader(u8'Автосервисы') then
                for i=1, #all.avto do
                    if imgui.Button(u8(all.avto[i]), imgui.ImVec2(280, 25)) then
                        sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 5. Автосалоны -> ' .. all.avto[i])
                    end
                end
            end
            if imgui.CollapsingHeader(u8'Прочее') then
                for i=1, #all.prochee do
                    if imgui.Button(u8(all.prochee[i]), imgui.ImVec2(280, 25)) then
                        sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 6. Прочее -> ' .. all.prochee[i])
                    end
                end
            end
            if imgui.CollapsingHeader(u8'Поиск') then
                for i=1, #all.poisk do
                    if imgui.Button(u8(all.poisk[i]), imgui.ImVec2(280, 25)) then
                        sampSetCurrentDialogEditboxText(entered_text .. '/gps -> 7. Поиск мест -> ' .. all.poisk[i])
                    end
                end
            end
            imgui.EndChild()
        end
        
        --imgui.SetCursorPosY(500)
        if imgui.Button(u8'Расписание контейнеров', imgui.ImVec2(280, 25)) then
            sampSetCurrentDialogEditboxText(entered_text .. '16:30, 17:45, 18:30, 19:45')
        end
        if imgui.Button(u8'Приятной игры', imgui.ImVec2(280, 25)) then
            sampSetCurrentDialogEditboxText(entered_text .. 'Приятной игры!')
        end
        if not lovim_ans then
            if imgui.SelButton(lovim_ans, u8'Словить вопрос', imgui.ImVec2(255, 25)) then
                lovim_ans = not lovim_ans
                if lovim_ans then
                info_msg('Начинаем ловить репорт!')
                sampSendChat('/ans')
                else
                info_msg('Ловля репорта прекращена!')
                end
            end
        else
            if imgui.SelButton(lovim_ans, u8'Перестать ловить репорт', imgui.ImVec2(255, 25)) then
                lovim_ans = not lovim_ans
                if lovim_ans then
                info_msg('Начинаем ловить репорт!')
                sampSendChat('/ans')
                else
                info_msg('Ловля репорта прекращена!')
                end
            end
        end
        imgui.SameLine()
        hint('При ловле репорта, лучше всего стоять на месте,\nЧтобы избежать багов в скрипте и диалогах.')
        imgui.End()
    end 

    if main_window_state.v then
    style()
    local so, sp = getScreenResolution()
    imgui.Process = main_window_state.v
    imgui.SetNextWindowPos(imgui.ImVec2(so / 3.5, sp / 2.3))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 400))
    imgui.Begin(u8'STools by Dexter_Martelli', main_window_state)
    imgui.BeginChild('##menu', imgui.ImVec2(175, 365), true)
    for _, nButton in pairs(tSelButtons) do
        if imgui.SelButton(sWindows == nButton, u8(nButton), imgui.ImVec2(120, 40)) then 
            sWindows = nButton
        end
    end
    
    
        if sWindows == tSelButtons[1] then
            selectable = 0
        end
        if sWindows == tSelButtons[2] then
            selectable = 1
        end
        if sWindows == tSelButtons[3] then
            selectable = 2
        end
    imgui.EndChild()
    imgui.End()
    end

end

----------- ФУНКЦИИ ---------->>

function main()
    while not isSampAvailable() do wait(50) end
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
        end
    if not doesDirectoryExist(getWorkingDirectory() .. '\\config') then
        createDirectory('moonloader\\config')
    end
    if not doesFileExist(getWorkingDirectory() .. '\\config\\GPS.ini') then
        info_msg('Отсутствует INI-файл (файл с настройками). Уже качаю :)')
        downloadUrlToFile('https://raw.githubusercontent.com/M0rtelli/STools/main/config/GPS.ini', getWorkingDirectory() .. '/config/GPS.ini', download_handler)
    end
    sampRegisterChatCommand('update_stools', function() 
    update("https://gist.githubusercontent.com/M0rtelli/44ea4b212e724f82803647bb87f257d5/raw", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/M0rtelli/STools/main/STools.lua")
    end)
    sampRegisterChatCommand('/stools', function()
        main_window_state.v = not main_window_state.v
        imgui.Process = main_window_state.v
    end)
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

---------- ХУКИ ------------>>

function sampev.onServerMessage(color, text)
    local _, my_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local my_nick = sampGetPlayerNickname(my_id)
    if text:match('Пусто!') then
        if lovim_ans and not sampIsDialogActive() then
            lua_thread.create(function()
                wait(700)
                sampSendChat('/ans')    
            end)
            return false
        else
        info_msg('Нет ни одного репорта!')
        return false
        end
    end
    if text:match('Данный тикет кто-то рассматривает') then
        if lovim_ans then
            lua_thread.create(function()
                sampSendDialogResponse(dialog_now, 0, nil, nil)
                wait(700)
                sampSendChat('/ans')    
            end)
            return false
        else
        info_msg('Данный репорт уже кто-то взял!')
        return false
        end
    end
    if text:match('Хелпер ' .. my_nick .. '%[%d+%] передал репорт') then
        if lovim_ans then
            lua_thread.create(function()
                wait(700)
                sampSendChat('/ans')    
            end)
        else
        end
    end
    end

function sampev.onConnectionRequestAccepted(ip, port, playerId, challenge)
    if not checked then
    check_upd("https://gist.githubusercontent.com/M0rtelli/44ea4b212e724f82803647bb87f257d5/raw", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/M0rtelli/STools/main/STools.lua")
    checked = true
    end
    end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    dialog_now = id
    if title:match('Репорт') and lovim_ans then
        local is_is = false
        local tLines = split(text, "\n")
        for k, v in ipairs(tLines) do
            if v:find("^%{......%}%[В]") then
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

--------- СНИППЕТЫ --------->>

function imgui.CustomButton(name, color, colorHovered, colorActive, size)
    local clr = imgui.Col
    imgui.PushStyleColor(clr.Button, color)
    imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
    imgui.PushStyleColor(clr.ButtonActive, colorActive)
    if not size then size = imgui.ImVec2(0, 0) end
    local result = imgui.Button(name, size)
    imgui.PopStyleColor(3)
    return result
    end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], text[i])
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(w) end
        end
    end

    render_text(text)
    end

function imgui.SelButton(state, lable, size)
    if state then
        --imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.06, 0.53, 0.98, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.28, 0.56, 1.00, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.06, 0.53, 0.98, 1.00))
            local button = imgui.Button(lable, size)
        imgui.PopStyleColor(3)
        return button
    else
        --imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 0.80))
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.20, 0.25, 0.29, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.28, 0.56, 1.00, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.06, 0.53, 0.98, 1.00))
            local button = imgui.Button(lable, size)
            imgui.PopStyleColor(3)
        return button
    end
    end
function enableDialog(bool)
    local memory = require 'memory'
    memory.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
    end
function hint(text)
    lua_thread.create(
      function()
        imgui.TextDisabled("(?)")
        if imgui.IsItemHovered() then
          imgui.BeginTooltip()
          imgui.TextUnformatted(u8(text))
          imgui.EndTooltip()
        end
    end)
    end
function info_msg(text)
    sampAddChatMessage('{8A2BE2}[STools]:{00CED1} ' .. text)
    end
function style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(7, 7)
    style.WindowRounding = 7.0
    style.FramePadding = ImVec2(5, 5)
    style.ItemSpacing = ImVec2(7, 3)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 15.0
    style.GrabMinSize = 15.0
    style.GrabRounding = 7.0
    style.ChildWindowRounding = 8.0
    style.FrameRounding = 6.0
    

        colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
        colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
        colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
        colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
        colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
        colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
        colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
        colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
        colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
        colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
        colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
        colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
        colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
        colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
        colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
        colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
        colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
        colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
        colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
        colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
        colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
        colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
        colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
        colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
        colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
        colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
        colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
        colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
        colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
        colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
        colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
        colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
        colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
        colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
        colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
        colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
        colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
        colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
        colors[clr.ModalWindowDarkening] = ImVec4(0.41, 0.41, 0.41, 0.73)
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
                  info_msg('Пытаюсь обновиться c {4682B4}'..thisScript().version..'{00CED1} на {4682B4}'..updateversion)
                  wait(250)
                  downloadUrlToFile(updatelink, thisScript().path,
                    function(id3, status1, p13, p23)
                      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                        print(string.format('Загружено %d из %d.', p13, p23))
                      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                        print('Загрузка обновления завершена.')
                        info_msg('Обновление прошло успешно! Перезагружаемся...')
                        goupdatestatus = true
                        lua_thread.create(function() wait(500) thisScript():reload() end)
                      end
                      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                        if goupdatestatus == nil then
                          info_msg(prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..')
                          update = false
                        end
                      end
                    end
                  )
                  end, prefix
                )
              else
                update = false
                info_msg('v'..thisScript().version..': Обновление не требуется.')
              end
            end
          else
            info_msg('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
            update = false
          end
        end
      end
    )
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
                  info_msg('Обнаружено обновление! Обновить скрипт можно командой /update_stools')
                  end
                )
              else
                update = false
                info_msg('v'..thisScript().version..': Обновление не требуется.')
              end
            end
          else
            info_msg('v'..thisScript().version..': Не могу проверить обновление. Смиритесь, таков путь!')
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

function download_handler(id, status, p1, p2)
    if stop_downloading then
      stop_downloading = false
      download_id = nil
      
      return false 
    end
  end