function imageEnhancementGUI()
% NB: sek yo ini masi placeholder, nanti dilanjut bikin fungsi-fungsi buat
% analisis mas

    BG_FIG   = [0.11 0.11 0.12];
    BG_PANEL = [0.16 0.16 0.18];
    BG_CTRL  = [0.22 0.22 0.24];
    BG_AXES  = [0.09 0.09 0.10];
    FG_TEXT  = [0.90 0.90 0.92];
    GRID_COL = [0.55 0.55 0.58];

    originalImg = [];
    activeImg = [];
    lastResult = [];
    refImg   = [];
    isColor  = false;
    activeLabels = {};
    sourceFile = '';
    lastMethod = '';
    lastParameters = '';
    methodHistory = struct('method', {}, 'parameters', {});

    fig = figure('Name', 'IF4073 - Image Enhancement GUI', ...
        'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none', ...
        'Units', 'normalized', 'Position', [0.03 0.05 0.94 0.88], ...
        'Color', BG_FIG);

    uicontrol(fig, 'Style', 'pushbutton', 'String', 'Load Image', ...
        'Units', 'normalized', 'Position', [0.01 0.945 0.10 0.045], ...
        'BackgroundColor', BG_CTRL, 'ForegroundColor', FG_TEXT, ...
        'Callback', @loadImageCallback);

    uicontrol(fig, 'Style', 'pushbutton', 'String', 'Use Last Result', ...
        'Units', 'normalized', 'Position', [0.54 0.945 0.13 0.045], ...
        'BackgroundColor', BG_CTRL, 'ForegroundColor', FG_TEXT, ...
        'Callback', @useLastResultCallback);

    uicontrol(fig, 'Style', 'pushbutton', 'String', 'Save Result', ...
        'Units', 'normalized', 'Position', [0.68 0.945 0.10 0.045], ...
        'BackgroundColor', BG_CTRL, 'ForegroundColor', FG_TEXT, ...
        'Callback', @saveResultCallback);

    uicontrol(fig, 'Style', 'pushbutton', 'String', 'Export Case', ...
        'Units', 'normalized', 'Position', [0.79 0.945 0.12 0.045], ...
        'BackgroundColor', BG_CTRL, 'ForegroundColor', FG_TEXT, ...
        'Callback', @exportCaseCallback);

    fileNameText = uicontrol(fig, 'Style', 'text', 'String', 'Belum ada citra dimuat', ...
        'Units', 'normalized', 'Position', [0.12 0.945 0.40 0.04], ...
        'HorizontalAlignment', 'left', 'BackgroundColor', BG_FIG, 'ForegroundColor', FG_TEXT);

    tg = uitabgroup(fig, 'Units', 'normalized', 'Position', [0.01 0.11 0.98 0.82]);

    tab1 = uitab(tg, 'Title', '1. Load & Analisis');
    tab2 = uitab(tg, 'Title', '2. Intensity Transformation');
    tab3 = uitab(tg, 'Title', '3. Histogram Equalization');
    tab4 = uitab(tg, 'Title', '4. Histogram Specification');
    tab5 = uitab(tg, 'Title', '5. Penapisan');
    tab6 = uitab(tg, 'Title', '6. Analisis & Ekspor');
    for t = [tab1, tab2, tab3, tab4, tab5, tab6]
        try, t.BackgroundColor = BG_PANEL; catch, end
    end

    logText = uicontrol(fig, 'Style', 'edit', 'Max', 2, 'Min', 0, ...
        'Units', 'normalized', 'Position', [0.01 0.01 0.98 0.085], ...
        'HorizontalAlignment', 'left', 'Enable', 'inactive', 'FontName', 'FixedWidth', ...
        'BackgroundColor', BG_CTRL, 'ForegroundColor', FG_TEXT, ...
        'String', {'Muat citra dulu mas, terus pilih tab.'});

    colX = [0.02, 0.35, 0.68];
    colW = 0.30;

    mkLabel(tab1, 'Citra Masukan', [colX(1) 0.93 colW 0.05], true, BG_PANEL, FG_TEXT);
    mkLabel(tab1, 'Histogram (R/G/B / Grayscale)', [colX(2) 0.93 colW 0.05], true, BG_PANEL, FG_TEXT);
    mkLabel(tab1, 'Fitur Citra', [colX(3) 0.93 colW 0.05], true, BG_PANEL, FG_TEXT);

    axInput     = mkAxes(tab1, [colX(1) 0.06 colW 0.85], BG_AXES, GRID_COL);
    inHistPanel = mkPanel(tab1, [colX(2) 0.06 colW 0.85], BG_PANEL, FG_TEXT);
    inFeatText  = mkTextBox(tab1, [colX(3) 0.06 colW 0.85], BG_CTRL, FG_TEXT);

    lblActive2 = mkLabel(tab2, 'Citra aktif: -', [0.02 0.905 0.60 0.045], false, BG_PANEL, FG_TEXT);
    activeLabels{end+1} = lblActive2;

    p2 = mkPanel(tab2, [0.02 0.64 0.96 0.24], BG_PANEL, FG_TEXT, 'Parameter Intensity Transformation');
    mkLabel(p2, 'Jenis:', [0.01 0.55 0.08 0.35], false, BG_PANEL, FG_TEXT);
    ddSubtype = mkPopup(p2, {'Negative', 'Log Transform', 'Power-Law (Gamma)', 'Contrast Stretching'}, ...
        [0.09 0.55 0.24 0.35], BG_CTRL, FG_TEXT, @toggleIntensityInputs);
    lblC = mkLabel(p2, 'c:', [0.35 0.55 0.05 0.35], false, BG_PANEL, FG_TEXT);
    edC = mkEdit(p2, '1', [0.40 0.55 0.06 0.35], BG_CTRL, FG_TEXT);
    lblGamma = mkLabel(p2, 'gamma:', [0.48 0.55 0.07 0.35], false, BG_PANEL, FG_TEXT);
    edGamma = mkEdit(p2, '1.0', [0.55 0.55 0.06 0.35], BG_CTRL, FG_TEXT);
    lblStretch = mkLabel(p2, 'stretch r1,s1,r2,s2:', [0.01 0.10 0.16 0.35], false, BG_PANEL, FG_TEXT);
    edStretch = mkEdit(p2, '70,0,180,255', [0.17 0.10 0.20 0.35], BG_CTRL, FG_TEXT);
    toggleIntensityInputs([], []);

    mkButton(tab2, 'Apply Enhancement', [0.02 0.58 0.20 0.05], BG_CTRL, FG_TEXT, @applyIntensity);

    mkLabel(tab2, 'Citra Hasil', [colX(1) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);
    mkLabel(tab2, 'Histogram Hasil', [colX(2) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);
    mkLabel(tab2, 'Fitur Hasil', [colX(3) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);

    axOut2     = mkAxes(tab2, [colX(1) 0.05 colW 0.46], BG_AXES, GRID_COL);
    histPanel2 = mkPanel(tab2, [colX(2) 0.05 colW 0.46], BG_PANEL, FG_TEXT);
    featText2  = mkTextBox(tab2, [colX(3) 0.05 colW 0.46], BG_CTRL, FG_TEXT);

    lblActive3 = mkLabel(tab3, 'Citra aktif: -', [0.02 0.905 0.60 0.045], false, BG_PANEL, FG_TEXT);
    activeLabels{end+1} = lblActive3;

    p3 = mkPanel(tab3, [0.02 0.64 0.96 0.24], BG_PANEL, FG_TEXT, 'Parameter Histogram Equalization');
    mkLabel(p3, 'Mode:', [0.01 0.55 0.08 0.35], false, BG_PANEL, FG_TEXT);
    ddModeEq = mkPopup(p3, {'Equalize kanal V (HSV)', 'Equalize per-kanal RGB'}, ...
        [0.10 0.55 0.32 0.35], BG_CTRL, FG_TEXT);

    mkButton(tab3, 'Apply Enhancement', [0.02 0.58 0.20 0.05], BG_CTRL, FG_TEXT, @applyEqualization);

    mkLabel(tab3, 'Citra Hasil', [colX(1) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);
    mkLabel(tab3, 'Histogram Hasil', [colX(2) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);
    mkLabel(tab3, 'Fitur Hasil', [colX(3) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);

    axOut3     = mkAxes(tab3, [colX(1) 0.05 colW 0.46], BG_AXES, GRID_COL);
    histPanel3 = mkPanel(tab3, [colX(2) 0.05 colW 0.46], BG_PANEL, FG_TEXT);
    featText3  = mkTextBox(tab3, [colX(3) 0.05 colW 0.46], BG_CTRL, FG_TEXT);

    lblActive4 = mkLabel(tab4, 'Citra aktif: -', [0.02 0.905 0.45 0.045], false, BG_PANEL, FG_TEXT);
    activeLabels{end+1} = lblActive4;

    p4 = mkPanel(tab4, [0.02 0.64 0.96 0.24], BG_PANEL, FG_TEXT, 'Parameter Histogram Specification');
    lblRefFile = mkLabel(p4, 'Referensi: -', [0.23 0.55 0.35 0.35], false, BG_PANEL, FG_TEXT);
    mkButton(p4, 'Load Citra Referensi', [0.01 0.55 0.20 0.35], BG_CTRL, FG_TEXT, @loadRefCallback);
    mkLabel(p4, 'Mode:', [0.01 0.10 0.08 0.35], false, BG_PANEL, FG_TEXT);
    ddModeSpec = mkPopup(p4, {'Match kanal V (HSV)', 'Match per-kanal RGB'}, ...
        [0.10 0.10 0.32 0.35], BG_CTRL, FG_TEXT);

    mkButton(tab4, 'Apply Enhancement', [0.02 0.58 0.20 0.05], BG_CTRL, FG_TEXT, @applySpecification);

    mkLabel(tab4, 'Citra Hasil', [colX(1) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);
    mkLabel(tab4, 'Histogram Hasil', [colX(2) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);
    mkLabel(tab4, 'Fitur Hasil', [colX(3) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);

    axOut4     = mkAxes(tab4, [colX(1) 0.05 colW 0.46], BG_AXES, GRID_COL);
    histPanel4 = mkPanel(tab4, [colX(2) 0.05 colW 0.46], BG_PANEL, FG_TEXT);
    featText4  = mkTextBox(tab4, [colX(3) 0.05 colW 0.46], BG_CTRL, FG_TEXT);

    lblActive5 = mkLabel(tab5, 'Citra aktif: -', [0.02 0.905 0.60 0.045], false, BG_PANEL, FG_TEXT);
    activeLabels{end+1} = lblActive5;

    p5 = mkPanel(tab5, [0.02 0.64 0.96 0.24], BG_PANEL, FG_TEXT, 'Parameter Penapisan');
    mkLabel(p5, 'Kategori:', [0.01 0.55 0.09 0.35], false, BG_PANEL, FG_TEXT);
    ddCategory = mkPopup(p5, {'Linear (Konvolusi)', 'Non-linear (Median)'}, ...
        [0.10 0.55 0.22 0.35], BG_CTRL, FG_TEXT, @toggleFilterCategory);

    subLinear = mkPanel(p5, [0.34 0.05 0.64 0.90], BG_PANEL, FG_TEXT);
    mkLabel(subLinear, 'Kernel:', [0.01 0.55 0.10 0.35], false, BG_PANEL, FG_TEXT);
    ddKernel = mkPopup(subLinear, {'Average', 'Gaussian', 'Sharpen', 'Sobel-X', 'Sobel-Y'}, ...
        [0.11 0.55 0.28 0.35], BG_CTRL, FG_TEXT, @toggleKernelInputs);
    lblKsize = mkLabel(subLinear, 'Ukuran:', [0.41 0.55 0.10 0.35], false, BG_PANEL, FG_TEXT);
    edKsize = mkEdit(subLinear, '3', [0.51 0.55 0.06 0.35], BG_CTRL, FG_TEXT);
    lblSigma = mkLabel(subLinear, 'sigma:', [0.01 0.10 0.08 0.35], false, BG_PANEL, FG_TEXT);
    edSigma = mkEdit(subLinear, '1.0', [0.09 0.10 0.06 0.35], BG_CTRL, FG_TEXT);
    toggleKernelInputs([], []);

    subMedian = mkPanel(p5, [0.34 0.05 0.64 0.90], BG_PANEL, FG_TEXT);
    mkLabel(subMedian, 'Ukuran window:', [0.01 0.55 0.18 0.35], false, BG_PANEL, FG_TEXT);
    edWsize = mkEdit(subMedian, '3', [0.20 0.55 0.06 0.35], BG_CTRL, FG_TEXT);
    set(subMedian, 'Visible', 'off');

    mkButton(tab5, 'Apply Enhancement', [0.02 0.58 0.20 0.05], BG_CTRL, FG_TEXT, @applyFiltering);

    mkLabel(tab5, 'Citra Hasil', [colX(1) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);
    mkLabel(tab5, 'Histogram Hasil', [colX(2) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);
    mkLabel(tab5, 'Fitur Hasil', [colX(3) 0.52 colW 0.045], true, BG_PANEL, FG_TEXT);

    axOut5     = mkAxes(tab5, [colX(1) 0.05 colW 0.46], BG_AXES, GRID_COL);
    histPanel5 = mkPanel(tab5, [colX(2) 0.05 colW 0.46], BG_PANEL, FG_TEXT);
    featText5  = mkTextBox(tab5, [colX(3) 0.05 colW 0.46], BG_CTRL, FG_TEXT);

    mkLabel(tab6, 'Identifikasi Masalah Visual', [0.02 0.88 0.45 0.04], true, BG_PANEL, FG_TEXT);
    problemText = mkMultilineEdit(tab6, [0.02 0.65 0.45 0.22], BG_CTRL, FG_TEXT);
    mkLabel(tab6, 'Tujuan Perbaikan', [0.53 0.88 0.45 0.04], true, BG_PANEL, FG_TEXT);
    objectiveText = mkMultilineEdit(tab6, [0.53 0.65 0.45 0.22], BG_CTRL, FG_TEXT);
    mkLabel(tab6, 'Alasan Metode dan Parameter', [0.02 0.57 0.45 0.04], true, BG_PANEL, FG_TEXT);
    rationaleText = mkMultilineEdit(tab6, [0.02 0.34 0.45 0.22], BG_CTRL, FG_TEXT);
    mkLabel(tab6, 'Penilaian Hasil dan Artefak', [0.53 0.57 0.45 0.04], true, BG_PANEL, FG_TEXT);
    assessmentText = mkMultilineEdit(tab6, [0.53 0.34 0.45 0.22], BG_CTRL, FG_TEXT);
    mkLabel(tab6, 'Riwayat Metode', [0.02 0.27 0.96 0.04], true, BG_PANEL, FG_TEXT);
    historyText = mkTextBox(tab6, [0.02 0.05 0.96 0.21], BG_CTRL, FG_TEXT);

    function loadImageCallback(~, ~)
        [f, p] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', 'Image Files'});
        if isequal(f, 0), return; end
        raw = imread(fullfile(p, f));
        originalImg = double(raw);
        isColor = (ndims(originalImg) == 3) && (size(originalImg, 3) >= 3);
        if isColor, originalImg = originalImg(:, :, 1:3); end
        activeImg = originalImg;
        lastResult = [];
        refImg = [];
        sourceFile = f;
        lastMethod = '';
        lastParameters = '';
        methodHistory = struct('method', {}, 'parameters', {});

        set(fileNameText, 'String', f);
        for k = 1:numel(activeLabels)
            set(activeLabels{k}, 'String', sprintf('Citra aktif: %s', f));
        end

        axes(axInput);
        imshow(uint8(originalImg));
        set(axInput, 'Color', BG_AXES, 'XColor', GRID_COL, 'YColor', GRID_COL);
        drawHistogramPanel(inHistPanel, originalImg, isColor, BG_AXES, GRID_COL);
        set(inFeatText, 'String', featureString(originalImg, isColor));

        refreshHistory();
        setLog('Citra dimuat mas.');
    end

    function loadRefCallback(~, ~)
        if isempty(activeImg)
            warndlg('Muat citra masukan dulu.'); return;
        end
        [f, p] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', 'Image Files'});
        if isequal(f, 0), return; end
        raw = imread(fullfile(p, f));
        refImg = double(raw);
        if ndims(refImg) == 3, refImg = refImg(:, :, 1:3); end
        set(lblRefFile, 'String', sprintf('Referensi: %s', f));
    end

    function toggleFilterCategory(~, ~)
        if get(ddCategory, 'Value') == 1
            set(subLinear, 'Visible', 'on'); set(subMedian, 'Visible', 'off');
        else
            set(subLinear, 'Visible', 'off'); set(subMedian, 'Visible', 'on');
        end
    end

    function toggleIntensityInputs(~, ~)
        subtypeList = get(ddSubtype, 'String');
        subtype = subtypeList{get(ddSubtype, 'Value')};
        set(lblC, 'Visible', 'off'); set(edC, 'Visible', 'off');
        set(lblGamma, 'Visible', 'off'); set(edGamma, 'Visible', 'off');
        set(lblStretch, 'Visible', 'off'); set(edStretch, 'Visible', 'off');

        switch subtype
            case 'Log Transform'
                set(lblC, 'Visible', 'on'); set(edC, 'Visible', 'on');
            case 'Power-Law (Gamma)'
                set(lblC, 'Visible', 'on'); set(edC, 'Visible', 'on');
                set(lblGamma, 'Visible', 'on'); set(edGamma, 'Visible', 'on');
            case 'Contrast Stretching'
                set(lblStretch, 'Visible', 'on'); set(edStretch, 'Visible', 'on');
        end
    end

    function toggleKernelInputs(~, ~)
        kernelList = get(ddKernel, 'String');
        kernelName = kernelList{get(ddKernel, 'Value')};
        set(lblKsize, 'Visible', 'off'); set(edKsize, 'Visible', 'off');
        set(lblSigma, 'Visible', 'off'); set(edSigma, 'Visible', 'off');

        switch kernelName
            case 'Average'
                set(lblKsize, 'Visible', 'on'); set(edKsize, 'Visible', 'on');
            case 'Gaussian'
                set(lblKsize, 'Visible', 'on'); set(edKsize, 'Visible', 'on');
                set(lblSigma, 'Visible', 'on'); set(edSigma, 'Visible', 'on');
        end
    end

    function applyIntensity(~, ~)
        if ~checkInputLoaded(), return; end
        try
            subtypeList = get(ddSubtype, 'String');
            subtype = subtypeList{get(ddSubtype, 'Value')};
            c = str2double(get(edC, 'String'));
            gammaVal = str2double(get(edGamma, 'String'));
            stretchVals = [];
            if strcmp(subtype, 'Contrast Stretching')
                stretchVals = str2num(get(edStretch, 'String')); %#ok<ST2NM>
            end

            result = applyPerChannel(activeImg, isColor, ...
                @(ch) intensityTransform(ch, subtype, c, gammaVal, stretchVals));
            showResult(axOut2, histPanel2, featText2, result, ...
                sprintf('Intensity Transformation - %s', subtype), intensityParameters(subtype, c, gammaVal, stretchVals));
        catch ME
            errordlg(ME.message, 'Parameter tidak valid');
        end
    end

    function applyEqualization(~, ~)
        if ~checkInputLoaded(), return; end
        try
            modeList = get(ddModeEq, 'String');
            mode = modeList{get(ddModeEq, 'Value')};
            if isColor && contains(mode, 'kanal V')
                result = equalizeViaVChannel(activeImg);
            else
                result = applyPerChannel(activeImg, isColor, @histeq_);
            end
            showResult(axOut3, histPanel3, featText3, result, sprintf('Histogram Equalization - %s', mode), ...
                sprintf('Mode: %s', mode));
        catch ME
            errordlg(ME.message, 'Enhancement gagal');
        end
    end

    function applySpecification(~, ~)
        if ~checkInputLoaded(), return; end
        if isempty(refImg)
            warndlg('Muat citra referensi dulu.'); return;
        end
        try
            modeList = get(ddModeSpec, 'String');
            mode = modeList{get(ddModeSpec, 'Value')};
            if isColor && contains(mode, 'kanal V')
                result = specifyViaVChannel(activeImg, refImg);
            else
                result = applyPerChannelWithRef(activeImg, refImg, isColor, @imhistmatch_);
            end
            showResult(axOut4, histPanel4, featText4, result, sprintf('Histogram Specification - %s', mode), ...
                sprintf('Mode: %s; Referensi: %s', mode, get(lblRefFile, 'String')));
        catch ME
            errordlg(ME.message, 'Enhancement gagal');
        end
    end

    function applyFiltering(~, ~)
        if ~checkInputLoaded(), return; end
        try
            if get(ddCategory, 'Value') == 1
                kernelList = get(ddKernel, 'String');
                kernelName = kernelList{get(ddKernel, 'Value')};
                ksize = 3;
                sigma = 1;
                if strcmp(kernelName, 'Average') || strcmp(kernelName, 'Gaussian')
                    ksize = round(str2double(get(edKsize, 'String')));
                    if mod(ksize, 2) == 0, ksize = ksize + 1; end
                end
                if strcmp(kernelName, 'Gaussian')
                    sigma = str2double(get(edSigma, 'String'));
                end
                kernel = buildKernel(kernelName, ksize, sigma);
                result = applyPerChannel(activeImg, isColor, @(ch) conv2(ch, kernel, 'same'));
                methodStr = sprintf('Filter Linear - %s', kernelName);
                parameterStr = filterParameters(kernelName, ksize, sigma);
            else
                wsize = round(str2double(get(edWsize, 'String')));
                if mod(wsize, 2) == 0, wsize = wsize + 1; end
                result = applyPerChannel(activeImg, isColor, @(ch) medianFilter2D(ch, wsize));
                methodStr = 'Filter Median';
                parameterStr = sprintf('Ukuran window: %d', wsize);
            end
            showResult(axOut5, histPanel5, featText5, result, methodStr, parameterStr);
        catch ME
            errordlg(ME.message, 'Parameter tidak valid');
        end
    end

    function useLastResultCallback(~, ~)
        if isempty(lastResult)
            warndlg('Jalankan enhancement terlebih dahulu.'); return;
        end
        activeImg = lastResult;
        methodHistory(end+1) = struct('method', lastMethod, 'parameters', lastParameters);
        for k = 1:numel(activeLabels)
            set(activeLabels{k}, 'String', sprintf('Citra aktif: %s (%d tahap)', sourceFile, numel(methodHistory)));
        end
        refreshHistory();
        setLog(sprintf('Hasil digunakan sebagai citra aktif: %s', lastMethod));
    end

    function saveResultCallback(~, ~)
        if isempty(activeImg)
            warndlg('Muat citra masukan dulu.'); return;
        end
        imgToSave = activeImg;
        if ~isempty(lastResult), imgToSave = lastResult; end
        [baseName, ~, ~] = fileparts(sourceFile);
        defaultName = [baseName '_enhanced.png'];
        [f, p] = uiputfile({'*.png', 'PNG Image (*.png)'; '*.jpg', 'JPEG Image (*.jpg)'; '*.tif', 'TIFF Image (*.tif)'}, ...
            'Simpan Citra Hasil', defaultName);
        if isequal(f, 0), return; end
        imwrite(uint8(imgToSave), fullfile(p, f));
        setLog(sprintf('Citra hasil disimpan: %s', f));
    end

    function exportCaseCallback(~, ~)
        if isempty(originalImg)
            warndlg('Muat citra masukan dulu.'); return;
        end
        [baseName, ~, ~] = fileparts(sourceFile);
        [f, p] = uiputfile({'*.mat', 'MATLAB Case Record (*.mat)'}, ...
            'Ekspor Catatan Kasus', [baseName '_case.mat']);
        if isequal(f, 0), return; end

        finalImg = activeImg;
        if ~isempty(lastResult), finalImg = lastResult; end
        caseRecord = struct();
        caseRecord.sourceFile = sourceFile;
        caseRecord.createdAt = datestr(now, 30);
        caseRecord.originalImage = originalImg;
        caseRecord.originalHistogram = image_histogram(originalImg);
        caseRecord.originalFeatures = featureString(originalImg, isColor);
        caseRecord.activeImage = activeImg;
        caseRecord.finalImage = finalImg;
        caseRecord.finalHistogram = image_histogram(finalImg);
        caseRecord.finalFeatures = featureString(finalImg, isColor);
        caseRecord.lastMethod = lastMethod;
        caseRecord.lastParameters = lastParameters;
        caseRecord.methodHistory = methodHistory;
        caseRecord.analysis = struct( ...
            'visualProblem', get(problemText, 'String'), ...
            'improvementObjective', get(objectiveText, 'String'), ...
            'methodRationale', get(rationaleText, 'String'), ...
            'resultAssessment', get(assessmentText, 'String'));
        save(fullfile(p, f), 'caseRecord');
        setLog(sprintf('Catatan kasus diekspor: %s', f));
    end

    function ok = checkInputLoaded()
        ok = ~isempty(activeImg);
        if ~ok, warndlg('Muat citra masukan dulu mas.'); end
    end

    function showResult(axHandle, histPanelHandle, featTextHandle, result, methodStr, parameterStr)
        try
            result = max(0, min(255, result));
            lastResult = result;
            lastMethod = methodStr;
            lastParameters = parameterStr;
            axes(axHandle);
            imshow(uint8(result));
            set(axHandle, 'Color', BG_AXES, 'XColor', GRID_COL, 'YColor', GRID_COL);
            drawHistogramPanel(histPanelHandle, result, isColor, BG_AXES, GRID_COL);
            set(featTextHandle, 'String', [{'Metode: ' methodStr}, {'Parameter: ' parameterStr}, {''}, featureString(result, isColor)]);
            refreshHistory();
            setLog(sprintf('Selesai: %s', methodStr));
        catch ME
            errordlg(sprintf('Error: %s', ME.message));
        end
    end

    function refreshHistory()
        entries = {};
        if ~isempty(sourceFile)
            entries{end+1} = sprintf('Sumber: %s', sourceFile);
        end
        for index = 1:numel(methodHistory)
            entries{end+1} = sprintf('%d. %s | %s', index, methodHistory(index).method, methodHistory(index).parameters);
        end
        if ~isempty(lastResult)
            entries{end+1} = sprintf('Pratinjau: %s | %s', lastMethod, lastParameters);
        end
        if isempty(entries), entries = {'Belum ada citra dimuat.'}; end
        set(historyText, 'String', entries);
    end

    function parameters = intensityParameters(subtype, c, gammaVal, stretchVals)
        switch subtype
            case 'Log Transform'
                parameters = sprintf('c: %.4g', c);
            case 'Power-Law (Gamma)'
                parameters = sprintf('c: %.4g; gamma: %.4g', c, gammaVal);
            case 'Contrast Stretching'
                parameters = sprintf('r1,s1,r2,s2: %s', mat2str(stretchVals));
            otherwise
                parameters = 'Tidak ada parameter tambahan';
        end
    end

    function parameters = filterParameters(kernelName, kernelSize, sigma)
        switch kernelName
            case 'Gaussian'
                parameters = sprintf('Kernel: %dx%d; sigma: %.4g', kernelSize, kernelSize, sigma);
            case 'Average'
                parameters = sprintf('Kernel: %dx%d', kernelSize, kernelSize);
            otherwise
                parameters = 'Kernel tetap: 3x3';
        end
    end

    function setLog(msg)
        set(logText, 'String', {msg});
    end

    function s = featureString(img, colorFlag)
        if colorFlag
            gray = rgb2gray(img);
        else
            gray = img;
        end
        counts = image_histogram(gray);
        total = sum(counts);
        s = { ...
            sprintf('Ukuran  : %d x %d', size(gray, 1), size(gray, 2)), ...
            sprintf('Min     : %.1f', min(gray(:))), ...
            sprintf('Max     : %.1f', max(gray(:))), ...
            sprintf('Mean    : %.2f', mean(gray(:))), ...
            sprintf('Std Dev : %.2f', std(gray(:))), ...
            '' ...
            };
        if total > 0
            p = counts / total;
            ent = -sum(p(p > 0) .* log2(p(p > 0)));
            s{end+1} = sprintf('Entropy : %.3f bit', ent);
        end
    end

    function drawHistogramPanel(panelHandle, img, colorFlag, bgAxesCol, gridCol)
        delete(get(panelHandle, 'Children'));
        if colorFlag
            colors = {[0.95 0.40 0.40], [0.40 0.90 0.40], [0.45 0.65 1.00]};
            labels = {'R', 'G', 'B'};
            for k = 1:3
                ax = axes(panelHandle, 'Units', 'normalized', ...
                    'Position', [0.10, 1 - k * 0.32, 0.86, 0.27], ...
                    'Color', bgAxesCol, 'XColor', gridCol, 'YColor', gridCol);
                counts = image_histogram(img(:, :, k));
                bar(ax, 0:255, counts, 'FaceColor', colors{k}, 'EdgeColor', 'none', 'BarWidth', 1);
                xlim(ax, [0 255]);
                ylabel(ax, labels{k}, 'Color', gridCol);
                if k < 3, set(ax, 'XTickLabel', []); end
            end
        else
            ax = axes(panelHandle, 'Units', 'normalized', 'Position', [0.10 0.12 0.86 0.80], ...
                'Color', bgAxesCol, 'XColor', gridCol, 'YColor', gridCol);
            counts = image_histogram(img);
            bar(ax, 0:255, counts, 'FaceColor', [0.75 0.75 0.78], 'EdgeColor', 'none', 'BarWidth', 1);
            xlim(ax, [0 255]);
        end
    end

end
