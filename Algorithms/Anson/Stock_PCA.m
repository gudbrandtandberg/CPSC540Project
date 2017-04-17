function Stock_PCA()
clc; clear all; clearvars 
addpath('functions_IO');

%
% Download all necessary data
%
finviz_dir = '/Users/ansonwong/Desktop/MLF_data/finviz'; % finviz file will be finviz.csv
chart_dir = '/Users/ansonwong/Desktop/MLF_data/charts'; % charts will be XXXX.txt
%datestr_use = datestr(now,'mmm_dd_yyyy');

need_download_finviz = 0; % downloads finviz.csv and places it in finviz_dir
need_download_chart = 0; % downloads all charts into chart_dir based on finviz.csv
need_convert_finviz = 0; % create a finviz.mat that is based off of finviz.csv data (numbers/NaN only)

% Download finviz and chart data (as well as converting finviz data to a
% convenient format)
if(need_download_finviz == 1)
  download_finviz_data(finviz_dir); 
end
if(need_download_chart == 1)
  download_chart_data(chart_dir,finviz_dir) 
end
if(need_convert_finviz == 1)
  data2num_finviz(finviz_dir) 
end

%
% Analyze data now
%

% Load all data
% Now we have 'FHEAD', 'FHEAD_names', 'name_cell', 'data_label', 'data'
finviz2_filename = strcat(finviz_dir,'/finviz.mat');
M = load(finviz2_filename,'-mat');

% Set new data variables
X = M.data'; % n=7091 x d=62
XS = M.name_cell; % n=7091 x 4
FH = M.FHEAD; % structure array with indices for X
FH_name = M.FHEAD_names; % cell array of string n=7091 x 1
clear M
[n,d]=size(X);

%{
    'MarketCap'
    'PE'
    'PEForward'
    'PEG'
    'PS'
    'PB'
    'PCash'
    'PFreeCash'
    'DividendYield'
    'PayoutRatio'
    'EPS'
    'EPSGrowthThisYear'
    'EPSGrowthNextYear'
    'EPSGrowthPast5Years'
    'EPSGrowthNext5Years'
    'SalesGrowth5Years'
    'EPSGrowthLastQuarter'
    'SalesGrowthLastQuarter'
    'SharesOutstanding'
    'Float'
    'InsiderOwnership'
    'InsiderTransactions'
    'InstitutionalOwnership'
    'InstitutionalTransactions'
    'FloatShort'
    'ShortRatio'
    'ReturnOnAssets'
    'ReturnOnEquity'
    'ReturnOnInvestment'
    'CurrentRatio'
    'QuickRatio'
    'LTDebtEquity'
    'TotalDebtEquity'
    'GrossMargin'
    'OperatingMargin'
    'ProfitMargin'
    'PerformanceWeek'
    'PerformanceMonth'
    'PerformanceQuarter'
    'PerformanceHalfYear'
    'PerformanceYear'
    'PerformanceYTD'
    'Beta'
    'AverageTrueRange'
    'VolatilityWeek'
    'VolatilityMonth'
    'SMA20day'
    'SMA50day'
    'SMA200day'
    'High50day'
    'Low50day'
    'High52week'
    'Low52week'
    'RSI14'
    'ChangeFromOpen'
    'Gap'
    'AnalystRecommendation'
    'AverageVolume'
    'RelativeVolume'
    'Price'
    'ChangePercentage'
    'Volume'
    'TargetPrice'
%}

%{
corrcoef(X(:,FH.ReturnOnAssets),X(:,FH.ReturnOnAssets))

%}
% Find the NaN value fractions
if(0)
  fprintf('[n=%d,d=%d]\n',n,d);
  FID = fopen('stats_pca.txt','w');
  for j=1:d
    n_nonnan = sum(~isnan(X(:,j)));
    fprintf('%d) %s (%.0f%% good)\n',j,FH_name{j},100*n_nonnan/n);
    fprintf(FID,'%d) %s (%.0f%% good)\n',j,FH_name{j},100*n_nonnan/n);
  end
  fclose(FID);
end
 
%
% Find a subset of X
%
%index_Xsubset = find(X(:,FH.MarketCap)>100);
index_Xsubset = find(X(:,FH.AverageVolume)>1000);
fprintf('index_subset = %d\n',length(index_Xsubset));
X = X(index_Xsubset,:);

%plot_2var(1,FH.ReturnOnAssets,FH.ChangePercentage,X,FH_name);

% Plot between 2 variables
% 1) Gap, ChangePercentage
% 2) 
%plot_2var(1,FH.ReturnOnAssets,FH.ChangePercentage,X,FH_name);
%plot_2var(1,FH.ReturnOnAssets,FH.ChangePercentage,X,FH_name);
%plot_2var(1,FH.ReturnOnEquity,FH.ChangePercentage,X,FH_name);
%plot_2var(1,FH.ReturnOnEquity,FH.ChangePercentage,X,FH_name);


%
% Use features and reduce to non-NaN, X_nonnan
%
j_list = ...
  [FH.FloatShort,...
   FH.ChangePercentage];
 
size(X)
[X,indices_nan] = collect_nonnan(X,j_list);
size(X)

rho = corr(X,'type','Pearson')
figure(2)
clf(2)
plot(X(:,1),X(:,2),'.');

%[X,indices_nan] = collect_nonnan(X,1:d);


%
% Normalize Xtilde_nonnan = X_nonnan
%
X = standardizeCols(X);

%
% Perform PCA
%
[coeff,score,latent,tsquared,explained] = pca(X);


coeff


for i=1:length(explained)
  fprintf('PC %d = %.1f%%\n',i,explained(i));
end


%{
indices_nan = zeros(n,1);
for j=length(j_list),
  indices_nan = indices_nan + isnan(X(:,j_list(j)));
end
indices_nan = indices_nan > 0;
X(indices_nan,:) = []; % remove tickers without marketcap info

size(X)
sum(~isnan(X)) 
%}

clearvars
rmpath('functions_IO');
end

% Given a j_list, reduces the list so that we have no nans
function [X_new,indices_nan] = collect_nonnan(X,j_list)
[n,d]=size(X);

% Find ticker indices that are nan in j_list
indices_nan = zeros(n,1);
for j=1:length(j_list),
  indices_nan = indices_nan + isnan(X(:,j_list(j)));
end
indices_nan = indices_nan > 0;
indices_nonnan = ~indices_nan;

% Make new X
X_new = X(indices_nonnan,:);
vec_setempty = 1:d;
vec_setempty(j_list) = [];
X_new(:,vec_setempty) = [];

% Make sure every value of X_new is non-nan
if( any( diff(sum(~isnan(X_new))) ) )
  error('collect_nonnan did not work')
end

end

function plot_2var(fignum,jx,jy,X,FH_name)
index_nonnan = find(~isnan(X(:,jx)) & ~isnan(X(:,jy)));
xplot = X(index_nonnan,jx); yplot = X(index_nonnan,jy);
figure(fignum)
clf(fignum)
plot(xplot,yplot,'.')
hold on
xlabel(FH_name{jx});
ylabel(FH_name{jy});
hold off
end

