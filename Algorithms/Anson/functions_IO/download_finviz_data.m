function download_finviz_data(destination_dir)
clearvars -except destination_dir
source_dir = '/Users/ansonwong/Downloads';
source_filename=strcat(source_dir,'/finviz.csv');
destination_filename=strcat(destination_dir,'/finviz.csv');

% Download finviz data using my default browser
finviz_URL_full=...
  strcat('http://finviz.com/export.ashx?v=152&ft=4',...
            '&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72');
web(finviz_URL_full,'-browser'); 

% Wait for the download to finish
fprintf('Downloaded ''%s'' (success=%d)\n',source_filename,wait_for_existence(source_filename));

% Now that the download has finished, move the file to our destination directory
[status,message,messageid]=movefile(source_filename,destination_filename);
if(status==0), error('Error in moving finviz file!\n'); end
end

function success = wait_for_existence(filename)
success = 1;

seconds_elapsed=0; 
wait_seconds=0.5;
while( exist(filename)==0 ),
  pause(wait_seconds);
  seconds_elapsed=seconds_elapsed+wait_seconds;
  if(seconds_elapsed > 120),
    error('Waited too long for %s to exist!\n',filename) 
    success=0; return
  end
end

fprintf('Waited %.1f seconds.\n',seconds_elapsed);
end
