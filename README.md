# Calcium2Spike

Calcium2Spike is a MATLAB-based Graphical User Interface (GUI) designed to streamline the processing of calcium imaging data. It integrates microscope recording parameters with [Suite2P](https://github.com/Mouseland/suite2p) output, filters regions of interest (ROIs), and performs spike deconvolution using [OASIS](https://github.com/zhoupc/OASIS_matlab).

## Features
<img width="1346" height="788" alt="image" src="https://github.com/user-attachments/assets/d7bef713-b21f-451c-b702-b380ca51f181" />


* **Project Management:** Easily define output directories and load your microscope data files (MESc).
* **Suite2p Integration:** Directly load `Fall.mat` files and select specific imaging layers for targeted analysis.
* **Automated Parameter Extraction:** Automatically extracts frame rates, plane counts, time steps, and ROI counts from your loaded files.
* **OASIS Deconvolution:** Built-in integration for spike inference with customizable thresholding.
* **Quality Control:** Filters out low-quality neurons based on Peak Signal-to-Noise Ratio (PSNR).
* **Data Pooling:** Consolidate your analyzed multi-plane data across sessions into a single `.mat` file.

## Prerequisites

* MATLAB (preferably R2020b and above)
* [Suite2P](https://github.com/MouseLand/suite2p) (For generating the `Fall.mat` input files)
* [OASIS](https://github.com/zhoupc/OASIS_matlab) MATLAB implementation

*Note:* Signal Processing Toolbox and Statistics Toolbox are required to run this GUI.

## Usage Guide

1. **Launch the GUI:** Run `Calcium2Spike_GUI_v4.m` in your MATLAB command window.
2. **Set Project Locations:** In the *Project management* panel, click **Browse** under *Save location* to set your output directory. This is where the analyzed output files will be saved.
3. **Load Microscope Data:** Click **Browse** under *MESc file* to load your recording metadata. The GUI will automatically populate the *MESc Params* (FrameRate, Planes, TimeSteps).
4. **Load Suite2p Data:** In the *Suite2p output management* panel, select your `Fall.mat` file. Choose the specific layer you wish to analyze from the dropdown menu.
5. **Configure Analysis:** In the *Analysis* panel, adjust the OASIS threshold if necessary (must be < 0.5, default is 0).
6. **Run:** Click **Run analysis**. Monitor progress via the overall and step-specific loading bars. The output section will detail the number of neurons processed and filtered.
7. **Pool Data:** Once analyses are complete, check **Ready to pool?** and click **Pool Data** to aggregate your results, which will stack the multi-layer analysis into a single mat file.

*Note:* You can explore the interface by hovering the mouse cursor over some of the buttons, checkboxes and and editable text fields to learn more about their specific functions.

## Output

Once the analysis and data pooling steps are complete, the GUI saves the final aggregated results as a `.mat` file in your specified project save location.
