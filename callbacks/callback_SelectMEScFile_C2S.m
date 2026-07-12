function callback_SelectMEScFile_C2S(hO, ed)

figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);

[mescDataName, mescDataLocation] = uigetfile('*.mesc','Please select the MESc file',...
    'C:\Users\abhrajyoti.chakrabarti\Desktop\testNewGUI\');

if mescDataName ~= 0
    d.mescDataName = mescDataName;
    d.mescDataLocation = mescDataLocation;
    d = ToError_C2S(d, "No errors");
    d = ToLog_C2S(d, "MESc file successfully selected");
    %shorten mesc filepath for display in GUI
    longPath = fullfile(d.mescDataLocation, d.mescDataName);
    if length(longPath) > 50 % if it's too long for the UI
        pathParts = strsplit(longPath, filesep);
        %keep the drive letter and the last two folders/files
        shortPath = fullfile(pathParts{1}, '...', pathParts{end-1}, pathParts{end});
    else
        shortPath = longPath;
    end
    %update mesc location path TB
    childrenArray = GUI_childrenFinder_C2S(d,'MESc file','MEScFileLocationPathTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'String', shortPath);
    %update mesc file selection checkmark color
    childrenArray = GUI_childrenFinder_C2S(d,'MESc file','MEScFileSelectionCheckmark');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'ForegroundColor',[0.21 0.70 0.21]);
    %enable MESc ref. unit EB
    childrenArray = GUI_childrenFinder_C2S(d,'MESc file','SetMEScRefUnitEB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'on');
    % - mesc params space card
    childrenArray = GUI_childrenFinder_C2S(d,'MESc file','SetMEScRefUnitEB');
    refMEScUnit = d.source.Children(childrenArray(1)).Children(childrenArray(2)).String;
    tStepsInMs = h5readatt(strcat(d.mescDataLocation,d.mescDataName),...
        strcat('/MSession_0/MUnit_',refMEScUnit,'/'),'TStepInMs');
    d.mescFrameRate = (1/tStepsInMs)*1000;
    d.mescFrameRate = round(d.mescFrameRate,2);
    framerateString = strcat('FrameRate:',{' '},num2str(d.mescFrameRate),{' '}, 'Hz');
    timestepString = strcat('TimeSteps in ms:',{' '},num2str(tStepsInMs,'%05.2f'));
    %update framerate TB
    childrenArray = GUI_childrenFinder_C2S(d,'MESc Params','MEScFramerateTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'String', framerateString);
    %update timesteps TB
    childrenArray = GUI_childrenFinder_C2S(d,'MESc Params','MEScTimeStepsTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'String', timestepString);
    %update no. of planes TB
    numPlanes = h5readatt(strcat(d.mescDataLocation,d.mescDataName),...
        strcat('/MSession_0/MUnit_',refMEScUnit,'/'),'Slices');
    numPlaneString = strcat('No. of planes detected:',{' '},num2str(numPlanes));
    childrenArray = GUI_childrenFinder_C2S(d,'MESc Params','MEScMultiplaneTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'String', numPlaneString);
    % - layer selection space card
    %enable dropdown menu
    childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionDD');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable','on');
    %dynamic update of layer numbers
    dynamicLayerList = {'Select Layer'};
    for ii = 1:numPlanes
        dynamicLayerList{end+1} = sprintf('Layer %d', ii); 
    end
    childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionDD');
    dropdownHandle = d.source.Children(childrenArray(1)).Children(childrenArray(2));    
    set(dropdownHandle, 'String', dynamicLayerList);
    
else
    d = ToError_C2S(d, "MESc file selection interrupted by user");
    d = ToLog_C2S(d, "An error occured!!!");
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S(sprintf('MESc file selection\ninterrupted by user!'));
    % - mesc space card
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