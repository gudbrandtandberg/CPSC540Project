function [XF,XS,FH,FH_name,day_begin,day_end,D,O,H,L,C,V] = loaddata(chart_PCA_dir,chart_dir,finviz_dir,need_convert_charts)

  save_filename = strcat(chart_PCA_dir,'/charts.mat');
  finviz2_filename = strcat(finviz_dir,'/finviz.mat');
  M = load(finviz2_filename,'-mat');
  
  XF = M.data'; % n=7088 x d=62
  XS = M.name_cell; % n=7088 x 4
  FH = M.FHEAD; % structure array with indices for X
  FH_name = M.FHEAD_names; % cell array of string n=7091 x 1
  clear M

  % Find day_begin and day_end (based on AAPL chart)
  AAPL_filename = strcat(chart_dir,'/AAPL.txt');
  FID = fopen(AAPL_filename,'r');
  M = fscanf(FID,'%d %f %f %f %f %f',[6 inf]);
  fclose(FID);
  day_end = max(M(1,:));
  day_begin = min(M(1,:));
  clear M
  
  ntickers = size(XS(:,1),1);
  if(need_convert_charts == 1)  
    ndays = day_end - day_begin + 1;
    D = day_begin:day_end;
    O = NaN(ndays,ntickers);
    H = NaN(ndays,ntickers);
    L = NaN(ndays,ntickers);
    C = NaN(ndays,ntickers);
    V = NaN(ndays,ntickers);
    
    for i=1:ntickers
      ticker_str = XS{i,1};
      chart_filename = strcat(chart_dir,'/',ticker_str,'.txt');
      fprintf('%d) %s\n',i,chart_filename);
      
      if( ~(exist(chart_filename, 'file') == 2) ), continue; end
      
      FID = fopen(chart_filename,'r');
      A = fscanf(FID,'%d %f %f %f %f %f',[6,inf]);
      fclose(FID);
      [Lia,Lib] = ismember(D,A(1,:)); % find index of available days
      Lianew = find(Lia==1); Libnew = Lib(Lianew);
      
      O(Lianew(:),i) = A(2,Libnew(:));
      H(Lianew(:),i) = A(3,Libnew(:));
      L(Lianew(:),i) = A(4,Libnew(:));
      C(Lianew(:),i) = A(5,Libnew(:));
      V(Lianew(:),i) = A(6,Libnew(:));
      
      if(size(A,1)==0 && size(A,2)==0), continue; end
      
    end
    fprintf('Saving data into %s...\n',save_filename);
    save(save_filename,'D','O','H','L','C','V');
  else
    load(save_filename);
  end
  
end

