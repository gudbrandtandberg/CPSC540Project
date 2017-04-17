%
% grab_yahoo_chart
%
% Finds daily charts
% Note that the daily chart comes in reverse chronological order, so its required by our program to 
% reverse flip this.
%
function [data,stop]=grab_yahoo_chart(ticker,yearsback)
ticker=upper(ticker);

% Set time to look at daily charts
timenow=now;
[year_now month_now day_now hour_now minute_now second_now]=datevec(timenow);
datenow_str=datestr(timenow,'mm/dd/yyyy');
timeback=datenum([(year_now-yearsback) month_now day_now hour_now minute_now second_now]);
dateback_str=datestr(timeback,'mm/dd/yyyy');

%
% Open connection to yahoo
%
c=yahoo; 
if(isconnection(c)) stop=0;
else stop=1;end

%
% Fetch daily chart data from yahoo 
% Note: we flip the vectors to put them in chronological order as the API gives them in reverse chronological order
% Note: all vectors here are column vectors
%
M=fetch(c,ticker,dateback_str,datenow_str); 
ndata=size(M,1);
D=M(:,1); D=flip(D); 
O=M(:,2); O=flip(O);
H=M(:,3); H=flip(H);
L=M(:,4); L=flip(L);
C=M(:,5); C=flip(C);
V=M(:,6); V=flip(V);
A=M(:,7); A=flip(A);

%
% Compute the adjusted price
%
RATIO_ADJ=A./C; % adjustment ratio term-by-term
OA=O.*RATIO_ADJ; % multiply by the adjustment ratio
HA=H.*RATIO_ADJ; % multiply by the adjustment ratio
LA=L.*RATIO_ADJ; % multiply by the adjustment ratio
CA=C.*RATIO_ADJ; % multiply by the adjustment ratio
VA=V.*RATIO_ADJ; % multiply by the adjustment ratio

%[data,stop]=grab_yahoo_fundamentals(ticker);

% Output the adjusted values
data=struct('ndata',ndata,... % number of data points
                   'date',D,... % date
                   'open',OA,... % opening price
                   'high',HA,... % high price
                   'low',LA,... % low price
                   'close',CA,... % closing price
                   'volume',VA); % volume

close(c); % close connection to yahoo
end

