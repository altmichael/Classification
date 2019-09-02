load('1bc_data.mat')
%devide to groups of subjects
subjects=[find(group==1,3)';find(group==2,3)';find(group==3,3)';find(group==4,3)']
subjectsall={find(group==1);find(group==2);find(group==3);find(group==4)}

%plot 12 subjects- color by group
colors={'b','r','y','k'}

for i=2:13
    figure;
    hold on;
   for k=1:3
       for j=1:4
           plot(GateTrainDataCellPerm{subjects(j,k)}(:,i),'color',colors{j}); 
       end
   end
   legend('park','hunt','ALS','control')
   xlabel('time')
   saveas(gcf,[num2str(i-1),'cellperm.jpg']);
   close;
end

%find average for every subject per GateTrain
average=[];
for j=1:4
    for i=1:12
        for k=1:size(subjectsall{j},1)
            average(j,k,i)=mean(GateTrainDataCellPerm{subjectsall{j}(k)}(:,i+1));
        end 
    end
end

for i=1:12
   tTest(i,1)=ttest(average(1,:,i),average(2,:,i),'alpha',0.05);
   tTest(i,2)=ttest(average(1,:,i),average(3,:,i),'alpha',0.05);
   tTest(i,3)=ttest(average(1,:,i),average(4,:,i),'alpha',0.05);
   tTest(i,4)=ttest(average(2,:,i),average(3,:,i),'alpha',0.05);
   tTest(i,5)=ttest(average(2,:,i),average(4,:,i),'alpha',0.05);
   tTest(i,6)=ttest(average(3,:,i),average(4,:,i),'alpha',0.05);
end
bestParamTtest=sum(tTest')


testAcc=0;
numTrain=0;
trainAcc=0;
numTest=0;
aveAll=[]
aveAll2=[]
for k=1:size(GateTrainDataCellPerm,1)
   aveAll=[aveAll;group(k),mean(GateTrainDataCellPerm{k,1}(:,[2 3 6 7 11 12]))];
   aveAll2=[aveAll2;group(k),mean(GateTrainDataCellPerm{k,1}(:,[2:13]))];
end

%%
for i=1:5
       cellPermTREE=fitctree(aveAll(ind~=i,2:7), aveAll(ind~=i,1),...
            'MaxNumSplits',bestOptions{1,2} ,'PredictorSelection',bestOptions{1,3},'Prune',bestOptions{1,4},'Weights',bestOptions{1,5}(1:size(aveAll(ind~=i,1),1)));
        results=predict(cellPermTREE,aveAll(ind~=i,2:7));
        labelReal=group(ind~=i);
        [trainAcc1,numTrain1]=labelPre(group,trainAcc,numTrain,results,ind,i,labelReal,1,1);
        trainAcc=trainAcc+trainAcc1;
        numTrain=numTrain+numTrain1;
        
        results=predict(cellPermTREE,aveAll(ind==i,2:7));
        labelReal=group(ind==i);
        [testAcc1,numTest1]=labelPre(group,testAcc,numTest,results,ind,i,labelReal,1,1);
        testAcc=testAcc+testAcc1;
        numTest=numTest+numTest1;
end
Results{1,1}=[1-testAcc/numTest,1-trainAcc/numTrain];
Results{1,2}=cellPermTREE
  testAcc=0;
    numTrain=0;
    trainAcc=0;
    numTest=0;
for i=1:5
       cellPermTREE=fitctree(aveAll(ind~=i,2:7), aveAll(ind~=i,1),...
            'MaxNumSplits',DT.ModelParameters.MaxSplits ,'PredictorSelection',DT.ModelParameters.PredictorSelection,'Prune',DT.ModelParameters.Prune,'Weights',DT.W(aveAll(ind~=i)));
         results=predict(cellPermTREE,aveAll(ind~=i,2:7));
        labelReal=group(ind~=i);
        [trainAcc1,numTrain1]=labelPre(group,trainAcc,numTrain,results,ind,i,labelReal,1);
        trainAcc=trainAcc+trainAcc1;
        numTrain=numTrain+numTrain1;
        
        results=predict(cellPermTREE,aveAll(ind==i,2:7));
        labelReal=group(ind==i);
        [testAcc1,numTest1]=labelPre(group,testAcc,numTest,results,ind,i,labelReal,1);
        testAcc=testAcc+testAcc1;
        numTest=numTest+numTest1;
end
Results{2,1}=[1-testAcc/numTest,1-trainAcc/numTrain];
Results{2,2}=cellPermTREE

treeBagger=TreeBagger(100,aveAll(:,2:7), aveAll(:,1),'OOBPrediction','on')
figure;
plot(oobError(treeBagger))
saveas(gcf,'treeBagger2.jpg')
close;


avAll=aveAll(:,[2:7]);
addcell2table=cell(56,6);
for i=1:(56*6)
    addcell2table{i}=avAll(i);
end
% avAll2=aveAll2(:,[2:13]);
% addcell2table2=cell(56,12);
% for i=1:(56*12)
%     addcell2table2{i}=avAll2(i);
% end
addcell2table3=cell(56,1);
for i=1:(56)
    addcell2table3{i}=group(i);
end
% 
% for i=1:56
%     gendercell{i}=mat2cell(gender(i),1,1)
% end
% subjectdescriptionParTrainPerm3=[subjectdescriptionParTrainPerm,addcell2table2,addcell2table3]
subjectdescriptionParTrainPerm2=[subjectdescriptionParTrainPerm,addcell2table,addcell2table3]


testAcc=0;
    numTrain=0;
    trainAcc=0;
    numTest=0;
for i=1:5
       cellPermTREE=fitctree(subjectdescriptionParTrainPerm2(ind~=i,2:12), subjectdescriptionParTrainPerm2(ind~=i,end),...
            'MaxNumSplits',bestOptions{1,2} ,'PredictorSelection',bestOptions{1,3},...
            'Prune',bestOptions{1,4},'Weights',...
            bestOptions{1,5}(1:size(subjectdescriptionParTrainPerm2(ind~=i,1),1)));
        results=predict(cellPermTREE,subjectdescriptionParTrainPerm2(ind~=i,2:12));
        labelReal=group(ind~=i);
        [trainAcc1,numTrain1]=labelPre(group,trainAcc,numTrain,results,ind,i,labelReal,1);
        trainAcc=trainAcc+trainAcc1;
        numTrain=numTrain+numTrain1;
        
        results=predict(cellPermTREE,subjectdescriptionParTrainPerm2(ind==i,2:12));
        labelReal=group(ind==i);
        [testAcc1,numTest1]=labelPre(group,testAcc,numTest,results,ind,i,labelReal,1);
        testAcc=testAcc+testAcc1;
        numTest=numTest+numTest1;
end
Results{3,1}=[1-testAcc/numTest,1-trainAcc/numTrain];
Results{3,2}=cellPermTREE;

testAcc=0;
numTrain=0;
trainAcc=0;
numTest=0;
for i=1:5
       cellPermTREE=fitctree(subjectdescriptionParTrainPerm2(ind~=i,2:12), subjectdescriptionParTrainPerm2(ind~=i,end),...
            'MaxNumSplits',DT.ModelParameters.MaxSplits ,'PredictorSelection',DT.ModelParameters.PredictorSelection,'Prune',DT.ModelParameters.Prune,'Weights',...
            DT.W(1:size(subjectdescriptionParTrainPerm2(ind~=i,1),1)));
        results=predict(cellPermTREE,subjectdescriptionParTrainPerm2(ind~=i,2:12));
        labelReal=group(ind~=i);
        [trainAcc1,numTrain1]=labelPre(group,trainAcc,numTrain,results,ind,i,labelReal,1);
        trainAcc=trainAcc+trainAcc1;
        numTrain=numTrain+numTrain1;
        
        results=predict(cellPermTREE,subjectdescriptionParTrainPerm2(ind==i,2:12));
        labelReal=group(ind==i);
        [testAcc1,numTest1]=labelPre(group,testAcc,numTest,results,ind,i,labelReal,1);
        testAcc=testAcc+testAcc1;
        numTest=numTest+numTest1;
end
Results{4,1}=[1-testAcc/numTest,1-trainAcc/numTrain];
Results{4,2}=cellPermTREE;

treeBagger3=TreeBagger(100,subjectdescriptionParTrainPerm2(:,2:12), subjectdescriptionParTrainPerm2(:,1),'OOBPrediction','on')
figure;
plot(oobError(treeBagger3))
saveas(gcf,'treeBagger3.jpg')
close;
