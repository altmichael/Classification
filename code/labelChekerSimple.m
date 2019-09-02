function labelPredict = labelChekerSimple(results)
    labelPredict=[];
    for l=1:size(results,1)
        labelPredict=[labelPredict,labelChecker(char(results(l)))];
    end
end