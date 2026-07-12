function childrenArray = GUI_childrenFinder(varargin)

d = varargin{1};
msg1 = varargin{2};

for idx = 1:size(d.source.Children,1)
    try
        logicIdx1(idx) = strcmp(d.source.Children(idx).Title,msg1);
    catch
        logicId1x1(idx) = 0;
    end
end

child1 = find(logicIdx1 == 1);


msg2 = varargin{3};

if isempty(child1) == 0
    for idx = 1:size(d.source.Children(child1).Children,1)
        try
            logicIdx2(idx) = strcmp(d.source.Children(child1).Children(idx).Tag, msg2);
        catch
            logicId1x2(idx) = 0;
        end
    end

    child2 = find(logicIdx2 == 1);

    childrenArray = [child1,child2];

else
    for idx = 1:size(d.source.Children,1)
        try
            logicIdx2(idx) = strcmp(d.source.Children(idx).Tag, msg2);
        catch
            logicId1x2(idx) = 0;
        end
    end

    child2 = find(logicIdx2 == 1);

    childrenArray = [child1,child2];

end