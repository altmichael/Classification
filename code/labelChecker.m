function labelNum = labelChecker(str)

    if strcmp(str,'park')
        labelNum=1;
    end
    if strcmp(str,'hunt')
        labelNum=2;
    end
    if strcmp(str,'als')
        labelNum=3;
    end
    if strcmp(str,'control')
        labelNum=4;
    end

end