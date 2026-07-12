function callback_suite2pLayerSelection_C2S(hO, ed)

% figureCalcium2Spike_GUI = ancestor(hO,'figure');      % get figure that owns guidata
d = guidata(hO);

childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionDD');
DD_value = d.source.Children(childrenArray(1)).Children(childrenArray(2)).Value;

if DD_value ~= 1
    d.layers.currentLayer = DD_value - 1;
    if isempty(d.layers.analyzedLayers) == 1 %when gui is run first time
        %update layer selection checkmark color
        childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionCheckmark');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'ForegroundColor',[0.21 0.70 0.21]);
        %update current layer TB
        childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','CurrentLayerTB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
            'String',strcat('Selected layer:',{' '},num2str(d.layers.currentLayer)));

        d = ToError_C2S(d, "No errors");
        d = ToLog_C2S(d, "Layer successfully selected");

        childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallSelectionPB');
        set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'on');
        
    else %if gui was already running before, check if data was already analyzed
        if ismember(d.layers.analyzedLayers,d.layers.currentLayer) ~= 1 %means layer not yet analyzed
            d.layers.currentLayer = DD_value - 1;
            d = ToError_C2S(d, " No errors");
            d = ToLog_C2S(d, "Layer successfully selected");

            %update layer selection checkmark color
            childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionCheckmark');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
                'ForegroundColor',[0.21 0.70 0.21]);
            %update current layer TB
            childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','CurrentLayerTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
                'String',strcat('Selected layer:',{' '},num2str(d.layers.currentLayer)));

            %enable the Fall selection PB
            childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallSelectionPB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'on');

            %disable run analysis PB
            childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','RunAnalysisPB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off',...
                'BackgroundColor', 'w', 'ForegroundColor', 'k', 'FontWeight', 'normal', 'FontSize', 10,...
                'String','Run analysis');

            %update Fall.mat file selection checkmark color
            childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallCheckmark');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
                'ForegroundColor',[0.9 0.3 0.3]);

            %reset primary and secondary progress bar
            UpdateProgressbar(d,'progressbar_primary', [0 0 1], 0);
            UpdateProgressbar(d,'progressbar_secondary', [0 0 1], 0);

        else %means layer is already analyzed
            d = ToError_C2S(d, "Layer already analyzed!!");
            d = ToLog_C2S(d, "An error occured!!!");
            %pop-up msgbox
            beep;
            CustomMsgBox_C2S('Layer already analyzed!');
            %update layer selection checkmark color
            childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionCheckmark');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
                'ForegroundColor',[0.9 0.3 0.3]);
            %update current layer TB
            childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','CurrentLayerTB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
                'String',strcat('Selected layer:',{' '},num2str(d.layers.currentLayer)));

            childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallSelectionPB');
            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable', 'off');
            
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
    end
else %user selected the incorrect DD option ('Select layer')
    d = ToError_C2S(d, "Please select a correct layer.");
    d = ToLog_C2S(d, "An error occured!!!");
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S('Please select a correct layer!');
    %layer selection space card - update layer selection checkmark color
    childrenArray = GUI_childrenFinder_C2S(d,'Layer selection','LayerSelectionCheckmark');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),...
        'ForegroundColor',[[0.9 0.3 0.3]]);
    % - suite2p Fall space card
    %disable pushbutton
    childrenArray = GUI_childrenFinder_C2S(d,'Suite2p Fall.mat file','FallSelectionPB');
    set(d.source.Children(childrenArray(1)).Children(childrenArray(2)), 'Enable','off');
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