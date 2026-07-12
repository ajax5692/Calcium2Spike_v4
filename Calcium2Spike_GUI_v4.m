function Calcium2Spike_GUI_v4

p = mfilename('fullpath');
[coreProcessorfileLocation,nameOfFile] = fileparts(p);

alreadyDrawn = findobj('Name', 'Calcium2Spike_GUI');
if ~isempty(alreadyDrawn)
    msgbox('Calcium2Spike_GUI is already open! Please close older instances.');
    return;
end

figureCalcium2Spike_GUI = figure;
set(figureCalcium2Spike_GUI,'units', 'normalized',...
    'position', [0.1 0.1 0.7 0.7], 'Color', [0.6 0.6 0.6],...
    'NumberTitle', 'off', 'Name', 'Calcium2Spike_GUI','Resize','off',...
    'MenuBar', 'none');


%initializing data that will be embedded in the figure
data = InitializeEmptyDataStructure_C2S_GUI(coreProcessorfileLocation);
data.source = figureCalcium2Spike_GUI;
guidata(figureCalcium2Spike_GUI, data); 

%GUI header
GUIheader = GenericTextBox_C2S(figureCalcium2Spike_GUI);
set(GUIheader, 'Position', [0, 0.85, 1, 0.1]);
set(GUIheader, 'String', 'Calcium2Spike');
set(GUIheader, 'ForegroundColor', [0 1 0]);
set(GUIheader, 'BackGroundColor', [0 0 0]);
set(GUIheader, 'FontWeight', 'Bold'); fontsize(20,'points');
set(GUIheader, 'HorizontalAlignment','center');

%error "console"
errorConsole = GenericTextBox_C2S(figureCalcium2Spike_GUI);
set(errorConsole, 'Position', [0.03, 0.03, 0.4, 0.05]);
set(errorConsole, 'String', 'No errors');
set(errorConsole, 'ForegroundColor', [0.64 0.08 0.18]);
set(errorConsole, 'BackGroundColor', [0.85 0.85 0.85]);
set(errorConsole, 'FontWeight', 'Bold');
set(errorConsole, 'HorizontalAlignment','center');

data.GUI.errorConsole = errorConsole;
guidata(figureCalcium2Spike_GUI, data);

%logging "console"
loggingConsole = GenericTextBox_C2S(figureCalcium2Spike_GUI);
set(loggingConsole, 'Position', [0.45,0.03,0.4,0.047]);
set(loggingConsole, 'String', data.logging.latestReturned);
set(loggingConsole, 'ForegroundColor',[0.4667 0.6745 0.1882]);
set(loggingConsole, 'BackGroundColor',[0.9 0.9 0.9]);
set(loggingConsole, 'FontWeight','Bold');
set(loggingConsole, 'HorizontalAlignment','Left');

data.GUI.loggingConsole = loggingConsole;
guidata(figureCalcium2Spike_GUI, data);

%%% - 1. Project management Console"
ExperimentFilesUIGroup = uipanel('Title','Project management',...
    'FontSize', 18,...
    'Position',[0.025, 0.38, 0.48, 0.45],...
    'ForegroundColor',[0.5, 0.5, 0.5],...
    'BackgroundColor','White',...
    'BorderType','line',...
    'BorderColor','k',...
    'ShadowColor','w');

% - 1a. Save location spacecard
SaveLocationUIGroup = uipanel('Title','Save location',...
    'FontSize', 15, ...
    'Position',[0.030505952380952,0.673280423280423,0.468749999999999,0.11375661375661],...
    'BackgroundColor',[0.75 0.75 0.75],...
    'BorderType','line',...GenericTextBox
    'BorderColor','k',...
    'ShadowColor','w');

generalTB(1) = GenericTextBox_C2S(SaveLocationUIGroup);
set(generalTB(1), 'Position', [0.012006861063465,0.086956521739132,0.974271012006861,0.289855072463767]);
set(generalTB(1), 'String', 'No location specified');
set(generalTB(1), 'HorizontalAlignment', 'left');
set(generalTB(1), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(1), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(1), 'Tag', 'SaveLocationPathTB');


generalTB(2) = GenericTextBox_C2S(SaveLocationUIGroup);
set(generalTB(2), 'Position', [0.01,0.56,0.974271012006861,0.289855072463767]);
set(generalTB(2), 'String',char(hex2dec('2713')));
set(generalTB(2), 'HorizontalAlignment', 'left');
set(generalTB(2), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(2), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(2), 'FontSize', 12);
set(generalTB(2), 'FontWeight', 'bold');
set(generalTB(2), 'Tag', 'SaveLocationPathCheckmark');

PB(1) = GenericPushButton_C2S(SaveLocationUIGroup);
set(PB(1), 'String', 'Browse');
set(PB(1), 'Position', [0.05,0.44,0.1,0.5]);
set(PB(1), 'Tag', 'SaveLocationButton');
set(PB(1), 'Callback', @callback_SpecifySaveLocation_C2S);

PB(2) = GenericPushButton_C2S(SaveLocationUIGroup);
set(PB(2), 'String', 'Open Folder');
set(PB(2), 'FontSize', 7);
set(PB(2), 'HorizontalAlignment', 'left');
set(PB(2), 'Position', [0.881646655231561,0.057971014492756,0.110291595197254,0.260869565217391]);
set(PB(2), 'TooltipString', ['Opens the folder containing the analyzed data.']);
set(PB(2), 'Tag', 'OpenSaveLocationPathPB');
set(PB(2), 'Enable', 'off');
set(PB(2), 'Callback', @callback_OpenSaveLocationFolder_C2S);

% - 1b. MESc spacecard
MEScUIGroup = uipanel('Title','MESc file',...
    'FontSize', 15, ...
    'Position',[0.030505952380952,0.402063492063488,0.468749999999999,0.255375661375661],...
    'BackgroundColor',[0.75 0.75 0.75],...
    'BorderType','line',...
    'BorderColor','k',...
    'ShadowColor','w');

generalTB(3) = GenericTextBox_C2S(MEScUIGroup);
set(generalTB(3), 'Position', [0.01,0.63,0.974271012006861,0.289855072463767]);
set(generalTB(3), 'String',char(hex2dec('2713')));
set(generalTB(3), 'HorizontalAlignment', 'left');
set(generalTB(3), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(3), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(3), 'FontSize', 12);
set(generalTB(3), 'FontWeight', 'bold');
set(generalTB(3), 'Tag', 'MEScFileSelectionCheckmark');

PB(3) = GenericPushButton_C2S(MEScUIGroup);
set(PB(3), 'String', 'Browse');
set(PB(3), 'Position', [0.05,0.75,0.10045025728988,0.18]);
set(PB(3), 'Enable', 'off');
set(PB(3), 'Callback', @callback_SelectMEScFile_C2S);
set(PB(3), 'Tag', 'SelectMEScFile');

generalTB(4) = GenericTextBox_C2S(MEScUIGroup);
set(generalTB(4), 'Position', [0.18,0.75,0.974271012006861,0.143708145927016]);
set(generalTB(4), 'String', 'No MESc file selected');
set(generalTB(4), 'HorizontalAlignment', 'left');
set(generalTB(4), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(4), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(4), 'Tag', 'MEScFileLocationPathTB');

%reference MESc unit for calculation
generalTB(20) = GenericTextBox_C2S(MEScUIGroup);
set(generalTB(20), 'Position', [0.72,0.57,0.974271012006861,0.143708145927016]);
set(generalTB(20), 'String', 'Ref. measurement unit');
set(generalTB(20), 'HorizontalAlignment', 'left');
set(generalTB(20), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(20), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(20), 'Tag', 'MEScRefUnitTB');

%MESc ref. unit selection editable textbox
EB(1) = GenericEditBox_C2S(MEScUIGroup);
set(EB(1), 'String', '50');
set(EB(1), 'Position', [0.94,0.6,0.05,0.15]);
set(EB(1), 'Enable', 'off');
set(EB(1), 'Tag', 'SetMEScRefUnitEB');
set(EB(1), 'TooltipString', ['Enter the unit number recorded in MESC ' ...
    'to be considered for calculating imaging parameters like frame-rate,' ...
    ' number of planes etc. Default value=50']);

MEScParamsUIGroup = uipanel('Title','MESc Params',...
    'FontSize', 10, ...
    'Position',[0.035,0.412380952380952,0.457,0.13],...
    'ForegroundColor',[0.3 0.3 0.3],...
    'BackgroundColor',[0.75 0.75 0.75]);

generalTB(5) = GenericTextBox_C2S(MEScParamsUIGroup);
set(generalTB(5), 'Position', [0.012006861063465,0.550344827586227,0.974271012006861,0.3]);
set(generalTB(5), 'String', 'FrameRate: ');
set(generalTB(5), 'FontSize', 8);
set(generalTB(5), 'HorizontalAlignment', 'left');
set(generalTB(5), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(5), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(5), 'Tag', 'MEScFramerateTB');

generalTB(6) = GenericTextBox_C2S(MEScParamsUIGroup);
set(generalTB(6), 'Position', [0.012006861063465,0.060344827586227,0.974271012006861,0.3]);
set(generalTB(6), 'String', 'TimeSteps in ms:');
set(generalTB(6), 'FontSize', 8);
set(generalTB(6), 'HorizontalAlignment', 'left');
set(generalTB(6), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(6), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(6), 'Tag', 'MEScTimeStepsTB');

generalTB(7) = GenericTextBox_C2S(MEScParamsUIGroup);
set(generalTB(7), 'Position', [0.412006861063465,0.550344827586227,0.974271012006861,0.3]);
set(generalTB(7), 'String', 'No. of planes detected:');
set(generalTB(7), 'FontSize', 8);
set(generalTB(7), 'HorizontalAlignment', 'left');
set(generalTB(7), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(7), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(7), 'Tag', 'MEScMultiplaneTB');


%%% - 2. Suite2p output management Console
Suite2pOutputUIGroup = uipanel('Title','Suite2p output management',...
    'FontSize', 18, ...
    'Position',[0.525, 0.38, 0.45, 0.45],...
    'ForegroundColor',[0.5 0.5 0.5],...
    'BackgroundColor','white',...
    'BorderType','line',...
    'BorderColor','k',...
    'ShadowColor','w');

% - 2a. Layer selection spacecard
LayerUIGroup = uipanel('Title','Layer selection',...
    'FontSize', 15, ...
    'Position',[0.53, 0.67, 0.44, 0.115],'BackgroundColor',[0.75 0.75 0.75],...
    'BorderType','line',...
    'BorderColor','k',...
    'ShadowColor','w');

% - 2a.i. Dropdown menu for layers
DD_currentLayer = uicontrol(LayerUIGroup);
set(DD_currentLayer,'Style','popupmenu')
set(DD_currentLayer,'String', {'Select Layer'});
set(DD_currentLayer, 'Position',[30,33,100,20]);
set(DD_currentLayer, 'FontSize',10);
set(DD_currentLayer, 'Enable', 'off');
set(DD_currentLayer, 'Tag', 'LayerSelectionDD');
set(DD_currentLayer, 'Callback', @callback_suite2pLayerSelection_C2S);

generalTB(8) = GenericTextBox_C2S(LayerUIGroup);
set(generalTB(8), 'Position', [0.02,0.05,0.974271012006861,0.3]);
set(generalTB(8), 'String', 'Selected layer: --');
set(generalTB(8), 'HorizontalAlignment', 'left');
set(generalTB(8), 'ForeGroundColor', [0.3 0.3 0.3]);
set(generalTB(8), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(8), 'Tag', 'CurrentLayerTB');

generalTB(9) = GenericTextBox_C2S(LayerUIGroup);
set(generalTB(9), 'Position', [0.015,0.53,0.03,0.3]);
set(generalTB(9), 'String',char(hex2dec('2713')));
set(generalTB(9), 'HorizontalAlignment', 'left');
set(generalTB(9), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(9), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(9), 'FontSize', 12);
set(generalTB(9), 'FontWeight', 'bold');
set(generalTB(9), 'Tag', 'LayerSelectionCheckmark');

generalTB(10) = GenericTextBox_C2S(LayerUIGroup);
set(generalTB(10), 'Position', [0.32,0.05,0.8,0.3]);
set(generalTB(10), 'String', 'No layers analyzed yet');
set(generalTB(10), 'HorizontalAlignment', 'left');
set(generalTB(10), 'ForeGroundColor', [0.3 0.3 0.3]);
set(generalTB(10), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(10), 'Tag', 'AnalyzedLayerTB');


% - 2b. Fall.mat file selection spacecard
FallSelectionUIGroup = uipanel('Title','Suite2p Fall.mat file',...
    'FontSize', 15, ...
    'Position',[0.53,0.404,0.44,0.25375661375661],'BackgroundColor',[0.75 0.75 0.75],...
    'BorderType','line',...
    'BorderColor','k',...
    'ShadowColor','w');

PB(4) = GenericPushButton_C2S(FallSelectionUIGroup);
set(PB(4), 'String', 'Browse');
set(PB(4), 'Position', [0.05, 0.75, 0.12, 0.18]);
set(PB(4), 'Enable', 'off');
set(PB(4), 'Callback', @callback_suite2pFallSelection_C2S);
set(PB(4), 'Tag', 'FallSelectionPB');

generalTB(11) = GenericTextBox_C2S(FallSelectionUIGroup);
set(generalTB(11), 'Position', [0.25,0.745,0.974271012006861,0.143708145927016]);
set(generalTB(11), 'String', 'No file selected');
set(generalTB(11), 'HorizontalAlignment', 'left');
set(generalTB(11), 'ForeGroundColor', [0.3 0.3 0.3]);
set(generalTB(11), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(11), 'Tag', 'FallFilepathTB');

generalTB(12) = GenericTextBox_C2S(FallSelectionUIGroup);
set(generalTB(12), 'Position', [0.015,0.74,0.03,0.15]);
set(generalTB(12), 'String',char(hex2dec('2713')));
set(generalTB(12), 'HorizontalAlignment', 'left');
set(generalTB(12), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(12), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(12), 'FontSize', 12);
set(generalTB(12), 'FontWeight', 'bold');
set(generalTB(12), 'Tag', 'FallCheckmark');

FallParamsUIGroup = uipanel('Title','Fall.mat Params',...
    'FontSize', 10, ...
    'ForegroundColor',[0.3 0.3 0.3],...
    'Position',[0.535,0.412380952380952,0.43,0.13],'BackgroundColor',[0.75 0.75 0.75]);

generalTB(13) = GenericTextBox_C2S(FallParamsUIGroup);
set(generalTB(13), 'Position', [0.01,0.75,0.974271012006861,0.143708145927016]);
set(generalTB(13), 'String', 'No. of ROIs detected:');
set(generalTB(13), 'FontSize', 8);
set(generalTB(13), 'HorizontalAlignment', 'left');
set(generalTB(13), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(13), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(13), 'Tag', 'FallROInumTB');

%%% - 3. Analysis Console
AnalysisUIGroup = uipanel('Title','Analysis',...
    'FontSize', 18, ...
    'Position',[0.025,0.1,0.95,0.255375661375661],...
    'ForegroundColor',[0.5 0.5 0.5],...
    'BackgroundColor','white',...
    'BorderType','line',...
    'BorderColor','k',...
    'ShadowColor','w');

% - 3a. OASIS threshold editable textbox
EB(2) = GenericEditBox_C2S(AnalysisUIGroup);
set(EB(2), 'String', '0');
set(EB(2), 'Position', [0.01,0.62,0.05,0.25]);
set(EB(2), 'Enable', 'off');
set(EB(2), 'Tag', 'SetOASISthresholdEB');
set(EB(2), 'Callback', @callback_OASISeditbox_C2S);

generalTB(14) = GenericTextBox_C2S(AnalysisUIGroup);
set(generalTB(14), 'String', sprintf('Set OASIS threshold\n(default 0,\nmust be <0.5)'));
set(generalTB(14), 'HorizontalAlignment', 'Left');
set(generalTB(14), 'FontSize', 9);
set(generalTB(14), 'Position', [0.07,0.61,0.1,0.3]);
set(generalTB(14), 'Enable', 'off');
set(generalTB(14), 'Tag', 'SetOASISthresholdTB');

% - 3b.i. Pool data checkbox
CB(1) = GenericCheckBox_C2S(AnalysisUIGroup);
set(CB(1), 'String', 'Ready to pool?');
set(CB(1), 'Position', [0.02,0.2,0.2,0.1]);
set(CB(1), 'Tag', 'ReadyToPoolCB');
set(CB(1), 'FontSize', 10);
set(CB(1), 'TooltipString', ['Check this box enable the Pool Data' ...
    ' button. Data pooling causes layer-wise df/f and spike data to be' ...
    ' stacked into a single 2D array.']);
set(CB(1), 'Callback', @callback_PoolDataCheckBox_C2S);

% - 3b.ii. Pool data pushbutton
PB(6) = GenericPushButton_C2S(AnalysisUIGroup);
set(PB(6), 'String', 'Pool Data');
set(PB(6), 'Position', [0.12,0.12,0.08,0.25]);
set(PB(6), 'Tag', 'PoolDataPB');
set(PB(6), 'Backgroundcolor', [1 1 1]);
set(PB(6), 'Foregroundcolor', [0 0 0]);
set(PB(6), 'FontWeight', 'normal');
set(PB(6), 'Enable', 'off');
set(PB(6), 'Callback', @callback_PoolData_C2S);

% - 3c. Core analysis space card
CoreAnalysisUIGroup = uipanel('Title','CoreAnalysis',...
    'FontSize', 10, ...
    'ForegroundColor',[0.75 0.75 0.75],...
    'Position',[0.25,0.13,0.718,0.19],'BackgroundColor',[0.75 0.75 0.75],...
    'BorderType','line',...
    'BorderColor',[0.75 0.75 0.75],...
    'ShadowColor','w');

% - 3c.i. Run analysis button
PB(5) = GenericPushButton_C2S(CoreAnalysisUIGroup);
set(PB(5), 'String', 'Run analysis');
set(PB(5), 'Position', [0.015,0.75,0.1,0.25]);
set(PB(5), 'Enable', 'off');
set(PB(5), 'Tag', 'RunAnalysisPB');
set(PB(5), 'Callback', @callback_CoreAnalysis_C2S);

% - 3c.ii. Create the primary progress bar
pbAxes1 = axes(CoreAnalysisUIGroup,'Units', 'normalized', ...
    'Position', [0.18 0.9 0.55 0.1], ...
    'XLim', [0 1], ...
    'YLim', [0 1], ...
    'XTick', [], ...
    'YTick', [], ...
    'Box', 'on', ...
    'Tag', 'progressbar_primary');

pbPatch1 = patch( ...
    'Parent', pbAxes1, ...
    'XData', [0 0 0 0], ...
    'YData', [0 1 1 0], ...
    'FaceColor', [0 0.6 0.9]);

guidata(figureCalcium2Spike_GUI, data);

% - 3c.iii. Primary progessbar "console"
primaryPBconsole = GenericTextBox_C2S(CoreAnalysisUIGroup);
set(primaryPBconsole, 'Position', [0.74 0.89 0.1 0.12]);
set(primaryPBconsole, 'String', 'Overall progress');
set(primaryPBconsole, 'ForeGroundColor',[0 0 0]);
set(primaryPBconsole, 'BackGroundColor', [0.75 0.75 0.75]);
set(primaryPBconsole, 'FontWeight','Bold');
set(primaryPBconsole, 'HorizontalAlignment','Left');
set(primaryPBconsole, 'Tag','primaryPBconsole');

data.GUI.primaryPBconsole = primaryPBconsole;
guidata(figureCalcium2Spike_GUI, data);

% - 3c.iv. Create the secondary progress bar
pbAxes2 = axes(CoreAnalysisUIGroup,'Units', 'normalized', ...
    'Position', [0.18 0.7 0.55 0.1], ...
    'XLim', [0 1], ...
    'YLim', [0 1], ...
    'XTick', [], ...
    'YTick', [], ...
    'Box', 'on', ...
    'Tag', 'progressbar_secondary');

pbPatch2 = patch( ...
    'Parent', pbAxes2, ...
    'XData', [0 0 0 0], ...
    'YData', [0 1 1 0], ...
    'FaceColor', [0 0.6 0.9]);

guidata(figureCalcium2Spike_GUI, data);

% - 3c.v. Secondary progessbar "console"
secondaryPBconsole = GenericTextBox_C2S(CoreAnalysisUIGroup);
set(secondaryPBconsole, 'Position', [0.74 0.68 0.25 0.13]);
set(secondaryPBconsole, 'String', 'Running Step: --');
set(secondaryPBconsole, 'ForegroundColor',[0 0 0]);
set(secondaryPBconsole, 'BackGroundColor', [0.75 0.75 0.75]);
set(secondaryPBconsole, 'FontWeight','Bold');
set(secondaryPBconsole, 'HorizontalAlignment','Left');
set(secondaryPBconsole, 'Tag','secondaryPBconsole');

data.GUI.primaryPBconsole = primaryPBconsole;
guidata(figureCalcium2Spike_GUI, data);

% - 3c.vi. Analysis result space card"
AnalysisResultUIGroup = uipanel('Title','Analysis Output',...
    'FontSize', 10, ...
    'ForegroundColor',[0.3 0.3 0.3],...
    'Position',[0.26,0.14,0.705,0.09],'BackgroundColor',[0.75 0.75 0.75]);

generalTB(15) = GenericTextBox_C2S(AnalysisResultUIGroup);
set(generalTB(15), 'Position', [0.01,0.5,0.974271012006861,0.3]);
set(generalTB(15), 'String', ('Total neurons in suite2p output:'));
set(generalTB(15), 'FontSize', 8);
set(generalTB(15), 'HorizontalAlignment', 'left');
set(generalTB(15), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(15), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(15), 'Tag', 'DffCountTB');

generalTB(16) = GenericTextBox_C2S(AnalysisResultUIGroup);
set(generalTB(16), 'Position', [0.01,0.1,0.974271012006861,0.3]);
set(generalTB(16), 'String', ('Neurons filtered due to low PSNR:'));
set(generalTB(16), 'FontSize', 8);
set(generalTB(16), 'HorizontalAlignment', 'left');
set(generalTB(16), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(16), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(16), 'Tag', 'PSNRfilterTB');

generalTB(17) = GenericTextBox_C2S(AnalysisResultUIGroup);
set(generalTB(17), 'Position', [0.41,0.5,0.974271012006861,0.3]);
set(generalTB(17), 'String', ('Final number of neurons for which ΔF/F saved:'));
set(generalTB(17), 'FontSize', 8);
set(generalTB(17), 'HorizontalAlignment', 'left');
set(generalTB(17), 'ForeGroundColor', [0.4 0.4 0.4]);
set(generalTB(17), 'BackGroundColor', [0.75 0.75 0.75]);
set(generalTB(17), 'Tag', 'DffSavedUnitsTB');

% - 4. Restart GUI PB
PB(6) = GenericPushButton_C2S(figureCalcium2Spike_GUI);
set(PB(6), 'String', 'Restart GUI');
set(PB(6), 'Position', [0.895,0.028,0.08,0.055]);
set(PB(6), 'Tag', 'RestartGuiPB');
set(PB(6), 'Callback', @callback_resetCalcium2Spike_GUI_v4);