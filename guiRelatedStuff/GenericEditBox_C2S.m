function pb = GenericEditBox_C2S(F)
%creates a generic edit box on a given figure F;
warning('off','MATLAB:ui:javaframe:PropertyToBeRemoved');

defaultString = '';
defaultUnits = 'Normalized';
defaultPosition = [0 0 0.1 0.1];
defaultBackgroundColor = 'White';
defaultForegroundColor = 'Black';
defaultFontSize = 10;
defaultTag = 'notag';
defaultFontWeight = 'Normal';


pb = uicontrol(F,'Style', 'edit',...
    'String', defaultString,...
    'Units', defaultUnits,...
    'Position', defaultPosition,...
    'BackgroundCOlor', defaultBackgroundColor,...
    'ForegroundColor', defaultForegroundColor,...
    'FontSize', defaultFontSize,...
    'Tag', defaultTag,...
    'FontWeight', defaultFontWeight);

try
    jEdit = findjobj(pb);
    lineColor = java.awt.Color(0,0,0);
    thickness = 0;
    roundedCorners = true;
    newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
    jEdit.Border = newBorder;
catch
end