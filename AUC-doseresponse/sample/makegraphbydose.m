clear
%pkg load io % Octave only
include1000 = 1;
drugsarray = ["AngII";"023";"026";"027";"SII";"055"];
drugs = cellstr(drugsarray);
times = zeros(6,9,8,121);
vals = zeros(6,9,8,121);
[~,date,~] = fileparts(pwd);
for setstart = 1:3:4
  fname = sprintf('FLIPR %s %s %s.xls', date, drugsarray(setstart), drugsarray(setstart+1));
  data = xlsread(fname,'C4:GL124');
  for dox = 1:8
    drug = setstart;
    for dose = 1:8
      times(drug,getdose(drug,dose),(9-dox),:) = data(:,(2*dose-1+24*(dox-1)));
      vals(drug,getdose(drug,dose),(9-dox),:) = data(:,(2*dose+24*(dox-1)));
    end
    drug = setstart + 1;
    for dose = 1:4
        times(drug,getdose(drug,dose),(9-dox),:) = data(:,(2*dose+15+24*(dox-1)));
        vals(drug,getdose(drug,dose),(9-dox),:) = data(:,(2*dose+16+24*(dox-1)));
    end
  end
  fname = sprintf('FLIPR %s %s %s.xls', date, drugsarray(setstart+1), drugsarray(setstart+2));
  data = xlsread(fname,'C4:GL124');
  for dox = 1:8
    drug = setstart + 1;
    for dose = 1:4
      times(drug,(getdose(drug,dose)+4),(9-dox),:) = data(:,(2*(dose-1)+24*(dox-1)+1));
      vals(drug,(getdose(drug,dose)+4),(9-dox),:) = data(:,(2*dose+24*(dox-1)));
    end
    drug = setstart + 2;
    for dose = 1:8
        times(drug,getdose(drug,dose),(9-dox),:) = data(:,(2*(dose-1)+24*(dox-1)+9));
        vals(drug,getdose(drug,dose),(9-dox),:) = data(:,(2*dose+8+24*(dox-1)));
    end
  end
end
xl = zeros(9,2);
yl = zeros(9,2);
co = [1 0.5 0;
      1 0 0;
      0.5 0 0;
      0.25 1 0.25;
      0.25 1 1;
      0 0 1;
      1 0 1;
      0 0 0;];
set(groot,'defaultAxesColorOrder',co)
iter = 1;
for dose = 9:-1:1
  figure(iter)
  clf
  number = 1;
  if (dose ~= 9 && dose ~= 1)
      for drug = 1:6
        subplot(2,3,number)
        for dox = 8:-1:1
          x = times(drug,dose,dox,:);
          y = vals(drug,dose,dox,:);
          p(dox) = plot(x(:),y(:),'linewidth',1);
          hold on
        end
        if include1000 == 0
            delete(p(8))
            delete(p(7))
        end
        comp = xlim;
        if comp(2) > xl(iter,2)
          xlim auto
          xl(iter,2) = comp(2);
        end
        if (comp(1) < xl(iter,1) || xl(iter,1) == 0)
          xlim auto
          xl(iter,1) = comp(1);
        end
        comp = ylim;
        if comp(2) > yl(iter,2)
          ylim auto
          yl(iter,2) = comp(2);
        end
        if (comp(1) < yl(iter,1) || yl(iter,1) == 0)
          ylim auto
          yl(iter,1) = comp(1);
        end
        subplot(2,3,number)
        xlabel('Time (s)')
        ylabel('RFU')
        gname = sprintf('%s (10^{%d} M)', drugs{drug,1}, dose-13);
        title(gname)
        if include1000 == 0
            lgd = legend({'250','100','50','25','10','0'},'location','northeast');
        else
            lgd = legend({'250','200','150','100','50','25','10','0'},'location','northeast');
        end
        title(lgd, 'DOX (ng/mL)')
        %set(lgd,'title','DOX (ng/mL)') % Octave only
        for sp = 1:number
            subplot(2,3,sp)
            xlim(xl(iter,:))
            ylim(yl(iter,:))
        end
        number = number + 1;
      end
  elseif (dose == 1)
      for drug = 1:5:6
        subplot(1,2,number)
        for dox = 8:-1:1
          x = times(drug,dose,dox,:);
          y = vals(drug,dose,dox,:);
          p(dox) = plot(x(:),y(:),'linewidth',1);
          hold on
        end
        if include1000 == 0
            delete(p(8))
            delete(p(7))
        end
        comp = xlim;
        if comp(2) > xl(iter,2)
          xlim auto
          xl(iter,2) = comp(2);
        end
        if (comp(1) < xl(iter,1) || xl(iter,1) == 0)
          xlim auto
          xl(iter,1) = comp(1);
        end
        comp = ylim;
        if comp(2) > yl(iter,2)
          ylim auto
          yl(iter,2) = comp(2);
        end
        if (comp(1) < yl(iter,1) || yl(iter,1) == 0)
          ylim auto
          yl(iter,1) = comp(1);
        end
        subplot(1,2,number)
        xlabel('Time (s)')
        ylabel('RFU')
        gname = sprintf('%s (10^{%d} M)', drugs{drug,1}, dose-13);
        title(gname)
        if include1000 == 0
            lgd = legend({'250','100','50','25','10','0'},'location','northeast');
        else
            lgd = legend({'250','200','150','100','50','25','10','0'},'location','northeast');
        end
        title(lgd, 'DOX (ng/mL)')
        %set(lgd,'title','DOX (ng/mL)') % Octave only
        for sp = 1:number
            subplot(1,2,sp)
            xlim(xl(iter,:))
            ylim(yl(iter,:))
        end
        number = number + 1;
      end
  else
      for drug = 2:5
        subplot(2,2,number)
        for dox = 8:-1:1
          x = times(drug,dose,dox,:);
          y = vals(drug,dose,dox,:);
          p(dox) = plot(x(:),y(:),'linewidth',1);
          hold on
        end
        if include1000 == 0
            delete(p(8))
            delete(p(7))
        end
        comp = xlim;
        if comp(2) > xl(iter,2)
          xlim auto
          xl(iter,2) = comp(2);
        end
        if (comp(1) < xl(iter,1) || xl(iter,1) == 0)
          xlim auto
          xl(iter,1) = comp(1);
        end
        comp = ylim;
        if comp(2) > yl(iter,2)
          ylim auto
          yl(iter,2) = comp(2);
        end
        if (comp(1) < yl(iter,1) || yl(iter,1) == 0)
          ylim auto
          yl(iter,1) = comp(1);
        end
        subplot(2,2,number)
        xlabel('Time (s)')
        ylabel('RFU')
        gname = sprintf('%s (10^{%d} M)', drugs{drug,1}, dose-13);
        title(gname)
        if include1000 == 0
            lgd = legend({'250','100','50','25','10','0'},'location','northeast');
        else
            lgd = legend({'250','200','150','100','50','25','10','0'},'location','northeast');
        end
        title(lgd, 'DOX (ng/mL)')
        %set(lgd,'title','DOX (ng/mL)') % Octave only
        for sp = 1:number
            subplot(2,2,sp)
            xlim(xl(iter,:))
            ylim(yl(iter,:))
        end
        number = number + 1;
      end
  end      
  if include1000 == 0
      fname = sprintf('%s %d no Ang2K no 500', date, dose-13);
  else
      fname = sprintf('%s %d', date, dose-13);
  end
  print('-painters',fname,'-dmeta')
  iter = iter + 1;
end