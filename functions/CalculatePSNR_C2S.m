function PSNR = CalculatePSNR_C2S(d)

%This is done to remove cells having PSNR values > 4SD or <18 dB.
%PSNR value is calculated using the formula:
%PSNR = 20*log10max(F-Fneu/std(Fneu));

load(strcat(d.FallDataPath,d.FallFilename))


%Calculating PSNR values for all cells. This is done to remove cells having
%PSNR values > 4SD of all the PSNR values

PSNRcounter = 1;

childrenArray = GUI_childrenFinder_C2S(d,'CoreAnalysis','secondaryPBconsole');

try
    for cellIndex = 1:size(F,1)

        d.source.Children(childrenArray(1)).Children(childrenArray(2)).String = 'Step 1/3: PSNR';
        UpdateProgressbar(d,'progressbar_secondary', [1 0 0], cellIndex/size(F,1));
        pause(0.05)

        if isCell(cellIndex,1) == 1

            PSNR(PSNRcounter) = 20 * log10(max(F(cellIndex,:)-Fneu(cellIndex,:))/std(Fneu(cellIndex,:)));
            PSNRcounter = PSNRcounter + 1;

        else
            continue
        end
    end
catch
    d = ToError_C2S(d, "Error in PSNR calculation");
    d = ToLog(d, "Analysis interrupted");
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S(sprintf('Analysis interrupted due to\nPSNR calculation error.'));
end