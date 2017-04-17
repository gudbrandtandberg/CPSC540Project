%
% grab_all_finviz_data
%
% Assuming you have downloaded the finviz data as "finviz_data_fullname",
% We open the file and process the information as strings
function [finviz_data,stop]=grab_all_finviz_data(finviz_data_fullname)
stop=0;
if(nargin~=1), display('need at least 2 parameter!'); stop=1; end

% Read the csv file as strings
fid=fopen(finviz_data_fullname);
M=textscan(fid,'%s',...
                   'delimiter','\t','emptyvalue',inf,...
                   'collectoutput',1,...
                   'EmptyValue',Inf);
fclose(fid);

var=textscan(M{1}{1},'%s','delimiter',',','EmptyValue',Inf);
var=var{1};
Nvar=size(var,1);
for i=1:Nvar,
  var{i}=var{i}(2:end-1);
end

% Find the number of variables along with number of tickers
Nticker=size(M{1},1)-1;

% Read variable names
N_name_str=5;
number_str=cell(Nticker,Nvar);
for i=1:Nticker,
  
  TFdata=textscan(M{1}{i+1},'%s','delimiter','"','EmptyValue',Inf); % accounted for header
  N_TFdata=size(TFdata{1},1);
  if(N_TFdata~=2*N_name_str+1), fprintf('Wrong front string expectation!\n'); return; end
  % Process the company name and industries
  for j=1:N_name_str,
    number_str{i,j}=TFdata{1}{2*j};
  end
  
  TDdata=textscan(TFdata{1}{2*N_name_str+1},'%s','delimiter',',','EmptyValue',Inf);
  N_TDdata=size(TDdata{1},1);
  % Process number data (keep them as strings)
  for j=(N_name_str+1):Nvar,
    if(j<N_TDdata+N_name_str), number_str{i,j}=TDdata{1}{j-N_name_str+1}; 
    else number_str{i,j}=''; end % if the ends is empty
  end
  
end

finviz_data = number_str;

end