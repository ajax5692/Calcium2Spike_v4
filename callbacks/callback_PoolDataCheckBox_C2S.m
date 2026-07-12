function callback_PoolDataCheckBox_C2S(hO, ed)

figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);

childrenArray = GUI_childrenFinder_C2S(d,'Analysis','ReadyToPoolCB');

if d.source.Children(childrenArray(1)).Children(childrenArray(2)).Value == 1
    childrenArray2 = GUI_childrenFinder_C2S(d,'Analysis','PoolDataPB');
    set(d.source.Children(childrenArray2(1)).Children(childrenArray2(2)), 'Enable', 'on',...
        'BackgroundColor', [0 0 1], 'ForegroundColor', [1 1 1], 'FontWeight', 'bold',...
        'String', 'Pool Data');
else
    childrenArray2 = GUI_childrenFinder_C2S(d,'Analysis','PoolDataPB');
    set(d.source.Children(childrenArray2(1)).Children(childrenArray2(2)), 'Enable', 'off',...
        'BackgroundColor', [1 1 1], 'ForegroundColor', [0 0 0], 'FontWeight', 'normal',...
        'String', 'Pool Data');
end