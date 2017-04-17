function data2num_finviz(finviz_dir)
clearvars -except finviz_dir
addpath('functions');

% Finviz data is a cell matrix (n_tickers x n_vars)
finviz_filename=strcat(finviz_dir,'/finviz.csv');
[finviz_data,stop]=grab_all_finviz_data(finviz_filename);

FINHEAD = set_finviz_labels(); % global index for each column in finviz.csv
%FINHEAD_names = fieldnames(FINHEAD); % cell of field name strings

% Numbers file
% FHEAD is the local index we decide to output (FHEAD_names is its
% fieldnames)
ntickers=size(finviz_data,1);
if(1)
  
  data = [];
  i=1;
  
  MarketCap_vec = convert2numvec( finviz_data(:,FINHEAD.MarketCap) ); data = [data; MarketCap_vec']; FHEAD=struct('MarketCap',{i}); i=i+1; 
  PE_vec = convert2numvec( finviz_data(:,FINHEAD.PE) ); data = [data; PE_vec']; [FHEAD(:).PE]=i; i=i+1; 
  PEForward_vec = convert2numvec( finviz_data(:,FINHEAD.PEForward) ); data = [data; PEForward_vec']; [FHEAD(:).PEForward]=i; i=i+1;  
  PEG_vec = convert2numvec( finviz_data(:,FINHEAD.PEG) ); data = [data; PEG_vec']; [FHEAD(:).PEG]=i; i=i+1;  
  
  PS_vec = convert2numvec( finviz_data(:,FINHEAD.PS) ); data = [data; PS_vec']; [FHEAD(:).PS]=i; i=i+1;
  PB_vec = convert2numvec( finviz_data(:,FINHEAD.PB) ); data = [data; PB_vec']; [FHEAD(:).PB]=i; i=i+1;
  PCash_vec = convert2numvec( finviz_data(:,FINHEAD.PCash) ); data = [data; PCash_vec']; [FHEAD(:).PCash]=i; i=i+1;
  PFreeCash_vec = convert2numvec( finviz_data(:,FINHEAD.PFreeCash) ); data = [data; PFreeCash_vec']; [FHEAD(:).PFreeCash]=i; i=i+1;
  DividendYield_vec = convert2numvec( finviz_data(:,FINHEAD.DividendYield) ); data = [data; DividendYield_vec']; [FHEAD(:).DividendYield]=i; i=i+1;
  PayoutRatio_vec = convert2numvec( finviz_data(:,FINHEAD.PayoutRatio) ); data = [data; PayoutRatio_vec']; [FHEAD(:).PayoutRatio]=i; i=i+1;
  
  EPS_vec = convert2numvec( finviz_data(:,FINHEAD.EPS) ); data = [data; EPS_vec']; [FHEAD(:).EPS]=i; i=i+1;
  EPSGrowthThisYear_vec = convert2numvec( finviz_data(:,FINHEAD.EPSGrowthThisYear) ); data = [data; EPSGrowthThisYear_vec']; [FHEAD(:).EPSGrowthThisYear]=i; i=i+1; 
  EPSGrowthNextYear_vec = convert2numvec( finviz_data(:,FINHEAD.EPSGrowthNextYear) ); data = [data; EPSGrowthNextYear_vec']; [FHEAD(:).EPSGrowthNextYear]=i; i=i+1;
  EPSGrowthPast5Years_vec = convert2numvec( finviz_data(:,FINHEAD.EPSGrowthPast5Years) ); data = [data; EPSGrowthPast5Years_vec']; [FHEAD(:).EPSGrowthPast5Years]=i; i=i+1;
  EPSGrowthNext5Years_vec = convert2numvec( finviz_data(:,FINHEAD.EPSGrowthNext5Years) ); data = [data; EPSGrowthNext5Years_vec']; [FHEAD(:).EPSGrowthNext5Years]=i; i=i+1;
  
  SalesGrowth5Years_vec = convert2numvec( finviz_data(:,FINHEAD.SalesGrowth5Years) ); data = [data; SalesGrowth5Years_vec']; [FHEAD(:).SalesGrowth5Years]=i; i=i+1;
  EPSGrowthLastQuarter_vec = convert2numvec( finviz_data(:,FINHEAD.EPSGrowthLastQuarter) ); data = [data; EPSGrowthLastQuarter_vec']; [FHEAD(:).EPSGrowthLastQuarter]=i; i=i+1;
  SalesGrowthLastQuarter_vec = convert2numvec( finviz_data(:,FINHEAD.SalesGrowthLastQuarter) ); data = [data; SalesGrowthLastQuarter_vec']; [FHEAD(:).SalesGrowthLastQuarter]=i; i=i+1;
  SharesOutstanding_vec = convert2numvec( finviz_data(:,FINHEAD.SharesOutstanding) ); data = [data; SharesOutstanding_vec']; [FHEAD(:).SharesOutstanding]=i; i=i+1;
  
  Float_vec = convert2numvec( finviz_data(:,FINHEAD.Float) ); data = [data; Float_vec']; [FHEAD(:).Float]=i; i=i+1;
  InsiderOwnership_vec  = convert2numvec( finviz_data(:,FINHEAD.InsiderOwnership) ); data = [data; InsiderOwnership_vec']; [FHEAD(:).InsiderOwnership]=i; i=i+1;
  InsiderTransactions_vec  = convert2numvec( finviz_data(:,FINHEAD.InsiderTransactions) ); data = [data; InsiderTransactions_vec']; [FHEAD(:).InsiderTransactions]=i; i=i+1;
  InstitutionalOwnership_vec = convert2numvec( finviz_data(:,FINHEAD.InstitutionalOwnership) ); data = [data; InstitutionalOwnership_vec']; [FHEAD(:).InstitutionalOwnership]=i; i=i+1;
  InstitutionalTransactions_vec = convert2numvec( finviz_data(:,FINHEAD.InstitutionalTransactions) ); data = [data; InstitutionalTransactions_vec']; [FHEAD(:).InstitutionalTransactions]=i; i=i+1;
  
  FloatShort_vec  = convert2numvec( finviz_data(:,FINHEAD.FloatShort) ); data = [data; FloatShort_vec']; [FHEAD(:).FloatShort]=i; i=i+1;
  ShortRatio_vec = convert2numvec( finviz_data(:,FINHEAD.ShortRatio) ); data = [data; ShortRatio_vec']; [FHEAD(:).ShortRatio]=i; i=i+1; 
  
  ReturnOnAssets_vec = convert2numvec( finviz_data(:,FINHEAD.ReturnOnAssets) ); data = [data; ReturnOnAssets_vec']; [FHEAD(:).ReturnOnAssets]=i; i=i+1;
  ReturnOnEquity_vec = convert2numvec( finviz_data(:,FINHEAD.ReturnOnEquity) ); data = [data; ReturnOnEquity_vec']; [FHEAD(:).ReturnOnEquity]=i; i=i+1;
  ReturnOnInvestment_vec = convert2numvec( finviz_data(:,FINHEAD.ReturnOnInvestment) ); data = [data; ReturnOnInvestment_vec']; [FHEAD(:).ReturnOnInvestment]=i; i=i+1;
  CurrentRatio_vec = convert2numvec( finviz_data(:,FINHEAD.CurrentRatio) ); data = [data; CurrentRatio_vec']; [FHEAD(:).CurrentRatio]=i; i=i+1;
  QuickRatio_vec = convert2numvec( finviz_data(:,FINHEAD.QuickRatio) ); data = [data; QuickRatio_vec']; [FHEAD(:).QuickRatio]=i; i=i+1;
  LTDebtEquity_vec = convert2numvec( finviz_data(:,FINHEAD.LTDebtEquity) ); data = [data; LTDebtEquity_vec']; [FHEAD(:).LTDebtEquity]=i; i=i+1;
  TotalDebtEquity_vec = convert2numvec( finviz_data(:,FINHEAD.TotalDebtEquity) ); data = [data; TotalDebtEquity_vec']; [FHEAD(:).TotalDebtEquity]=i; i=i+1;
  
  GrossMargin_vec  = convert2numvec( finviz_data(:,FINHEAD.GrossMargin) ); data = [data; GrossMargin_vec']; [FHEAD(:).GrossMargin]=i; i=i+1;
  OperatingMargin_vec  = convert2numvec( finviz_data(:,FINHEAD.OperatingMargin) ); data = [data; OperatingMargin_vec']; [FHEAD(:).OperatingMargin]=i; i=i+1;
  ProfitMargin_vec  = convert2numvec( finviz_data(:,FINHEAD.ProfitMargin) ); data = [data; ProfitMargin_vec']; [FHEAD(:).ProfitMargin]=i; i=i+1;
  
  PerformanceWeek_vec  = convert2numvec( finviz_data(:,FINHEAD.PerformanceWeek) ); data = [data; PerformanceWeek_vec']; [FHEAD(:).PerformanceWeek]=i; i=i+1;
  PerformanceMonth_vec  = convert2numvec( finviz_data(:,FINHEAD.PerformanceMonth) ); data = [data; PerformanceMonth_vec']; [FHEAD(:).PerformanceMonth]=i; i=i+1;
  PerformanceQuarter_vec  = convert2numvec( finviz_data(:,FINHEAD.PerformanceQuarter) ); data = [data; PerformanceQuarter_vec']; [FHEAD(:).PerformanceQuarter]=i; i=i+1;
  PerformanceHalfYear_vec  = convert2numvec( finviz_data(:,FINHEAD.PerformanceHalfYear) ); data = [data; PerformanceHalfYear_vec']; [FHEAD(:).PerformanceHalfYear]=i; i=i+1;
  PerformanceYear_vec  = convert2numvec( finviz_data(:,FINHEAD.PerformanceYear) ); data = [data; PerformanceYear_vec']; [FHEAD(:).PerformanceYear]=i; i=i+1;
  PerformanceYTD_vec  = convert2numvec( finviz_data(:,FINHEAD.PerformanceYTD) ); data = [data; PerformanceYTD_vec']; [FHEAD(:).PerformanceYTD]=i; i=i+1;
  
  Beta_vec = convert2numvec( finviz_data(:,FINHEAD.Beta) ); data = [data; Beta_vec']; [FHEAD(:).Beta]=i; i=i+1;
  AverageTrueRange_vec = convert2numvec( finviz_data(:,FINHEAD.AverageTrueRange) ); data = [data; AverageTrueRange_vec']; [FHEAD(:).AverageTrueRange]=i; i=i+1;
  VolatilityWeek_vec = convert2numvec( finviz_data(:,FINHEAD.VolatilityWeek) ); data = [data; VolatilityWeek_vec']; [FHEAD(:).VolatilityWeek]=i; i=i+1;
  VolatilityMonth_vec = convert2numvec( finviz_data(:,FINHEAD.VolatilityMonth) ); data = [data; VolatilityMonth_vec']; [FHEAD(:).VolatilityMonth]=i; i=i+1;
  
  SMA20day_vec  = convert2numvec( finviz_data(:,FINHEAD.SMA20day) ); data = [data; SMA20day_vec']; [FHEAD(:).SMA20day]=i; i=i+1;
  SMA50day_vec  = convert2numvec( finviz_data(:,FINHEAD.SMA50day) ); data = [data; SMA50day_vec']; [FHEAD(:).SMA50day]=i; i=i+1;
  SMA200day_vec  = convert2numvec( finviz_data(:,FINHEAD.SMA200day) ); data = [data; SMA200day_vec']; [FHEAD(:).SMA200day]=i; i=i+1;
  
  High50day_vec  = convert2numvec( finviz_data(:,FINHEAD.High50day) ); data = [data; High50day_vec']; [FHEAD(:).High50day]=i; i=i+1;
  Low50day_vec  = convert2numvec( finviz_data(:,FINHEAD.Low50day) ); data = [data; Low50day_vec']; [FHEAD(:).Low50day]=i; i=i+1;
  High52week_vec  = convert2numvec( finviz_data(:,FINHEAD.High52week) ); data = [data; High52week_vec']; [FHEAD(:).High52week]=i; i=i+1;
  Low52week_vec  = convert2numvec( finviz_data(:,FINHEAD.Low52week) ); data = [data; Low52week_vec']; [FHEAD(:).Low52week]=i; i=i+1;
  
  RSI14_vec = convert2numvec( finviz_data(:,FINHEAD.RSI14) ); data = [data; RSI14_vec']; [FHEAD(:).RSI14]=i; i=i+1;
  ChangeFromOpen_vec = convert2numvec( finviz_data(:,FINHEAD.ChangeFromOpen) ); data = [data; ChangeFromOpen_vec']; [FHEAD(:).ChangeFromOpen]=i; i=i+1;
  Gap_vec = convert2numvec( finviz_data(:,FINHEAD.Gap) ); data = [data; Gap_vec']; [FHEAD(:).Gap]=i; i=i+1;
  AnalystRecommendation_vec = convert2numvec( finviz_data(:,FINHEAD.AnalystRecommendation) ); data = [data; AnalystRecommendation_vec']; [FHEAD(:).AnalystRecommendation]=i; i=i+1;
  AverageVolume_vec = convert2numvec( finviz_data(:,FINHEAD.AverageVolume) ); data = [data; AverageVolume_vec']; [FHEAD(:).AverageVolume]=i; i=i+1;
  RelativeVolume_vec = convert2numvec( finviz_data(:,FINHEAD.RelativeVolume) ); data = [data; RelativeVolume_vec']; [FHEAD(:).RelativeVolume]=i; i=i+1;
  Price_vec = convert2numvec( finviz_data(:,FINHEAD.Price) ); data = [data; Price_vec']; [FHEAD(:).Price]=i; i=i+1;
  ChangePercentage_vec = convert2numvec( finviz_data(:,FINHEAD.ChangePercentage) ); data = [data; ChangePercentage_vec']; [FHEAD(:).ChangePercentage]=i; i=i+1;
  Volume_vec = convert2numvec( finviz_data(:,FINHEAD.Volume) ); data = [data; Volume_vec']; [FHEAD(:).Volume]=i; i=i+1; 
  %TargetPrice_vec = convert2numvec( finviz_data(:,FINHEAD.TargetPrice) ); data = [data; TargetPrice_vec']; [FHEAD(:).TargetPrice]=i; i=i+1;
  
  
  FHEAD_names = fieldnames(FHEAD); % cell of field name strings
  
  % Save name cells
  name_cell = cell(ntickers,5);
  for i=1:ntickers
    cell_print = finviz_data(i,FINHEAD.Ticker);
    name_cell{i,1} = cell_print{1};
    cell_print = finviz_data(i,FINHEAD.Company);
    name_cell{i,2} = cell_print{1};
    cell_print = finviz_data(i,FINHEAD.Sector);
    name_cell{i,3} = cell_print{1};
    cell_print = finviz_data(i,FINHEAD.Industry);
    name_cell{i,4} = cell_print{1};
    cell_print = finviz_data(i,FINHEAD.Country);
    name_cell{i,5} = cell_print{1};
  end
  
  % Save all data into data2.mat
  output_matfile = strcat(finviz_dir,'/finviz.mat');
  save(output_matfile,'FHEAD','FHEAD_names','name_cell','data');

end

rmpath('functions');
end

function [numvec]=convert2numvec(cellvec)
fprintf('Converting 2 numvec...\n')
n = length(cellvec);
numvec=zeros(n,1);
for i=1:n
  cellvec_i = cellvec(i);
  numstring_i = cellvec_i{1};
  if(strcmp(numstring_i,'')==1)
    numvec(i) = NaN;
  elseif(strcmp(numstring_i(end),'%')==1)
    numstring_i = numstring_i(1:end-1);
    numvec(i) = str2num(numstring_i);
  else
    numvec(i) = str2num(numstring_i);
  end
end
end

function [FINHEAD]=set_finviz_labels()
FINHEAD = struct('Ticker',{1});
[FINHEAD(:).Company]=2;
[FINHEAD(:).Sector]=3;
[FINHEAD(:).Industry]=4;
[FINHEAD(:).Country]=5;

[FINHEAD(:).MarketCap]=6;
[FINHEAD(:).PE]=7;
[FINHEAD(:).PEForward]=8;
[FINHEAD(:).PEG]=9;

[FINHEAD(:).PS]=10;
[FINHEAD(:).PB]=11;
[FINHEAD(:).PCash]=12;
[FINHEAD(:).PFreeCash]=13;
[FINHEAD(:).DividendYield]=14;
[FINHEAD(:).PayoutRatio]=15;

[FINHEAD(:).EPS]=16;%
[FINHEAD(:).EPSGrowthThisYear]=17;%
[FINHEAD(:).EPSGrowthNextYear]=18;%
[FINHEAD(:).EPSGrowthPast5Years]=19;%
[FINHEAD(:).EPSGrowthNext5Years]=20;%

[FINHEAD(:).SalesGrowth5Years]=21; %
[FINHEAD(:).EPSGrowthLastQuarter]=22;% 
[FINHEAD(:).SalesGrowthLastQuarter]=23;%
[FINHEAD(:).SharesOutstanding]=24;%

[FINHEAD(:).Float]=25;%
[FINHEAD(:).InsiderOwnership]=26; %
[FINHEAD(:).InsiderTransactions]=27; %
[FINHEAD(:).InstitutionalOwnership]=28; %
[FINHEAD(:).InstitutionalTransactions]=29; %

[FINHEAD(:).FloatShort]=30; %
[FINHEAD(:).ShortRatio]=31; %

[FINHEAD(:).ReturnOnAssets]=32;
[FINHEAD(:).ReturnOnEquity]=33;
[FINHEAD(:).ReturnOnInvestment]=34;
[FINHEAD(:).CurrentRatio]=35;
[FINHEAD(:).QuickRatio]=36;
[FINHEAD(:).LTDebtEquity]=37;
[FINHEAD(:).TotalDebtEquity]=38;

[FINHEAD(:).GrossMargin]=39; %
[FINHEAD(:).OperatingMargin]=40; %
[FINHEAD(:).ProfitMargin]=41; %

[FINHEAD(:).PerformanceWeek]=42; %
[FINHEAD(:).PerformanceMonth]=43; %
[FINHEAD(:).PerformanceQuarter]=44;%
[FINHEAD(:).PerformanceHalfYear]=45; % 
[FINHEAD(:).PerformanceYear]=46; %
[FINHEAD(:).PerformanceYTD]=47; %

[FINHEAD(:).Beta]=48;
[FINHEAD(:).AverageTrueRange]=49;
[FINHEAD(:).VolatilityWeek]=50;
[FINHEAD(:).VolatilityMonth]=51;

[FINHEAD(:).SMA20day]=52; %
[FINHEAD(:).SMA50day]=53; %
[FINHEAD(:).SMA200day]=54; %

[FINHEAD(:).High50day]=55; %
[FINHEAD(:).Low50day]=56; %
[FINHEAD(:).High52week]=57; %
[FINHEAD(:).Low52week]=58;%

[FINHEAD(:).RSI14]=59; %
[FINHEAD(:).ChangeFromOpen]=60; %
[FINHEAD(:).Gap]=61; %
[FINHEAD(:).AnalystRecommendation]=62; %
[FINHEAD(:).AverageVolume]=63; %
[FINHEAD(:).RelativeVolume]=64; %
[FINHEAD(:).Price]=65; %
[FINHEAD(:).ChangePercentage]=66; %
[FINHEAD(:).Volume]=67; %
[FINHEAD(:).EarningsDate]=68; 
[FINHEAD(:).TargetPrice]=69;
[FINHEAD(:).IPODate]=70; 
end


