clear
getpeak = 1;
transarray = ["Untreated";"1 \muM YM-254890"];
drugarray = ["AngII";"023";"026";"027";"SII";"055"];
trans = cellstr(transarray);
times = zeros(2,6,8,121);
vals = zeros(2,6,8,121);
%for setstart = 1:3
fname = sprintf('FLIPR sample YM.xls');
data = xlsread(fname,'C4:GL124');
%transcon = setstart;
for dox = 1:8
    for drug = 1:6
        for transcon = 1:2
          times(transcon,drug,9-dox,:) = data(:,(4*(drug-1)+2*(transcon-1)+24*(dox-1)+1));
          vals(transcon,drug,9-dox,:) = data(:,(4*(drug-1)+2*(transcon-1)+24*(dox-1)+2));
        end
    end
end
%end
auc = zeros(2,6,8);
doxes = [0;10;25;50;100;150;200;250];
xl = zeros(1,2);
xlset = 0;
yl = zeros(1,2);
ylset = 0;
co = [0 0 0;
      1 0 0;
      0 0 1;];
set(groot,'defaultAxesColorOrder',co)
figure(1)
clf
for drug = 1:6
  subplot(2,3,drug)
  for transcon = 1:2
    for dox = 1:8
        %for transcon = 1:3
          sum = 0;
          x = times(transcon,drug,dox,:);
          y = vals(transcon,drug,dox,:);
          t = x(:);
          rfu = y(:);
          base = mean(rfu(t<=10));
          if getpeak == 1
              auc(transcon,drug,dox) = max(rfu)-base;
          else
              for ind = 1:length(t)-1
                  sum = sum + (((rfu(ind)+rfu(ind+1))/2)-base)*(t(ind+1)-t(ind));
              end
              auc(transcon,drug,dox) = sum;
          end
        %end
    end
    exp = [doxes,(squeeze(auc(:,drug,:)))'];
    sheet = sprintf('%s', drugarray(drug));
    if getpeak == 0
      xlswrite('sample YM integral response.xlsx',exp,sheet)
    else
      xlswrite('sample YM peak response.xlsx',exp,sheet)
    end
     plot(categorical(doxes),squeeze(auc(transcon,drug,:)),'--o')
    hold on
  end
%   plot(categorical(doxes),(squeeze(auc(:,drug,:)))')
%    comp = xlim;
%      if comp(2) > xl(1,2)
%        xlim auto
%        xl(1,2) = comp(2);
%      end
%      if (comp(1) < xl(1,1) || xlset == 0)
%        xlim auto
%        xl(1,1) = comp(1);
%        xlset = 1; 
%      end
     comp = ylim;
     if comp(2) > yl(1,2)
       ylim auto
       yl(1,2) = comp(2);
     end
     if (comp(1) < yl(1,1) || ylset == 0)
       ylim auto
       yl(1,1) = comp(1);
       ylset = 1;
     end
     for sp = 1:drug
         subplot(2,3,sp)
%           xlim(xl(1,:))
         ylim(yl(1,:))
     end
     subplot(2,3,drug)
  lgd = legend(transarray,'location','best');
  title(lgd,'Transfection')
  xlabel('DOX (ng/mL)')
  if getpeak == 0
    ylabel('Area under curve (RFU*s)')
  else
      ylabel('Peak response (RFU)')
  end
  title(drugarray(drug))
end
sgtitle('Response to YM-254890')
doxes = [0 10 25 50 100 150 200 250];
concs = [-7 -5];
cd ..
for transcon = 1:2
    for drug = 1:6
        %for conc = 1:2
            for dose = 1:8
                exp = {"sample",drugarray(drug),-5,doxes(dose),transarray(transcon),auc(transcon,drug,dose)};
                if getpeak == 1
                    writecell(exp,'Pooled YM peak data.xlsx','WriteMode','append');
                else
                   writecell(exp,'Pooled YM integral data.xlsx','WriteMode','append');
                end
            end
        %end
    end
end
cd sample