function callback_OASISeditbo_C2S(hObject, eventdata, handles)
    %define the threshold
    threshold = 0.5; 

    %get the text the user entered and convert it to a number
    userInput = get(hObject, 'String');
    inputValue = str2double(userInput);

    %check if it's a valid number AND if it exceeds the threshold
    if ~isnan(inputValue) && inputValue > threshold
        %pop-up msgbox
        beep;
        CustomMsgBox_C2S(sprintf('OASIS thresold value too high!\nReverting to 0.'));
        %revert the text box to default
        set(hObject, 'String', num2str(0));
    elseif inputValue < 0
        %pop-up msgbox
        beep;
        CustomMsgBox_C2S(sprintf('OASIS thresold cannot be\nnegative. Reverting to 0.'));
        %revert the text box to default
        set(hObject, 'String', num2str(0));
    end
end