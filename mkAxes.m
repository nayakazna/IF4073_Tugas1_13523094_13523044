function h = mkAxes(parent, pos, bgAxes, gridCol)
    h = axes(parent, 'Units', 'normalized', 'Position', pos, ...
        'Color', bgAxes, 'XColor', gridCol, 'YColor', gridCol);
end