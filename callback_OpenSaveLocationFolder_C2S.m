function callback_OpenSaveLocationFolder_C2S(hO, ed)

figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);


winopen(d.saveAnalyzedData)