function Stock_PCA()
clc; clear all; clearvars 
addpath('functions_IO');
addpath('functions_ChartPCA');

% Set code parameters
PC_number = 1;
dt = 11;
t0 = 1;

%%%%%%%%%%%%%%%%%%%%%
%
% Download data
%
%%%%%%%%%%%%%%%%%%%%%
finviz_dir = '/Users/ansonwong/Desktop/MLF_data/finviz'; % finviz file will be finviz.csv
chart_dir = '/Users/ansonwong/Desktop/MLF_data/charts'; % charts will be XXXX.txt
chart_PCA_dir = '/Users/ansonwong/Desktop/MLF_data/chart_PCA'; 

need_download_finviz = 0; % downloads finviz.csv and places it in finviz_dir
need_download_charts = 0; % downloads all charts into chart_dir based on finviz.csv
need_convert_finviz = 0; % create a finviz.mat that is based off of finviz.csv data (numbers/NaN only)
need_convert_charts = 0; % takes the charts from chart_dir and makes a large .mat file from them

% Download finviz and chart data (as well as converting finviz data to a convenient format)
if(need_download_finviz == 1), download_finviz_data(finviz_dir); end
if(need_download_charts == 1), download_chart_data(chart_dir,finviz_dir); end
if(need_convert_finviz == 1), data2num_finviz(finviz_dir); end


%%%%%%%%%%%%%%%%%%%%%
%
% Load data
%
%%%%%%%%%%%%%%%%%%%%%
% Now we have 'FHEAD', 'FHEAD_names', 'name_cell', 'data_label', 'data'
% Convert charts and save, or load them from last save
% Now we have: XF, XS, FH, FH_name, D, O, H, L, C, V
[XF,XS,FH,FH_name,day_begin,day_end,D,O,H,L,C,V] = loaddata(chart_PCA_dir,chart_dir,finviz_dir,need_convert_charts);
fprintf('Input raw data... [%d days, %d stocks] (%.2f%% are NaN values inside)\n',...
        size(O,1),size(O,2),100*sum(sum(isnan(O)))/(size(O,1)*size(O,2)));

%%%%%%%%%%%%%%%%%%%%%
%
% Clean data and filter stocks automatically
%
%%%%%%%%%%%%%%%%%%%%%
% 1) Do some data cleaning (sector)
% 2) Filter data (lookback days, NaN values, weekends, modal number of days)
XS = dataclean_XS(XS); % change a few names
[XS,XF,O,H,L,C,V] = filterdata_days(XS,XF,D,O,H,L,C,V); % filter the data to be 

%%%%%%%%%%%%%%%%%%%%%
%
% Filter stocks manually with your own criteria
%
%%%%%%%%%%%%%%%%%%%%%
% Filter stocks by their fundamentals
filter_stocks_by_fundamentals = 1;
if(filter_stocks_by_fundamentals == 1)
  ntickers = size(V,2); list_accept = []; list_ignore = [];
  for i=1:ntickers
    
    average_volume = mean(V(:,i));
    
    %condition = average_volume > 30000 && strcmp(XS(i,3),'Financial')~=1 ; 
    %condition = average_volume > 30000 && strcmp(XS(i,3),'Technology')==1 ; 
    % condition = average_volume > 200000 && XF(i,find(strcmp(FH_name,'PerformanceWeek')==1) ) > 5  &&  strcmp(XS(i,3),'Financial')~=1 ;
    condition = average_volume > 300000 ;
    %condition = average_volume > 30000 && strcmp(XS(i,4),'Exchange Traded Fund')~=1 ;
    
    if(condition == 1), list_accept = [list_accept, i];
    else list_ignore = [list_ignore, i];
    end
  end
  
  O(:,list_ignore)=[]; H(:,list_ignore)=[]; L(:,list_ignore)=[];
  C(:,list_ignore)=[]; V(:,list_ignore)=[];
  XS(list_ignore,:)=[]; XF(list_ignore,:)=[];
  
  fprintf('Filtering fundamental conditions... [%d days, %d stocks]\n',size(O,1),size(O,2));
  
  % Report sectors of this filter
  report_sectors(XS,'Filtered')
end

%%%%%%%%%%%%%%%%%%%%%
%
% Perform PCA
%
%%%%%%%%%%%%%%%%%%%%%
O_full = O; H_full = H; L_full = L; C_full = C; V_full = V;
PercChange_full = 100*(C-O)./O;

% Prepare for PCA
time_window = t0:(t0+dt-1); % 1=first day, 2=most recent day
fprintf('Taking time window [%d,%d] of [%d,%d]\n',t0,t0+dt-1,1,size(O_full,1));
O = O_full; H = H_full; L = L_full; C = C_full; V = V_full;
PercChange = PercChange_full;

O=O(time_window,:); H=H(time_window,:); L=L(time_window,:);
C=C(time_window,:); V=V(time_window,:);
PercChange=PercChange(time_window,:);

X = PercChange;
X = standardizeCols(X);

fprintf('Performing PCA on X = [%d,%d]...\n',size(X,1),size(X,2));
[coeff,score,latent,tsquared,explained] = pca(X);
size(coeff);

% PCA first
PC = coeff(:,PC_number);
fprintf('Performing PCA (standardize=1, PClength=%d)...\n',length(PC));

fprintf('Variance explained by each principal component (> 1%%)...\n');
for i=1:length(explained)
  if(explained(i)>1)
    fprintf('  PC %d = %.1f%%\n',i,explained(i));
  end
end

[~,indices_important] = sort(PC,'descend');

sis = indices_important( find(PC(indices_important)>1/sqrt(length(PC))) );
nsis = indices_important( find(PC(indices_important)<-1/sqrt(length(PC))) );

n_original = length(PC);
n_strong = length(sis);
n_nstrong = length(nsis);

fprintf('\n')
fprintf('Take top pos-corr %d of PC %d: %d stocks -> %d stocks\n',n_strong,PC_number,n_original,n_strong);
fprintf('Take top neg-corr %d of PC %d: %d stocks -> %d stocks\n',n_nstrong,PC_number,n_original,n_nstrong);
fprintf('\n')

ticker_strong_stocks = XS(sis,1);
companyname_strong_stocks = XS(sis,2);
sector_strong_stocks = XS(sis,3);
industry_strong_stocks = XS(sis,4);
country_strong_stocks = XS(sis,5);

ticker_nstrong_stocks = XS(nsis,1);
companyname_nstrong_stocks = XS(nsis,2);
sector_nstrong_stocks = XS(nsis,3);
industry_nstrong_stocks = XS(nsis,4);
country_nstrong_stocks = XS(nsis,5);


fprintf('Stocks in a pos-porr strong family\n');
[Ctry,ia,ic] = unique(sector_strong_stocks);
N_sectors_strong = length(Ctry);
for i=1:N_sectors_strong
  n_ic = sum(ic==i);
  fprintf(' %s (%d = %.1f%%)\n',Ctry{i},n_ic,100*n_ic/length(ic));
end
fprintf('\n');
%{
[Ctry,ia,ic] = unique(industry_strong_stocks); % ia (index of first appearance)
N_industries_strong = length(Ctry);
for i=1:N_industries_strong
  n_ic = sum(ic==i);
  fprintf(' %s (%d = %.1f%%)\n',Ctry{i},n_ic,100*n_ic/length(ic));
end
fprintf('\n');
%}

fprintf('Stocks in a neg-corr strong family\n');
[Ctry,ia,ic] = unique(sector_nstrong_stocks);
N_nsectors_strong = length(Ctry);
for i=1:N_nsectors_strong
  n_ic = sum(ic==i);
  fprintf(' %s (%d = %.1f%%)\n',Ctry{i},n_ic,100*n_ic/length(ic));
end
fprintf('\n');

%{
for i=1:n_important
  ticker_str = ticker_strong_stocks(i);
  company_str = companyname_strong_stocks(i);
  sector_str = sector_strong_stocks(i);
  fprintf(' %d) %s = %s [%s]\n',i,ticker_str{1},company_str{1},sector_str{1});
end
%}

%companyname_strong_stocks


figure(7)
clf(7)
for i=1:n_strong
  if(i==2), hold on; end
  plot(1:length(PercChange(:,sis(i))),PercChange(:,sis(i)),'.')
end
title('pos-corr stock family from PC1 individual stock percentage change')
xlabel('days')
ylabel('price % change')
hold off;
drawnow;

figure(8)
clf(8)
for i=1:n_nstrong
  if(i==2), hold on; end
  plot(1:length(PercChange(:,nsis(i))),PercChange(:,nsis(i)),'.')
end
title('neg-corr stock family from PC1 individual stock percentage change')
xlabel('days')
ylabel('price % change')
hold off;
drawnow;




index_stock_JXI = find_stock_index(XS,'JXI');
index_stock_FNX = find_stock_index(XS,'ACWI');



index_stock_JXI = 1
index_stock_FNX = 2

figure(9)
clf(9)
plot(PercChange_full(time_window,index_stock_JXI),PercChange_full(time_window,index_stock_FNX),'.')
title('New shit alert')
xlabel('JXI oc %%')
ylabel('FNX pc %%')


norm(PC)

figure(9)
clf(9)
plot(1:length(PC),100*PC(indices_important),'b.');
hold on
plot(1:length(PC),100*1/sqrt(length(PC)),'r.');
plot(1:length(PC),-100*1/sqrt(length(PC)),'r.');
title('PC1')
xlabel('stocks')
ylabel('PC component')
hold off



%{
figure(8)
clf(8)
aaa = mean(PercChange_strong_stocks,2);
plot(1:length(aaa),aaa,'-');
title('Strong stock family from PC1 average percentage change')
%plot(bbb,aaa,'-');

figure(9)
clf(9)
plotthis = (C(:,stock_indices_strongest_PC)-O(:,stock_indices_strongest_PC))./(H(:,stock_indices_strongest_PC)-O(:,stock_indices_strongest_PC));
for i=1:n_important
  if(i==2), hold on; end
  plot(1:length(plotthis(:,i)),plotthis(:,i),'-')
end
title('Strong stock family from PC1 closing price')
hold off;
drawnow;
%}

clearvars
rmpath('functions_IO');
rmpath('functions_ChartPCA');
end

function [index_stock]=find_stock_index(XS,str)
  index_stock = find(strcmp(XS(:,1),str)==1);
end

