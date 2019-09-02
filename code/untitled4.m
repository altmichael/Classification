load('TrainingDataClinicalAndGait.mat')
load('data.mat')
subjectdescriptionParTrainPerm(:,7:13)=[]
group=findgroups(subjectdescriptionParTrainPerm(:,1));
group=[]
for k=1:size(subjectdescriptionParTrainPerm,1)
    lab=table2cell(subjectdescriptionParTrainPerm(k,1));
    group=[group,labelChecker(char(lab{1}))];
end
subjects=[find(group==1,3);find(group==2,3);find(group==3,3);find(group==4,3)]
subjectsall={find(group==1);find(group==2);find(group==3);find(group==4)}
% colors={'b','r','y','k'}
% for i=2:13
%     figure;
%     hold on;
%    for j=1:4
%        for k=1:3
%            plot(GateTrainDataCellPerm{subjects(j,k)}(:,i),'color',colors{j}); 
%        end
%    end
%    saveas(gcf,[num2str(i-1),'cellperm.jpg']);
%    close;
% end
average=[];
for j=1:4
    for i=1:12
        for k=1:size(subjectsall{j},2)
            average(j,k,i)=mean(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1));
        end 
    end
end

for i=1:12
   tTest(i,1)=ttest(average(1,:,i),average(2,:,i),'alpha',0.03);
   tTest(i,2)=ttest(average(1,:,i),average(3,:,i),'alpha',0.03);
   tTest(i,3)=ttest(average(1,:,i),average(4,:,i),'alpha',0.03);
   tTest(i,4)=ttest(average(2,:,i),average(3,:,i),'alpha',0.03);
   tTest(i,5)=ttest(average(2,:,i),average(4,:,i),'alpha',0.03);
   tTest(i,6)=ttest(average(3,:,i),average(4,:,i),'alpha',0.03);
end

  testAcc=0;
    numTrain=0;
    trainAcc=0;
    numTest=0;
aveAll=[]
aveAll2=[]
for k=1:size(GateTrainDataCellPerm,1)
   aveAll=[aveAll;group(k),mean(GateTrainDataCellPerm{k,1}(:,[4 6 7 8 9 13]))];
   aveAll2=[aveAll2;group(k),mean(GateTrainDataCellPerm{k,1}(:,[2:13]))];
end
predictorselection1=cell(2,1);
Prune1=cell(2,1);
predictorselection1{1}='allsplits';
predictorselection1{2}='curvature';
predictorselection1{3}='interaction-curvature';
Prune1{1}='on';Prune1{2}='off';testAcc=0;numTrain=0;trainAcc=0;numTest=0;pre=mod(j,3)+1;pro=mod(j,2)+1;spl=mod(j,72)+1; weg=rand(47,1)*10;
ind=crossvalind('Kfold',group,5);
for i=1:5
       cellPermTREE=fitctree(aveAll(ind~=i,2:7), aveAll(ind~=i,1),...
            'MaxNumSplits',optionResults{2,2} ,'PredictorSelection',optionResults{2,3},'Prune',optionResults{2,4},'Weights',optionResults{2,5}(1:size(aveAll(ind~=i,1),1)));
        results=predict(cellPermTREE,aveAll(ind~=i,2:7));
        labelReal=group(ind~=i);
        trainAcc=trainAcc+sum(results'==labelReal);
        numTrain=numTrain+size(labelReal,2);
        
        results=predict(cellPermTREE,aveAll(ind==i,2:7));
        labelReal=group(ind==i);
        testAcc=testAcc+sum(results'==labelReal);
        numTest=numTest+size(labelReal,2);
end
Results{1,1}=[1-testAcc/numTest,1-trainAcc/numTrain];
  testAcc=0;
    numTrain=0;
    trainAcc=0;
    numTest=0;
for i=1:5
       cellPermTREE=fitctree(aveAll(ind~=i,2:7), aveAll(ind~=i,1),...
            'MaxNumSplits',DT.ModelParameters.MaxSplits ,'PredictorSelection',DT.ModelParameters.PredictorSelection,'Prune',DT.ModelParameters.Prune,'Weights',DT.W(aveAll(ind~=i)));
        results=predict(cellPermTREE,aveAll(ind~=i,2:7));
        labelReal=group(ind~=i);
        trainAcc=trainAcc+sum(results'==labelReal);
        numTrain=numTrain+size(labelReal,2);
        
        results=predict(cellPermTREE,aveAll(ind==i,2:7));
        labelReal=group(ind==i);
        testAcc=testAcc+sum(results'==labelReal);
        numTest=numTest+size(labelReal,2);
end
Results{2,1}=[1-testAcc/numTest,1-trainAcc/numTrain];

treeBagger=TreeBagger(100,aveAll(:,2:7), aveAll(:,1),'OOBPrediction','on')
figure;
plot(oobError(treeBagger))
saveas(gcf,'treeBagger2.jpg')
close;
avAll=aveAll(:,[2:7,1]);
addcell2table=cell(56,7);
for i=1:(56*7)
    addcell2table{i}=avAll(i);
end
avAll2=aveAll2(:,[2:13,1]);
addcell2table2=cell(56,13);
for i=1:(56*13)
    addcell2table2{i}=avAll2(i);
end
for i=1:56
    gendercell{i}=mat2cell(gender(i),1,1)
end
subjectdescriptionParTrainPerm2=[subjectdescriptionParTrainPerm,addcell2table2,gendercell']
subjectdescriptionParTrainPerm=[subjectdescriptionParTrainPerm,addcell2table]
% 
% xtrain=cell2mat(table2cell(subjectdescriptionParTrainPerm2(ind~=2,[14:25,27])))
% xtest=cell2mat(table2cell(subjectdescriptionParTrainPerm2(ind==2,[14:25,27])))
% ytrain=cell2mat(table2cell(subjectdescriptionParTrainPerm2(ind~=2,26)))
% ytest=cell2mat(table2cell(subjectdescriptionParTrainPerm2(ind==2,26)))
% c=cvpartition([ytrain;ytest],'kFold',10)
% opts=statset('display','iter')
% fun=@(xtrain,ytrain,xtest,ytest)...
%     (sum(~strcmp(ytest,classify(xtest,xtrain,ytrain,'linear'))))
% [fs,history]=sequentialfs(fun,[xtrain;xtest],[ytrain;ytest],'options',opts)

testAcc=0;
    numTrain=0;
    trainAcc=0;
    numTest=0;
for i=1:5
       cellPermTREE=fitctree(subjectdescriptionParTrainPerm(ind~=i,2:12), subjectdescriptionParTrainPerm(ind~=i,1),...
            'MaxNumSplits',optionResults{2,2} ,'PredictorSelection',optionResults{2,3},...
            'Prune',optionResults{2,4},'Weights',...
            optionResults{2,5}(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)));
        results=predict(cellPermTREE,subjectdescriptionParTrainPerm(ind~=i,2:12));
        labelPredict=[];
        for l=1:size(results,1)
            labelPredict=[labelPredict,labelChecker(char(results(l)))];
        end
        labelReal=aveAll(ind~=i,1);
        trainAcc=trainAcc+sum(labelPredict'==labelReal);
        numTrain=numTrain+size(labelReal,1);
        
        results=predict(cellPermTREE,subjectdescriptionParTrainPerm(ind==i,2:12));
        labelPredict=[];
        for l=1:size(results,1)
            labelPredict=[labelPredict,labelChecker(char(results(l)))];
        end
        labelReal=aveAll(ind==i,1);
        testAcc=testAcc+sum(labelPredict'==labelReal);
        numTest=numTest+size(labelReal,1);
end
Results{3,1}=[1-testAcc/numTest,1-trainAcc/numTrain];
testAcc=0;
numTrain=0;
trainAcc=0;
numTest=0;
for i=1:5
       cellPermTREE=fitctree(subjectdescriptionParTrainPerm(ind~=i,2:12), subjectdescriptionParTrainPerm(ind~=i,1),...
            'MaxNumSplits',DT.ModelParameters.MaxSplits ,'PredictorSelection',DT.ModelParameters.PredictorSelection,'Prune',DT.ModelParameters.Prune,'Weights',...
            DT.W(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)));
        results=predict(cellPermTREE,subjectdescriptionParTrainPerm(ind~=i,2:12));
        labelPredict=[];
        for l=1:size(results,1)
            labelPredict=[labelPredict,labelChecker(char(results(l)))];
        end
        labelReal=aveAll(ind~=i,1);
        trainAcc=trainAcc+sum(labelPredict'==labelReal);
        numTrain=numTrain+size(labelReal,1);
        
        results=predict(cellPermTREE,subjectdescriptionParTrainPerm(ind==i,2:12));
        labelPredict=[];
        for l=1:size(results,1)
            labelPredict=[labelPredict,labelChecker(char(results(l)))];
        end
        labelReal=aveAll(ind==i,1);
        testAcc=testAcc+sum(labelPredict'==labelReal);
        numTest=numTest+size(labelReal,1);
end
Results{4,1}=[1-testAcc/numTest,1-trainAcc/numTrain];

treeBagger3=TreeBagger(100,subjectdescriptionParTrainPerm(:,2:12), subjectdescriptionParTrainPerm(:,1),'OOBPrediction','on')
figure;
plot(oobError(treeBagger3))
saveas(gcf,'treeBagger3.jpg')
close;











