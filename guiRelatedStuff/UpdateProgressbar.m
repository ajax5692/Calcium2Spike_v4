function UpdateProgressbar(d, progressbarType, colorValRGB, frac)

childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis',progressbarType);


frac = max(0, min(1, frac));
set(d.source.Children(childrenArray(1)).Children(childrenArray(2)).Children, 'XData', [0 0 frac frac], 'FaceColor', colorValRGB);
