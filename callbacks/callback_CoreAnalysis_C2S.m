function callback_CoreAnalysis_C2S(hO, ed)

figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);

totalAnalysisSteps = 3;

if isempty(d.layers.analyzedLayers) == 1 %when gui is run first time
    d = ToError_C2S(d, "No errors");
    d = ToLog_C2S(d, "--");
    childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'BackgroundColor', [1 1 1],...
        'FontWeight', 'bold','ForegroundColor', [1 0 0],'FontSize', 12, 'String', 'Analyzing');

    gif = sprintf(['<html><img src="file:/%s\\Spinner@1x-1.0s-50px-50px.gif" ' 'width="40" height="40"></html>'], pwd);
    %use an inactive (not disabled) pushbutton to display the gif. Use CData instead of background color to flatten.
    loadingGraphics = uicontrol('style','push', 'pos',[460 187 40 40], 'String',gif,'enable','inactive','CData',...
        uint8(255*ones(40,40,3)*0.75));
    pause(0.5);
    UpdateProgressbar(d,'progressbar_primary', [0 0 1], 1/totalAnalysisSteps);

    %calculate neuronal response PSNR
    d.PSNR = CalculatePSNR_C2S(d);
    lowPSNRcount = sum(d.PSNR<18);
    %update PSNR filter TB
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','PSNRfilterTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String',...
        strcat('Neurons filtered due to low PSNR:',{' '},num2str(lowPSNRcount)));
    %update suite2p total neuron TB
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffCountTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String',...
        strcat('Total neurons in suite2p output:',{' '},num2str(size(d.PSNR,2))));
    %update final saved df/f neuron TB
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffSavedUnitsTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String',...
        strcat('Final number of neurons for which ΔF/F saved:',{' '},num2str(size(d.PSNR,2)-lowPSNRcount)));

    %calculate df/f
    deltaff = RunDff_C2S(d);
    UpdateProgressbar(d,'progressbar_primary', [0 0 1], 2/totalAnalysisSteps);

    %calculate spikes
    populationSpikeMatrix = GenerateBinarySpikeMatrixByOASIS_C2S(d,deltaff);
    [xCoord,yCoord] = Suite2pRoiCoordinateExporter_C2S(d);
    UpdateProgressbar(d,'progressbar_primary', [0 0 1], 3/totalAnalysisSteps);

    cd(d.saveAnalyzedData)
    cd('AnalyzedCalciumToSpikeData')
    dateTimeStamp = datetime('now');
    save(strcat('C2S_AnalyzedData_L',num2str(d.layers.currentLayer),'.mat'),'deltaff','populationSpikeMatrix','xCoord','yCoord','dateTimeStamp')

    pause(0.5)
    delete(loadingGraphics)

    cd(d.originalCodePath)
    %if analysis successfully run, then disable run analysis PB
    childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'BackgroundColor', 'w', 'ForegroundColor', [0.5 0.5 0.5]',...
        'FontWeight', 'bold', 'FontSize', 10, 'String','Finished');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'Enable','inactive');
    d = ToLog(d, "Analysis successful! Data Saved.");
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S(sprintf('Analysis run successfully.'));
    %update layer selection analyzed layer TB
    d.layers.analyzedLayers = d.layers.currentLayer;
    childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','AnalyzedLayerTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String',...
        strcat('Completely analyzed layers:',{' '},num2str(d.layers.analyzedLayers)));
    
elseif ismember(d.layers.analyzedLayers,d.layers.currentLayer) ~= 1 %means gui already run but layer not yet analyzed
    d = ToError_C2S(d, "No errors");
    d = ToLog_C2S(d, "--");
    childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'BackgroundColor', [1 1 1],...
        'FontWeight', 'bold','ForegroundColor', [1 0 0], 'FontSize', 12, 'String', 'Analyzing');
    gif = sprintf(['<html><img src="file:/%s\\Spinner@1x-1.0s-50px-50px.gif" ' 'width="40" height="40"></html>'], pwd);
    %use an inactive (not disabled) pushbutton to display the gif. Use CData instead of background color to flatten.
    loadingGraphics = uicontrol('style','push', 'pos',[460 187 40 40], 'String',gif,'enable','inactive','CData',...
        uint8(255*ones(40,40,3)*0.75));
    pause(0.5);
    UpdateProgressbar(d,'progressbar_primary', [0 0 1], 1/totalAnalysisSteps);

    %calculate neuronal response PSNR
    d.PSNR = CalculatePSNR_C2S(d);
    lowPSNRcount = sum(d.PSNR<18);
    %update PSNR filter TB
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','PSNRfilterTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String',...
        strcat('Neurons filtered due to low PSNR:',{' '},num2str(lowPSNRcount)));
    %update suite2p total neuron TB
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffCountTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String',...
        strcat('Total neurons in suite2p output:',{' '},num2str(size(d.PSNR,2))));
    %update final saved df/f neuron TB
    childrenArray = GUI_childrenFinder_C2S(d,'Analysis Output','DffSavedUnitsTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String',...
        strcat('Final number of neurons for which ΔF/F saved:',{' '},num2str(size(d.PSNR,2)-lowPSNRcount)));
    
    %calculate df/f
    deltaff = RunDff_C2S(d);
    UpdateProgressbar(d,'progressbar_primary', [0 0 1], 2/totalAnalysisSteps);

    %calculate spikes
    populationSpikeMatrix = GenerateBinarySpikeMatrixByOASIS_C2S(d,deltaff);
    [xCoord,yCoord] = Suite2pRoiCoordinateExporter_C2S(d);
    UpdateProgressbar(d,'progressbar_primary', [0 0 1], 3/totalAnalysisSteps);

    cd(d.saveAnalyzedData)
    cd('AnalyzedCalciumToSpikeData')
    dateTimeStamp = datetime('now');
    save(strcat('C2S_AnalyzedData_L',num2str(d.layers.currentLayer),'.mat'),'deltaff','populationSpikeMatrix','xCoord','yCoord','dateTimeStamp')

    pause(0.5)
    delete(loadingGraphics)

    cd(d.originalCodePath)
    %if analysis successfully run, then disable run analysis PB
    childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'BackgroundColor', 'w', 'ForegroundColor', [0.5 0.5 0.5]',...
        'FontWeight', 'bold', 'FontSize', 10, 'String','Finished');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'Enable','inactive');
    d = ToLog(d, "Analysis successful! Data Saved.");
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S(sprintf('Analysis run successfully.'));
    %update layer selection analyzed layer TB
    d.layers.analyzedLayers = [d.layers.analyzedLayers,d.layers.currentLayer];
    childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','AnalyzedLayerTB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String',...
        strcat('Completely analyzed layers:',{' '},num2str(d.layers.analyzedLayers)));
        
    
else %means layer is already analyzed
    d = ToError_C2S(d, "Layer already analyzed.");
    d = ToLog_C2S(d, "An error occured!!!");
    childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off');
end


guidata(d.source, d);