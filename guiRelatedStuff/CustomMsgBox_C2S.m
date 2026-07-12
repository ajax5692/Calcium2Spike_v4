function CustomMsgBox_C2S(text)
hMsg = msgbox(text, 'Error','warn');
textObj = findobj(hMsg, 'Type', 'text');
set(textObj, 'FontSize', 10);

%find the OK button object inside the message box
hButton = findobj(hMsg, 'Type', 'uicontrol', 'String', 'OK');

if ~isempty(hButton)
    % 3. Get positions of both the message box and the button
    msgPos = hMsg.Position;   % [left bottom width height]
    btnPos = hButton.Position; % [left bottom width height]
    
    % 4. Calculate the centered 'left' coordinate
    % Center X = (Box Width - Button Width) / 2
    btnPos(1) = (msgPos(3) - btnPos(3)) / 2;
    
    % 5. Apply the new centered position back to the button
    hButton.Position = btnPos;
end
