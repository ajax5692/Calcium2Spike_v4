function callback_PoolData_C2S(hO, ed)

figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);

cd(strcat(d.saveAnalyzedData,'\AnalyzedCalciumToSpikeData'))

analyzedFiles = dir('*.mat');

try
    for layerIndex = 1:size(analyzedFiles,1)

        load(analyzedFiles(layerIndex).name)

        spikeData(layerIndex).layer = populationSpikeMatrix;
        dffData(layerIndex).layer = deltaff;

        roiCoordData(layerIndex,1).layer = xCoord;
        roiCoordData(layerIndex,2).layer = yCoord;

        clear populationSpikeMatrix deltaff xCoord yCoord

    end

    dateTimeStamp = datetime('now');

    layerWiseData.dff = dffData;
    layerWiseData.spike = spikeData;
    layerWiseData.roi = roiCoordData;

    stackedLayerData.dff = vertcat(dffData(:).layer);
    stackedLayerData.spike = vertcat(spikeData(:).layer);
    stackedLayerData.roi = [horzcat(roiCoordData(:,1).layer); horzcat(roiCoordData(:,2).layer);];


    save('layerWiseData.mat','layerWiseData','dateTimeStamp')
    save('stackedlayerData.mat','stackedLayerData','dateTimeStamp')
    cd(d.originalCodePath)

    childrenArray = GUI_childrenFinder_C2S(d,'Analysis','PoolDataPB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'BackgroundColor', [0 1 1],...
        'ForegroundColor', [0 0 0], 'String', 'Data Pooled', 'Enable', 'off');
catch
    d = ToError_C2S(d, "Pooling data error.");
    d = ToLog_C2S(d, "An error occured!!!");
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S(sprintf('Pooling data failed.\nPlease check frame\nnumbers across layers.'));
end

