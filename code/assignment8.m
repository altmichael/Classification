load('TrainingDataClinicalAndGait.mat')

subjectdescriptionParTrainPermCell=table2cell(subjectdescriptionParTrainPerm);
gender=[]
for k=1:size(subjectdescriptionParTrainPerm,1)
    lab=table2cell(subjectdescriptionParTrainPerm(k,5));
    gender=[gender,labelCheckergender(char(lab{1}))];
end
addcell2table0=cell(56,1);
for i=1:(56)
    addcell2table0{i}=gender(i);
end
subjectdescriptionParTrainPerm=[subjectdescriptionParTrainPerm(:,1:4),addcell2table0,subjectdescriptionParTrainPerm(:,6)]
%ques 1 a
figure;
gscatter(subjectdescriptionParTrainPerm.AGEYRS,subjectdescriptionParTrainPerm.HEIGHTmeters,subjectdescriptionParTrainPerm.GROUP)
xlabel('AGEYRS')
ylabel('HEIGHTmeters')
saveas(gcf,'1.jpg')
close;
figure;
gscatter(subjectdescriptionParTrainPerm.AGEYRS,subjectdescriptionParTrainPerm.Weightkg,subjectdescriptionParTrainPerm.GROUP)
xlabel('AGEYRS')
ylabel('Weightkg')
saveas(gcf,'2.jpg')
close;
figure;
gscatter(subjectdescriptionParTrainPerm.AGEYRS,subjectdescriptionParTrainPerm.Var5,subjectdescriptionParTrainPerm.GROUP)
xlabel('AGEYRS')
ylabel('gender')
saveas(gcf,'3.jpg')
close;
figure;
gscatter(subjectdescriptionParTrainPerm.AGEYRS,subjectdescriptionParTrainPerm.GaitSpeedmsec,subjectdescriptionParTrainPerm.GROUP)
xlabel('AGEYRS')
ylabel('GaitSpeedmsec')
saveas(gcf,'4.jpg')
close;
figure;
gscatter(subjectdescriptionParTrainPerm.HEIGHTmeters,subjectdescriptionParTrainPerm.Weightkg,subjectdescriptionParTrainPerm.GROUP)
xlabel('HEIGHTmeters')
ylabel('Weightkg')
saveas(gcf,'5.jpg')
close;
figure;
gscatter(subjectdescriptionParTrainPerm.HEIGHTmeters,subjectdescriptionParTrainPerm.Var5,subjectdescriptionParTrainPerm.GROUP)
xlabel('HEIGHTmeters')
ylabel('gender')
saveas(gcf,'6.jpg')
close;
figure;
gscatter(subjectdescriptionParTrainPerm.HEIGHTmeters,subjectdescriptionParTrainPerm.GaitSpeedmsec,subjectdescriptionParTrainPerm.GROUP)
xlabel('HEIGHTmeters')
ylabel('GaitSpeedmsec')
saveas(gcf,'7.jpg')
close;
figure;
gscatter(subjectdescriptionParTrainPerm.Weightkg,subjectdescriptionParTrainPerm.Var5,subjectdescriptionParTrainPerm.GROUP)
xlabel('Weightkg')
ylabel('gender')
saveas(gcf,'8.jpg')
close;
figure;
gscatter(subjectdescriptionParTrainPerm.Weightkg,subjectdescriptionParTrainPerm.GaitSpeedmsec,subjectdescriptionParTrainPerm.GROUP)
xlabel('Weightkg')
ylabel('GaitSpeedmsec')
saveas(gcf,'9.jpg')
close;
figure
gscatter(subjectdescriptionParTrainPerm.Var5,subjectdescriptionParTrainPerm.GaitSpeedmsec,subjectdescriptionParTrainPerm.GROUP)

xlabel('gender')
ylabel('GaitSpeedmsec')
saveas(gcf,'10.jpg')
close;


