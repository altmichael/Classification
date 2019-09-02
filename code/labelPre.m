function [trainAcc,numTrain] = labelPre(group,trainAcc,numTrain,results,ind,i,labelReal,labelPredict,b)

if isempty(labelPredict)
    for l=1:size(results,1)
        labelPredict=[labelPredict,labelChecker(char(results(l)))];
    end
    if b==1
        labelPredict=labelPredict';
        mark=1;
    else
        mark=2;
    end
else 
    labelPredict=results;
    mark=1;
end

trainAcc=trainAcc+sum(labelPredict==labelReal);
numTrain=numTrain+size(labelReal,mark);

end