clear
%pkg load io % Octave only
drugsarray = ["AngII";"023";"026";"027";"SII";"055"];
drugs = cellstr(drugsarray);
times = zeros(6,8,8,121);
vals = zeros(6,8,8,121);
[~,date,~] = fileparts(pwd);
for conc = 1:3:4
  fname = sprintf('FLIPR %s %s %s.xls', date, drugsarray(conc), drugsarray(conc+1));
  data = xlsread(fname,'C4:GL124');
  for dox = 1:8
    drug = conc;
    for dose = 1:8
      times(drug,dose,(9-dox),:) = data(:,(2*dose-1+24*(dox-1)));
      vals(drug,dose,(9-dox),:) = data(:,(2*dose+24*(dox-1)));
    end
    drug = conc + 1;
    for dose = 1:4
        times(drug,dose,(9-dox),:) = data(:,(2*dose+15+24*(dox-1)));
        vals(drug,dose,(9-dox),:) = data(:,(2*dose+16+24*(dox-1)));
    end
  end
  fname = sprintf('FLIPR %s %s %s.xls', date, drugsarray(conc+1), drugsarray(conc+2));
  data = xlsread(fname,'C4:GL124');
  for dox = 1:8
    drug = conc + 1;
    for dose = 1:4
      times(drug,(dose+4),(9-dox),:) = data(:,(2*dose-1+24*(dox-1)));
      vals(drug,(dose+4),(9-dox),:) = data(:,(2*dose+24*(dox-1)));
    end
    drug = conc + 2;
    for dose = 1:8
        times(drug,dose,(9-dox),:) = data(:,(2*dose+7+24*(dox-1)));
        vals(drug,dose,(9-dox),:) = data(:,(2*dose+8+24*(dox-1)));
    end
  end
end
for getpeak = 0:1
    auc = zeros(6,8,8);
    for drug = 1:6
      for dose = 1:8
        for dox = 1:8
          sum = 0;
          x = times(drug,dose,dox,:);
          y = vals(drug,dose,dox,:);
          t = x(:);
          rfu = y(:);
          base = mean(rfu(t<=10));
          if getpeak == 1
              auc(drug,dose,dox) = max(rfu)-base;
          else
              for ind = 1:length(t)-1
                  sum = sum + (((rfu(ind)+rfu(ind+1))/2)-base)*(t(ind+1)-t(ind));
              end
              auc(drug,dose,dox) = sum;
          end
        end
      end
      if (drug == 1 || drug == 6)  
          concs = linspace(-12,-5,8)';
      else
          concs = linspace(-11,-4,8)';
      end
      exp = [concs,squeeze(auc(drug,:,:))];
        if getpeak == 0
          xlswrite(sprintf('%s integral response.xlsx',date),exp,drugs{drug,1})
        else
          xlswrite(sprintf('%s peak response.xlsx',date),exp,drugs{drug,1})
        end
    end
    doxes = [0 10 25 50 100 150 200 250];
    cd ..
    for drug = 1:6
      if (drug == 1 || drug == 6)  
          concs = linspace(-12,-5,8)';
      else
          concs = linspace(-11,-4,8)';
      end
        for conc = 1:8
            for dose = 1:8
                exp = {date,drugsarray(drug),concs(conc),doxes(dose),"None",auc(drug,conc,dose)};
                if getpeak == 1
                    writecell(exp,'Pooled dose response peak data.xlsx','WriteMode','append');
                else
                   writecell(exp,'Pooled dose response integral data.xlsx','WriteMode','append');
                end
            end
        end
    end
    cd(date)
end