function callback_suite2pFallSelection_C2S(hO, ed)

figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);

try

    % path to the animation file (must be the same size or smaller than the next uicontrol), hmtl code to display image.
    gif = sprintf('<html><img src="file:/%s\\spinner.gif"/></html>',pwd);
    % use an inactive (not disabled) pushbutton to display the gif. Use CData instead of background color to flatten.
    loadingGraphics = uicontrol('style','push', 'pos',[200 10 35 35], 'String',...
        gif,'enable','inactive','CData',uint8(255*ones(35,35,3)*0.75));
    loadingGraphics.Position = [820 434 30 30];
    pause(0.5)

    [fileName, FallDataLocation] = uigetfile('*.mat','Please select the correct Fall.mat file');

    %check if correct file loaded
    if isfield(load(strcat(FallDataLocation,fileName)), 'F') == 0
        %pop-up msgbox
        beep;
        CustomMsgBox_C2S(sprintf('Incorrect Fall.mat\nfile selected.'));
        d = ToError_C2S(d, "Incorrect Fall.mat selected.");
        d = ToLog_C2S(d, "An error occured!!!");
        delete(loadingGraphics)
        % - suite2p Fall space card
        %reset filepath TB
        childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallFilepathTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'No file selected');
        %update checkmark color
        childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallCheckmark');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
            'ForegroundColor',[0.9 0.3 0.3]);
        % - update Fall params space card
        %no. of ROIs
        childrenArray = GUI_childrenFinder_C2S(d,'Fall.mat Params','FallROInumTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'No. of ROIs detected:');
        % - update analysis space card
        %disable OASIS EB
        childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdEB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off');
        %disable OASIS TB
        childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable','off');
        % - update core analysis space card
        %disable run analysis PB
        childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off',...
            'BackgroundColor', 'w', 'ForegroundColor', 'k', 'FontWeight', 'normal', 'FontSize', 10);
        % - reset the analysis output space card
        %df/f count
        childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffCountTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'Total neurons in suite2p output:');
        %PSNR filtered units
        childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','PSNRfilterTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'Neurons filtered due to low PSNR:');
        %saved df/f units
        childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffSavedUnitsTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'Final number of neurons for which ΔF/F saved:');
        %reset primary and secondary progress bar
        UpdateProgressbar(d,'progressbar_primary', [0 0 1], 0);
        UpdateProgressbar(d,'progressbar_secondary', [0 0 1], 0);
    
    else %this means correct Fall.mat file is loaded
        %if Fall file is selected, load the Fall.mat temporarily
        if fileName ~= 0
            d.FallDataPath = FallDataLocation;
            d.FallFilename = fileName;

            tempVar= load(strcat(FallDataLocation,fileName));

            if isfield(tempVar, 'isCell') == 1
            else
                RENAMEiscellTOisCell_C2S(fileName, FallDataLocation);
                pause(0.5)
                cd(d.originalCodePath)
            end
            %update suite2p Fallfilepath TB
            %shorten mesc filepath for display in GUI
            longPath = fullfile(FallDataLocation, fileName);
            if length(longPath) > 50 % if it's too long for the UI
                pathParts = strsplit(longPath, filesep);
                %keep the drive letter and the last two folders/files
                shortPath = fullfile(pathParts{1}, '...', pathParts{end-1}, pathParts{end});
            else
                shortPath = longPath;
            end
            childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallFilepathTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
                shortPath);

            d = ToError_C2S(d, " No errors");
            d = ToLog(d, "Fall.mat successfully selected");
            %update Fall file selection checkmark color
            childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallCheckmark');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
                'ForegroundColor',[0.21 0.70 0.21]);
            % - update Fall params space card
            %no. of ROIs
            neuronsDetectedInSuite2p = sum(tempVar.isCell(:,1));
            childrenArray = GUI_childrenFinder_C2S(d,'Fall.mat Params','FallROInumTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
                strcat('No. of ROIs detected:',{' '},num2str(neuronsDetectedInSuite2p)));
            % - update analysis space card
            %enable OASIS EB
            childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdEB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'on');
            %enable OASIS TB
            childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable','on');
            % - update core analysis space card
            %enable run analysis PB
            childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'on',...
                'BackgroundColor', [0.6 1 0.6], 'ForegroundColor', 'k', 'FontWeight', 'bold', 'FontSize', 11);
            %reset primary and secondary progress bar
            UpdateProgressbar(d,'progressbar_primary', [0 0 1], 0);
            UpdateProgressbar(d,'progressbar_secondary', [0 0 1], 0);

            delete(loadingGraphics)

        else
            d = ToError_C2S(d, "Fall.mat selection interrupted");
            d = ToLog_C2S(d, "An error occured!!!");
            %pop-up msgbox
            beep;
            CustomMsgBox_C2S(sprintf('Fall.mat file\nselection interrupted!'));
            % - suite2p Fall space card
            %reset filepath TB
            childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallFilepathTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
                'No file selected');
            %update checkmark color
            childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallCheckmark');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
                'ForegroundColor',[0.9 0.3 0.3]);
            % - update Fall params space card
            %no. of ROIs
            childrenArray = GUI_childrenFinder_C2S(d,'Fall.mat Params','FallROInumTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
                'No. of ROIs detected:');
            % - update analysis space card
            %disable OASIS EB
            childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdEB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off');
            %disable OASIS TB
            childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable','off');
            % - update core analysis space card
            %disable run analysis PB
            childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off',...
                'BackgroundColor', 'w', 'ForegroundColor', 'k', 'FontWeight', 'normal', 'FontSize', 10);
            % - reset the analysis output space card
            %df/f count
            childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffCountTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
                'Total neurons in suite2p output:');
            %PSNR filtered units
            childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','PSNRfilterTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
                'Neurons filtered due to low PSNR:');
            %saved df/f units
            childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffSavedUnitsTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
                'Final number of neurons for which ΔF/F saved:');
            %reset primary and secondary progress bar
            UpdateProgressbar(d,'progressbar_primary', [0 0 1], 0);
            UpdateProgressbar(d,'progressbar_secondary', [0 0 1], 0);

        end

        delete(loadingGraphics)
    end

catch
    delete(loadingGraphics)
    d = ToError_C2S(d, "Fall.mat selection interrupted");
    d = ToLog_C2S(d, "An error occured!!!");
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S(sprintf('Fall.mat file\nselection interrupted!'));
    % - suite2p Fall space card
    %reset filepath TB
    childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallFilepathTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
        'No file selected');
    %update checkmark color
    childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallCheckmark');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'ForegroundColor',[0.9 0.3 0.3]);
    % - update Fall params space card
    %no. of ROIs
    childrenArray = GUI_childrenFinder_C2S(d,'Fall.mat Params','FallROInumTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
        'No. of ROIs detected:');
    % - update analysis space card
    %disable OASIS EB
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdEB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off');
    %disable OASIS TB
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable','off');
    % - update core analysis space card
    %disable run analysis PB
    childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off',...
        'BackgroundColor', 'w', 'ForegroundColor', 'k', 'FontWeight', 'normal', 'FontSize', 10);
    % - reset the analysis output space card
    %df/f count
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffCountTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
        'Total neurons in suite2p output:');
    %PSNR filtered units
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','PSNRfilterTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
        'Neurons filtered due to low PSNR:');
    %saved df/f units
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffSavedUnitsTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
        'Final number of neurons for which ΔF/F saved:');
    %reset primary and secondary progress bar
    UpdateProgressbar(d,'progressbar_primary', [0 0 1], 0);
    UpdateProgressbar(d,'progressbar_secondary', [0 0 1], 0);

end

guidata(d.source, d);