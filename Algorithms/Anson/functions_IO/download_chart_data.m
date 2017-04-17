function download_chart_data(chart_dir,finviz_dir)
clearvars -except chart_dir finviz_dir
addpath('functions');

finviz_data_fullname = strcat(finviz_dir,'/finviz.csv');
[finviz_data,stop]=grab_all_finviz_data(finviz_data_fullname);
[N,d] = size(finviz_data);

print_dailycharts=1;
yearsback=2;
for i=1:N
  % Retrieve daily charts
  ticker_cell=finviz_data(i,1);
  ticker=upper(ticker_cell{1});
  output_chart_filename = strcat(chart_dir,'/',ticker,'.txt');
  
  if(exist(output_chart_filename,'file')==2)
    fprintf('%d/%d) Ticker %s daily chart exists already!\n',i,N,ticker);
  else
    fprintf('%d/%d) Downloading ticker %s daily chart (print=%d)...\n',i,N,ticker,print_dailycharts);
    try
      
      [data,stop]=grab_yahoo_chart(ticker,yearsback);
      % Print into a text file
      % The data vectors (for example data.open) come as column vectors
      if(print_dailycharts==1)
        FID = fopen(output_chart_filename,'w');
        A = [data.date'; data.open'; data.high'; data.low'; data.close'; data.volume'];
        fprintf(FID,'%d %f %f %f %f %e\n',A);
        fclose(FID);
      end
      
    catch
    end
  end
  
  
end
end

