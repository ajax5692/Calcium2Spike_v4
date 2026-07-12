function data = InitializeEmptyDataStructure_C2S_GUI(coreProcessorfileLocation)
%data = InitializeEmptyDataStructure - initializes an empty data structure
%to be embedded in a GUI of the EnsembleGUI code.


data.originalCodePath = coreProcessorfileLocation;
data.PSNR = [];
data.numlayers = [];
data.totalCells = [];
data.cellsPassingPSNRfilter = [];
data.unitsHavingCoordExported = [];
data.saveAnalyzedData = [];
data.mescDataLocation = [];
data.mescDataName = [];
data.mescFrameRate = [];
data.FallDataPath = [];
data.FallFilename = [];

data.layers.currentLayer = [];
data.layers.analyzedLayers = [];

data.errors.latestReturned = "No errors.";

data.logging.latestReturned = "<null>";

data.GUI.errorConsole = [];
data.GUI.loggingConsole = [];
data.GUI.pushButtons = [];
data.GUI.rasterAxes = [];

data.GUI.checkmarks.values.savelocationspecified = [];
data.GUI.checkmarks.values.mescfileselected = [];
data.GUI.checkmarks.values.layerselected = [];
data.GUI.checkmarks.values.fallfileselected = [];
data.GUI.checkmarksDynamicUpdate = [];

data.external.isPresent = 0;
data.external.binarySpikeMatrixPath =[];
data.external.roiCoordinatesPath = [];
data.external.sessionStructPath = [];
