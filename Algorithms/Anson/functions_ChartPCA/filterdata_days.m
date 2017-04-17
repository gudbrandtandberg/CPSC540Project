function [XS,XF,O,H,L,C,V] = filterdata_lookback(XS,XF,D,O,H,L,C,V)

ndays = length(D);

% Take out the days that are NaN
index_nonNaN_linear = find(~isnan(O));
index_nonNaN_sub = zeros(size(O));
index_nonNaN_sub(index_nonNaN_linear(:)) = 1; % matrix of values with non-NaN
ndays_valid = sum(index_nonNaN_sub,1);

% Now we filter by stocks, then by days
ndays_filter = mode(ndays_valid); % use the charts with the modal number of days
%index_stocks_valid = find(ndays_valid == ndays_filter); % filter out stocks with not many days
index_stocks_invalid = find(ndays_valid ~= ndays_filter); % filter out stocks with not many days

% Filter out stocks that don't have modal number of available days
%ntickers = size(XS(:,1),1);
O(:,index_stocks_invalid)=[]; H(:,index_stocks_invalid)=[]; L(:,index_stocks_invalid)=[];
C(:,index_stocks_invalid)=[]; V(:,index_stocks_invalid)=[];
XS(index_stocks_invalid,:)=[]; XF(index_stocks_invalid,:)=[];

fprintf('Filtering modal days... [%d days, %d stocks]\n',size(O,1),size(O,2))

% Now take out all rows with nans (corresponds to holidays and weekends)
[rows, columns] = find(isnan(O)); % finds the rows and columns of elements that have nan
index_weekendsholidays = unique(rows); % find the unique rows
O(index_weekendsholidays,:)=[]; H(index_weekendsholidays,:)=[]; L(index_weekendsholidays,:)=[];
C(index_weekendsholidays,:)=[]; V(index_weekendsholidays,:)=[];
fprintf('Filtering NaN days... [%d days, %d stocks]\n',size(O,1),size(O,2));

% Make sure there are no more NaNs
if( length(find(isnan(O)))>0 )
  error('NaNs are still in the data. Remove them!')
end
end

