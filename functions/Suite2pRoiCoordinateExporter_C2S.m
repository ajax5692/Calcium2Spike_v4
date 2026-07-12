function [xCoord,yCoord] = Suite2pRoiCoordinateExporter_C2S(d)

%This function exports the coordinates, i.e., the centroids of the ROIs
%detected by Suite2p and gives them an an x and y coordinate output

load(strcat(d.FallDataPath,d.FallFilename))

cellCounter = 1;
count = 0;

try
    for cellIndex = 1:size(stat,2)


        if isCell(cellIndex,1) == 1

            count = count + 1;

            if 4*std(d.PSNR) > min(d.PSNR)

                if d.PSNR(count) > 18 & d.PSNR(count) < 4*std(d.PSNR)

                    xCoord(cellCounter) = double(stat{1,cellIndex}.med(1,1));
                    yCoord(cellCounter) = double(stat{1,cellIndex}.med(1,2));

                    cellCounter = cellCounter + 1;

                elseif d.PSNR(count) > 18

                    xCoord(cellCounter) = double(stat{1,cellIndex}.med(1,1));
                    yCoord(cellCounter) = double(stat{1,cellIndex}.med(1,2));

                    cellCounter = cellCounter + 1;

                else
                    continue
                end

            else

                if d.PSNR(count) > 18

                    xCoord(cellCounter) = double(stat{1,cellIndex}.med(1,1));
                    yCoord(cellCounter) = double(stat{1,cellIndex}.med(1,2));

                    cellCounter = cellCounter + 1;

                else
                    continue
                end

            end

        else
            continue
        end

    end

catch
    %pop-up msgbox
    beep;
    CustomMsgBox_C2S(sprintf('Coordinate export from Suite2p\nencountered an error.'));
    d = ToError_C2S(d, "Neuronal coordinate export from suite2p output failed.");
    d = ToLog_C2S(d, "An error occured!!!");
end