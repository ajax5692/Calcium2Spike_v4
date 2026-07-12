function populationSpikeMatrix = GenerateBinarySpikeMatrixByOASIS_C2S(d,deltaff)

%GenerateSpikeProbabilityAndBinaryMatrixByOASIS
%This function takes in the df/f values and evaluates the spike
%probabilities based on the OASIS module and the generates a binary 1/0
%matrix corresponding to the spikes.

childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','secondaryPBconsole');
totalCells = size(deltaff,1);

try
    oasis_setup

    try
        for cellIndex = 1:totalCells

            set(d.source.Children(childrenArray(1)).Children(childrenArray(2)),'String','Step 3/3: OASIS');
            UpdateProgressbar(d,'progressbar_secondary', [1 0 0], cellIndex/totalCells);
            pause(0.05)

            [c, s, options] = deconvolveCa(deltaff(cellIndex,:), 'thresholded', 'ar1', 'smin', -3, 'optimize_pars', true, 'optimize_b', true);

            populationSpikeProbability(cellIndex,:) = s;

            clear c s options

        end
    catch
        %pop-up msgbox
        beep;
        CustomMsgBox_C2S(sprintf('OASIS spike probability\ncalculation error.'));
    end

    childrenArray = GUI_childrenFinder_C2S(d,'Analysis','SetOASISthresholdEB');
    spikeThreshold = str2num(d.source.Children(childrenArray(1)).Children(childrenArray(2)).String);

    %Generate 1/0 spike matrix for the population

    try
        for cellIndex = 1:size(populationSpikeProbability,1)

            for frameIndex = 1:size(populationSpikeProbability,2)

                if populationSpikeProbability(cellIndex,frameIndex) > spikeThreshold

                    populationSpikeMatrix(cellIndex,frameIndex) = 1;

                else

                    populationSpikeMatrix(cellIndex,frameIndex) = 0;

                end
            end
        end
    catch
        %pop-up msgbox
        beep;
        CustomMsgBox_C2S(sprintf('OASIS spike thresholding error.'));
    end

catch
    d = ToError_C2S(d, "Error in OASIS calculation");
    d = ToLog(d, " Analysis interrupted");
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S(sprintf('OASIS module not loaded\nin Matlab set-path.'));
end
