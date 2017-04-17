function [XS] = dataclean_XS(XS)

for i=1:size(XS,1)
  string = XS(i,3);
  string = string{1};
  if(strcmp(string,'Utilities ')==1),
    XS(i,3) = {'Utilities'};
  elseif(strcmp(string,'Services ')==1),
    XS(i,3) = {'Services'};
  elseif(strcmp(string,'#Technology')==1),
    XS(i,3) = {'Technology'};
  end
end

end

