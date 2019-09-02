load('2_DATA1.mat')

stdD=[];
skewnessD=[];
kurtosisD=[];
variance=[];
for j=1:4
    for i=1:12
        for k=1:size(subjectsall{j},1)
            stdD(j,k,i)=std(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1));
            skewnessD(j,k,i)=skewness(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1));
            kurtosisD(j,k,i)=kurtosis(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1));
            variance(j,k,i)=var(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1));
        end
    end
end

for i=1:12
   tTeststdD(i,1)=ttest(stdD(1,:,i),stdD(2,:,i),'alpha',0.05);
   tTeststdD(i,2)=ttest(stdD(1,:,i),stdD(3,:,i),'alpha',0.05);
   tTeststdD(i,3)=ttest(stdD(1,:,i),stdD(4,:,i),'alpha',0.05);
   tTeststdD(i,4)=ttest(stdD(2,:,i),stdD(3,:,i),'alpha',0.05);
   tTeststdD(i,5)=ttest(stdD(2,:,i),stdD(4,:,i),'alpha',0.05);
   tTeststdD(i,6)=ttest(stdD(3,:,i),stdD(4,:,i),'alpha',0.05);
   tTestskewnessD(i,1)=ttest(skewnessD(1,:,i),skewnessD(2,:,i),'alpha',0.05);
   tTestskewnessD(i,2)=ttest(skewnessD(1,:,i),skewnessD(3,:,i),'alpha',0.05);
   tTestskewnessD(i,3)=ttest(skewnessD(1,:,i),skewnessD(4,:,i),'alpha',0.05);
   tTestskewnessD(i,4)=ttest(skewnessD(2,:,i),skewnessD(3,:,i),'alpha',0.05);
   tTestskewnessD(i,5)=ttest(skewnessD(2,:,i),skewnessD(4,:,i),'alpha',0.05);
   tTestskewnessD(i,6)=ttest(skewnessD(3,:,i),skewnessD(4,:,i),'alpha',0.05);
   tTestkurtosisD(i,1)=ttest(kurtosisD(1,:,i),kurtosisD(2,:,i),'alpha',0.05);
   tTestkurtosisD(i,2)=ttest(kurtosisD(1,:,i),kurtosisD(3,:,i),'alpha',0.05);
   tTestkurtosisD(i,3)=ttest(kurtosisD(1,:,i),kurtosisD(4,:,i),'alpha',0.05);
   tTestkurtosisD(i,4)=ttest(kurtosisD(2,:,i),kurtosisD(3,:,i),'alpha',0.05);
   tTestkurtosisD(i,5)=ttest(kurtosisD(2,:,i),kurtosisD(4,:,i),'alpha',0.05);
   tTestkurtosisD(i,6)=ttest(kurtosisD(3,:,i),kurtosisD(4,:,i),'alpha',0.05);
   tTestvariance(i,1)=ttest(variance(1,:,i),variance(2,:,i),'alpha',0.05);
   tTestvariance(i,2)=ttest(variance(1,:,i),variance(3,:,i),'alpha',0.05);
   tTestvariance(i,3)=ttest(variance(1,:,i),variance(4,:,i),'alpha',0.05);
   tTestvariance(i,4)=ttest(variance(2,:,i),variance(3,:,i),'alpha',0.05);
   tTestvariance(i,5)=ttest(variance(2,:,i),variance(4,:,i),'alpha',0.05);
   tTestvariance(i,6)=ttest(variance(3,:,i),variance(4,:,i),'alpha',0.05);
end
bestParamTteststd=sum(tTeststdD')
bestParamTtestske=sum(tTestskewnessD')
bestParamTtestkur=sum(tTestkurtosisD')
bestParamTtestvar=sum(tTestvariance')

addTable=[]
for k=1:size(GateTrainDataCellPerm,1)
   addTable=[addTable;std(GateTrainDataCellPerm{k,1}(:,2:13)),var(GateTrainDataCellPerm{k,1}(:,2:13)),skewness(GateTrainDataCellPerm{k,1}(:,2:13)),kurtosis(GateTrainDataCellPerm{k,1}(:,2:13))];
end

addcell2tablenew=cell(56,48);
for i=1:(56*48)
    addcell2tablenew{i}=addTable(i);
end

subjectdescriptionParTrainPerm5=[subjectdescriptionParTrainPerm2,addcell2tablenew]

tb1=subjectdescriptionParTrainPerm5(:,[2:12,14:61]);
gro1=subjectdescriptionParTrainPerm5(:,1);
subjectdescriptionParTrainPerm3=subjectdescriptionParTrainPerm5(:,[1:12,19,58]);
subjectdescriptionParTrainPerm4=subjectdescriptionParTrainPerm5(:,[1:12,19,23]);


%%bonus
%%check OptimizeHyperparameters for 59 features
DTALL = fitctree(tb1, gro1, 'OptimizeHyperparameters','auto');
testAcc=0;
numTrain=0;
trainAcc=0;
numTest=0;
for i=1:5
       cellPermTREEDT=fitctree(subjectdescriptionParTrainPerm5(ind~=i,[2:12,14:61]), subjectdescriptionParTrainPerm2(ind~=i,13),...
            'MaxNumSplits',DT.ModelParameters.MaxSplits ,'PredictorSelection',DT.ModelParameters.PredictorSelection,'Prune',DT.ModelParameters.Prune,'Weights',...
            DT.W(1:size(subjectdescriptionParTrainPerm5(ind~=i,1),1)));
        results=predict(cellPermTREEDT,subjectdescriptionParTrainPerm5(ind~=i,[2:12,14:61]));
        labelReal=group(ind~=i);
        [trainAcc1,numTrain1]=labelPre(group,trainAcc,numTrain,results,ind,i,labelReal,1);
        trainAcc=trainAcc+trainAcc1;
        numTrain=numTrain+numTrain1;
        
        results=predict(cellPermTREEDT,subjectdescriptionParTrainPerm5(ind==i,[2:12,14:61]));
        labelReal=group(ind==i);
        [testAcc1,numTest1]=labelPre(group,testAcc,numTest,results,ind,i,labelReal,1);
        testAcc=testAcc+testAcc1;
        numTest=numTest+numTest1;
end
ans1=[1-testAcc/numTest,1-trainAcc/numTrain];


treeBagger=TreeBagger(300,tb1, gro1,'OOBPrediction','on')
figure;
plot(oobError(treeBagger))
saveas(gcf,'treeBaggerDTaLL.jpg')
close;

subjectdescriptionParTrainPerm6=subjectdescriptionParTrainPerm5(:,[1:13,16,19,23,31,35,52,54,55,58,59,61])

TF = isoutlier(subjectdescriptionParTrainPerm6(:,[2:4,6:end]),1)
x=1:56;
outlier=find(sum(TF')>=6)
x(outlier)=[];

subjectdescriptionParTrainPerm7=subjectdescriptionParTrainPerm5(x,[1:13,16,19,23,31,35,52,54,55,58,59,61])

x1=1:56
x1([10,21,30,35,36])=[]
subjectdescriptionParTrainPerm8=subjectdescriptionParTrainPerm5(x1,[1:13,16,19,23,31,35,52,54,55,58,59,61])
group([10,21,30,35,36])=[];
maxD=[];
minD=[];
manminD=[];
diffff=[];
hanafatime=[]
totalPerStep=[]
for j=1:4
    for i=1:12
        for k=1:size(subjectsall{j},1)
            maxD(j,k,i)=max(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1));
            minD(j,k,i)=min(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1));
            manminD(j,k,i)=maxD(j,k,i)-minD(j,k,i);
            diffff(j,k,i)=mean(abs(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1)-GateTrainDataCellPerm{subjectsall{j}(k)}(:,i)));
            hanafatime(j,k,i)=mean(abs(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1)+GateTrainDataCellPerm{subjectsall{j}(k)}(:,i)));
        end
    end
end

diffrigthleftave=[]
for k=1:size(GateTrainDataCellPerm,1)
   diffrigthleftave=[diffrigthleftave;mean(abs(GateTrainDataCellPerm{k,1}(:,9)-GateTrainDataCellPerm{k,1}(:,8)))];
end

meantotalhanafa=[]
for k=1:size(GateTrainDataCellPerm,1)
   meantotalhanafa=[meantotalhanafa;mean(abs(GateTrainDataCellPerm{k,1}(:,4)+GateTrainDataCellPerm{k,1}(:,5)))];
end

meantotalstep=[]
for k=1:size(GateTrainDataCellPerm,1)
   meantotalstep=[meantotalstep;mean(abs(GateTrainDataCellPerm{k,1}(:,2)+GateTrainDataCellPerm{k,1}(:,3)))];
end

diffhanafaave=[]
for k=1:size(GateTrainDataCellPerm,1)
   diffhanafaave=[diffhanafaave;abs(mean(GateTrainDataCellPerm{k,1}(:,4)-mean(GateTrainDataCellPerm{k,1}(:,5))))];
end

vartotaltimewithoutwalk=[]
for k=1:size(GateTrainDataCellPerm,1)
   vartotaltimewithoutwalk=[vartotaltimewithoutwalk;var(GateTrainDataCellPerm{k,1}(:,9)+GateTrainDataCellPerm{k,1}(:,8)+GateTrainDataCellPerm{k,1}(:,5)+GateTrainDataCellPerm{k,1}(:,4)+GateTrainDataCellPerm{k,1}(:,3)+GateTrainDataCellPerm{k,1}(:,2))];
end

addcell2tablenew1=cell(56,5);

for i=1:(56)
    addcell2tablenew1{i,1}=diffrigthleftave(i);
    addcell2tablenew1{i,2}=meantotalhanafa(i);
    addcell2tablenew1{i,3}=meantotalstep(i);
    addcell2tablenew1{i,4}=diffhanafaave(i);
    addcell2tablenew1{i,5}=vartotaltimewithoutwalk(i);
    
end

subjectdescriptionParTrainPerm9=[subjectdescriptionParTrainPerm8,addcell2tablenew1(x1,:)]
subjectdescriptionParTrainPerm9(1,1)=subjectdescriptionParTrainPerm9(10,1)

optionResultsB=cell(1200,9);
ind=crossvalind('Kfold',group,5);
DTfitcensemble = fitcensemble(subjectdescriptionParTrainPerm9(:,[2:12,24:29]), subjectdescriptionParTrainPerm9(:,1), 'OptimizeHyperparameters','auto');
DTfitctree = fitctree(subjectdescriptionParTrainPerm9(:,[2:12,14:29]), subjectdescriptionParTrainPerm9(:,1), 'OptimizeHyperparameters','auto');
subjectdescriptionParTrainPerm9(:,13)=[]

    
for j=1:1200
    ind=crossvalind('Kfold',group,5);
    j=j
    testAcc=0;
    numTrain=0;
    trainAcc=0;
    numTest=0;
    testAcc2=0;
    numTrain2=0;
    trainAcc2=0;
    numTest2=0;
    diffeature=randperm(27,27-randi(14)+1);
    diffeature=diffeature+1;
    nLearnRan=randperm(100,1)+50;
    %changing Parameters each time
    pre=mod(j,3)+1;
    pro=mod(j,2)+1;
    spl=mod(j,9)+1;
    weg=rand(50,1)*rand(1)*5;
    %train with specific parameters
    for i=1:5
        ensensemble=fitcensemble(subjectdescriptionParTrainPerm9(ind~=i,diffeature), subjectdescriptionParTrainPerm9(ind~=i,1),'Method','Bag','Nlearn',nLearnRan,'type','classification','Weights',weg(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)));
        enstree=fitctree(subjectdescriptionParTrainPerm9(ind~=i,diffeature), subjectdescriptionParTrainPerm9(ind~=i,1),...
            'MaxNumSplits',spl ,'PredictorSelection',predictorselection1{pre},'Prune',Prune1{pro},'Weights',weg(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)));
        results=predict(enstree,subjectdescriptionParTrainPerm9(ind~=i,diffeature));
        labelReal=group(ind~=i);
        [trainAcc1,numTrain1]=labelPre(group,trainAcc,numTrain,results,ind,i,labelReal,[]);
        trainAcc=trainAcc+trainAcc1;
        numTrain=numTrain+numTrain1;
        
        results=predict(enstree,subjectdescriptionParTrainPerm9(ind==i,diffeature));
        labelReal=group(ind==i);
        [testAcc1,numTest1]=labelPre(group,testAcc,numTest,results,ind,i,labelReal,[]);
        testAcc=testAcc+testAcc1;
        numTest=numTest+numTest1;
        
        results2=predict(ensensemble,subjectdescriptionParTrainPerm9(ind~=i,diffeature));
        labelReal=group(ind~=i);
        [trainAcc12,numTrain12]=labelPre(group,trainAcc2,numTrain2,results2,ind,i,labelReal,[]);
        trainAcc2=trainAcc2+trainAcc12;
        numTrain2=numTrain2+numTrain12;
        
        results2=predict(ensensemble,subjectdescriptionParTrainPerm9(ind==i,diffeature));
        labelReal=group(ind==i);
        [testAcc12,numTest12]=labelPre(group,testAcc2,numTest2,results2,ind,i,labelReal,[]);
        testAcc2=testAcc2+testAcc12;
        numTest2=numTest2+numTest12;
    end
    re=1-testAcc/numTest
    ree=1-testAcc2/numTest2
    optionResultsB{j,1}=[re,1-trainAcc/numTrain];
    optionResultsB{j,2}=spl;
    optionResultsB{j,3}=predictorselection1{pre};
    optionResultsB{j,4}=Prune1{pro};
    optionResultsB{j,5}=weg(1:(size(subjectdescriptionParTrainPerm9(ind~=i,1),1)+5));
    optionResultsB{j,6}=diffeature;
    optionResultsB{j,7}=[ree,1-trainAcc2/numTrain2];
    optionResultsB{j,8}=nLearnRan;
    optionResultsB{j,9}=ind;

end

res=[];
reses=[];

for k=1:1200
    res=[res,optionResultsB{k,1}(1)];
    reses=[reses,optionResultsB{k,7}(1)];

end
bestans=min(res);
bestanses=min(reses)
ans=find(res==bestans)
bestOptions=optionResultsB(ans(1),:)
ans2=find(reses==bestanses)
bestOptions2=optionResultsB(ans2(1),:)

e=1;
bestans5=sort(res);
bestanses5=sort(reses);
bestans5=bestans5(1:10);
bestanses5=bestanses5(1:10);
bestOptions5=cell(5,10);
bestOptions25=cell(5,10);
for i=1:10
    ans=find(res==bestans5(i));
    bestOptions5{i}=optionResultsB(ans(1),:);
    ans2=find(reses==bestanses5(i));
    bestOptions25{i}=optionResultsB(ans2(1),:); 
end
resultsfinal=cell(100,3);
for t=1:100
    ind=bestOptions25{e}{9};
    testAccall=0;
    numTestall=0;
    testAcc2all=0;
    numTest2all=0;
  
    %train with specific parameters
    for i=1:5
        resultstree=zeros(1,sum(ind==i));
        resultsesem=zeros(1,sum(ind==i));
        
        for e=1:1
            ensensemble=fitcensemble(subjectdescriptionParTrainPerm9(ind~=i,bestOptions25{e}{6}), subjectdescriptionParTrainPerm9(ind~=i,1),'Method','Bag','Nlearn',bestOptions25{e}{8},'type','classification','Weights',bestOptions25{e}{5}(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)));
%             enstree=fitctree(subjectdescriptionParTrainPerm9(ind~=i,bestOptions5{e}{6}), subjectdescriptionParTrainPerm9(ind~=i,1),...
%                 'MaxNumSplits',bestOptions5{e}{2} ,'PredictorSelection',bestOptions5{e}{3},'Prune',bestOptions5{e}{4},'Weights',bestOptions5{e}{5}(1:size(subjectdescriptionParTrainPerm(ind~=i,1),1)));
%             resultstree(e,:)=labelChekerSimple(predict(enstree,subjectdescriptionParTrainPerm9(ind==i,bestOptions5{e}{6})));
            resultsesem(e,:)=labelChekerSimple(predict(ensensemble,subjectdescriptionParTrainPerm9(ind==i,bestOptions25{e}{6})));
        end
        
        labelReal=group(ind==i);
%         testAccall=testAccall+sum(labelReal==resultstree);
%         numTestall=numTestall+length(labelReal);
        testAcc2all=testAcc2all+sum(labelReal==resultsesem);
        numTest2all=numTest2all++length(labelReal);
           
    end
%     re=1-testAccall/numTestall;
    ree=1-testAcc2all/numTest2all;
%     resultsfinal{t,1}=re
    resultsfinal{t,1}=ensensemble;
    resultsfinal{t,2}=ree
    resultsfinal{t,3}=ind;
end

