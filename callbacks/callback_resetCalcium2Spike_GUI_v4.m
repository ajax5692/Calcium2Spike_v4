function callback_resetCalcium2Spike_GUI_v4(hO, ed)

figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);

close(figureCalcium2Spike_GUI)

Calcium2Spike_GUI_v4