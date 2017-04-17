function report_sectors(XS,str)

ntickers = size(XS,1);

[Ctry,ia,ic] = unique(XS(:,3)); % ia (index of first appearance)
N_sectors = length(Ctry);
fprintf('\n');
fprintf('%d %s Sectors for %d stocks:\n',N_sectors,str,ntickers);
for i=1:N_sectors
  n_ic = sum(ic==i);
  fprintf(' %s (%d = %.1f%%)\n',Ctry{i},n_ic,100*n_ic/length(ic));
end
fprintf('\n');

%{
[Ctry,ia,ic] = unique(XS(:,4)); % ia (index of first appearance)
N_industries = length(Ctry);
fprintf('\n');
fprintf('%d %s Industries for %d stocks:\n',N_industries,str,ntickers);
for i=1:N_industries
  n_ic = sum(ic==i);
  fprintf(' %s (%d = %.1f%%)\n',Ctry{i},n_ic,100*n_ic/length(ic));
end
fprintf('\n');
%}

end

