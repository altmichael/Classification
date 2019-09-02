load('1a_data.mat')
%convert group to cell for adding the table
group=[]
for k=1:size(subjectdescriptionParTrainPerm,1)
    lab=table2cell(subjectdescriptionParTrainPerm(k,1));
    group=[group,labelChecker(char(lab{1}))];
end
group=group'

%cross validation 1b
ind=crossvalind('Kfold',group,5);

optionResults=cell(144,5);
tb=subjectdescriptionParTrainPerm(:,2:6);
gro=subjectdescriptionParTrainPerm(:,1);

%options for hyperparameters
predictorselection1=cell(3,1);
Prune1=cell(2,1);
predictorselection1{1}='allsplits';
predictorselection1{2}='curvature';
predictorselection1{3}='interaction-curvature';
Prune1{1}='on';
Prune1{2}='off';


%train the model N times
for j=1:144
    testAcc=0;
    numTrain=0;
    trainAcc=0;
    numTest=0;
    
    %changing Parameters each time
    pre=mod(j,3)+1;
    pro=mod(j,2)+1;
    spl=mod(j,9)+1;
    weg=rand(50,1)*rand(1)*5;;
    %train with specific parameters
    for i=1:5
        TREE = fitctree(subjectdescriptionParTrainPerm(ind~=i,2:6), subjectdescriptionParTrainPerm(ind~=i,1),...
            'MaxNumSplits',spl ,'PredictorSelection',predictorselection1{pre},'Prune',Prune1{pro},'Weights',weg(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)));
        results=predict(TREE,subjectdescriptionParTrainPerm(ind~=i,2:6));
        labelReal=group(ind~=i);
        [trainAcc1,numTrain1]=labelPre(group,trainAcc,numTrain,results,ind,i,labelReal,[],1);
        trainAcc=trainAcc+trainAcc1;
        numTrain=numTrain+numTrain1;
        results=predict(TREE,subjectdescriptionParTrainPerm(ind==i,2:6));
        labelReal=group(ind==i);
        [testAcc1,numTest1]=labelPre(group,testAcc,numTest,results,ind,i,labelReal,[],1);
        testAcc=testAcc+testAcc1;
        numTest=numTest+numTest1;
    end
    
    optionResults{j,1}=[1-testAcc/numTest,1-trainAcc/numTrain];
    optionResults{j,2}=spl;
    optionResults{j,3}=predictorselection1{pre};
    optionResults{j,4}=Prune1{pro};
    optionResults{j,5}=weg(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)+5);
end

res=[];
for k=1:144
    res=[res,optionResults{k,1}(1)];
end
bestans=min(res);
ans=find(res==bestans);
bestOptions=optionResults(ans,:);

%optimaizer
DT = fitctree(tb, gro, 'OptimizeHyperparameters','auto');

bestTREE=fitctree(subjectdescriptionParTrainPerm(ind~=i,2:6), subjectdescriptionParTrainPerm(ind~=i,1),...
            'MaxNumSplits',optionResults{1,2} ,'PredictorSelection',optionResults{1,3},'Prune',optionResults{1,4},'Weights',optionResults{1,5}(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)));
view(bestTREE,'mode','graph')
view(DT,'mode','graph')
preImp=predictorImportance(bestTREE)
preImpDT=predictorImportance(DT)
DT2 = fitctree(tb(ind~=1,:), gro(ind~=1,:), 'OptimizeHyperparameters','auto');

%treeBagger (Random Forest)
treeBagger=TreeBagger(100,tb, gro,'OOBPrediction','on')
figure;
plot(oobError(treeBagger))
saveas(gcf,'treeBagger.jpg')
close;
