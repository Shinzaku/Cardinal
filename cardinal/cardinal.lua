addon.name      = 'Cardinal';
addon.author    = 'Shinzaku';
addon.version   = '1.0';
addon.desc      = 'Displays Cardinal Chant bonuses based on target direction';
addon.link      = 'https://github.com/Shinzaku/cardinal/';

require("common");
local imgui = require("imgui");

local ui = {
    is_open = { true, },
}

ashita.events.register('d3d_present', 'd3d_present_callback1', function ()
    local targ = AshitaCore:GetMemoryManager():GetAutoFollow():GetTargetServerId();
    if (targ and targ ~= 0x4000000) then
        local targIndex = AshitaCore:GetMemoryManager():GetAutoFollow():GetTargetIndex();
        imgui.SetNextWindowSize({ 180, 100 }, ImGuiCond_Always);
        imgui.SetNextWindowPos({ 0, 0 }, ImGuiCond_FirstUseEver);
        imgui.PushStyleColor(ImGuiCol_WindowBg, { 0.25, 0.25, 0.25, 0.5 });
        imgui.PushStyleColor(ImGuiCol_Border, { 0, 0, 0, 0.5 });
        imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 10.0);
        if (ui.is_open[1] and imgui.Begin("Cardinal", ui.is_open, bit.bor(ImGuiWindowFlags_NoDecoration))) then
            local pX = GetPlayerEntity().Movement.LocalPosition.X;
            local pY = GetPlayerEntity().Movement.LocalPosition.Y;
            local tX = AshitaCore:GetMemoryManager():GetEntity():GetLocalPositionX(targIndex);
            local tY = AshitaCore:GetMemoryManager():GetEntity():GetLocalPositionY(targIndex);

            local n, s, e, w = false, false, false, false;
            if (tX >= pX + 0.5) then
                e = true;
            elseif (tX <= pX - 0.5) then
                w = true;
            end
            if (tY >= pY + 0.5) then
                n = true;
            elseif (tY <= pY - 0.5) then
                s = true;
            end

            local ncolor = { 0.5, 0.5, 0.5, 0.5 };
            if (n) then ncolor = { 1.0, 1.0, 1.0, 1.0 } end;
            ImGuiTextCenter("  M.Crit.", ncolor);
            ImGuiTextCenter("   \xef\x8c\x8c", ncolor);
            local wcolor = { 0.5, 0.5, 0.5, 0.5 };
            if (w) then wcolor = { 1.0, 1.0, 1.0, 1.0 } end;
            imgui.TextColored(wcolor, "M.Burst \xef\x8c\x8a");
            imgui.SameLine();
            local ecolor = { 0.5, 0.5, 0.5, 0.5 };
            if (e) then ecolor = { 1.0, 1.0, 1.0, 1.0 } end;
            ImGuiTextRight("\xef\x8c\x8b M.Atk.", ecolor);
            local scolor = { 0.5, 0.5, 0.5, 0.5 };
            if (s) then scolor = { 1.0, 1.0, 1.0, 1.0 } end;
            ImGuiTextCenter("   \xef\x8c\x89", scolor);
            ImGuiTextCenter("  M.Acc.", scolor);
            

            imgui.End();
        end
        imgui.PopStyleColor(2);
        imgui.PopStyleVar(1);
    end
end);

function ImGuiTextLeft(str, color)
    if (not color) then color = { 1.0, 1.0, 1.0, 1.0 } end;
    imgui.SetCursorPosX(0);
    imgui.TextColored(color, str);
end

function ImGuiTextRight(str, color)
    if (not color) then color = { 1.0, 1.0, 1.0, 1.0 } end;
    local fsize = imgui.GetFontSize() * #str / 2;
    imgui.SetCursorPosX(imgui.GetWindowSize() - fsize);
    imgui.TextColored(color, str);
end

function ImGuiTextCenter(str, color)
    if (not color) then color = { 1.0, 1.0, 1.0, 1.0 } end;
    local fsize = imgui.GetFontSize() * #str / 2;
    imgui.SetCursorPosX(imgui.GetWindowSize() / 2 - fsize + (fsize / 2));
    imgui.TextColored(color, str);
end