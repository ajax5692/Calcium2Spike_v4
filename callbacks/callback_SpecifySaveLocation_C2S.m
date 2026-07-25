function callback_SpecifySaveLocation_C2S(hO, ed)

figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);

saveDirectory = uigetdir('Please specify location where to save the results');

try
    if saveDirectory ~= 0
        d.saveAnalyzedData = saveDirectory;
        d = ToError_C2S(d, "No errors");
        d = ToLog_C2S(d, "Save location successfully specified");

        %shorten save folder path for display in GUI
        % longPath = fullfile(d.saveAnalyzedData);
        if length(d.saveAnalyzedData) > 50 % if it's too long for the UI
            pathParts = strsplit(d.saveAnalyzedData, filesep);
            %keep the drive letter and the last two folders/files
            shortPath = fullfile(pathParts{1}, '...', pathParts{end-1}, pathParts{end});
        else
            shortPath = d.saveAnalyzedData;
        end

        %update save location path text
        childrenArray = GUI_childrenFinder_C2S(d,'Save location','SaveLocationPathTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            strcat('Data saved at:', {' '}, shortPath));
        %enable open save folder button
        childrenArray = GUI_childrenFinder_C2S(d,'Save location','OpenSaveLocationPathPB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'on');
        %update checkmark color
        childrenArray = GUI_childrenFinder_C2S(d,'Save location','SaveLocationPathCheckmark');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
            'ForegroundColor',[0.21 0.70 0.21]);
        % - mesc space card
        %enable MESc browse PB
        childrenArray = GUI_childrenFinder_C2S(d,'MESc file','SelectMEScFile');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'on');  
        %enable MESc ref. unit EB
        childrenArray = GUI_childrenFinder_C2S(d,'MESc file','SetMEScRefUnitEB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'on');
        %change directory and create folder to store analyzed data
        cd(d.saveAnalyzedData)
        mkdir('AnalyzedCalciumToSpikeData')
        cd(d.originalCodePath)

    else %disable buttons and update GUI accordingly
        d = ToError_C2S(d, "Save location not specified by user");
        d = ToLog_C2S(d, "An error occured!!!");
        %pop-up msgbox
        beep;
        CustomMsgBox_C2S(sprintf('Save location specification\ninterrupted by user!'));
        % - savelocation space card
        %reset save location path text
        childrenArray = GUI_childrenFinder_C2S(d,'Save location','SaveLocationPathTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'No location specified');
        %disable open save folder PB
        childrenArray = GUI_childrenFinder_C2S(d,'Save location','OpenSaveLocationPathPB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off');
        %update checkmark color
        childrenArray = GUI_childrenFinder_C2S(d,'Save location','SaveLocationPathCheckmark');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
            'ForegroundColor',[0.9 0.3 0.3]);
        % - mesc space card
        %disable MESc browse PB
        childrenArray = GUI_childrenFinder_C2S(d,'MESc file','SelectMEScFile');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off');
        %reset MESc filepath text
        childrenArray = GUI_childrenFinder_C2S(d,'MESc file','MEScFileLocationPathTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'No MESc file selected');
        %update checkmark color
        childrenArray = GUI_childrenFinder_C2S(d,'MESc file','MEScFileSelectionCheckmark');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
            'ForegroundColor',[0.9 0.3 0.3]);
        %disable MESc ref. unit EB
        childrenArray = GUI_childrenFinder_C2S(d,'MESc file','SetMEScRefUnitEB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off');
        % - update MESc params space card
        %framerate TB
        childrenArray = GUI_childrenFinder_C2S(d,'MESc Params','MEScFramerateTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'FrameRate:');
        %timeSteps TB
        childrenArray = GUI_childrenFinder_C2S(d,'MESc Params','MEScTimeStepsTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'TimeSteps in ms:');
        %no. of planes TB
        childrenArray = GUI_childrenFinder_C2S(d,'MESc Params','MEScMultiplaneTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'No. of planes detected:');
        % - layer selection space card
        %disable dropdown menu
        childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionDD');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable','off');
        %reset current layer TB
        childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','CurrentLayerTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'Selected layer: --');
        %reset analyzed layer TB
        childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','AnalyzedLayerTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'No layers analyzed yet');
        %update checkmark color
        childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionCheckmark');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
            'ForegroundColor',[0.9 0.3 0.3]);
        % - suite2p Fall space card
        %disable pushbutton
        childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallSelectionPB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable','off');
        %reset suite2p Fall filepath TB
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
        childrenArray = GUI_childrenFinder_C2S(d,'AnalysisResultUIGroup','DffCountTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'Total neurons in suite2p output:');
        %PSNR filtered units
        childrenArray = GUI_childrenFinder_C2S(d,'AnalysisResultUIGroup','PSNRfilterTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'Neurons filtered due to low PSNR:');
        %saved df/f units
        childrenArray = GUI_childrenFinder_C2S(d,'AnalysisResultUIGroup','DffSavedUnitsTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'String', ...
            'Final number of neurons for which ΔF/F saved:');
        %reset primary and secondary progress bar
        UpdateProgressbar(d,'progressbar_primary', [0 0 1], 0);
        UpdateProgressbar(d,'progressbar_secondary', [0 0 1], 0);
    end
catch
end


guidata(d.source, d);