function [] = struct_disp(mystrct)
% display structure hierarchy; iterative.
% ngalbraith, 2011/10/4 
% mostly taken from structstruct, from Matlab fileexchange,
% contributed by Andres (    aj.indirect@gmail.com) 
% modified to display
% contents of singletons, 1d arrays, and strings
% the array display may be a problem for some structs!!!


% structstruct(mystrct) takes in a structure variable and displays its structure.
% 
% INPUTS:
% 
% Recursive function 'structstruct.m' accepts a single input of any class.
% For non-structure input, structstruct displays the class and size of the
% input and then exits.  For structure input, structstruct displays the
% fields and sub-fields of the input in an ASCII graphical printout in the
% command window.  The order of structure fields is preserved.
% 
% OUTPUT (sample):
% > structstruct2(meta) 
% meta:  [1x1] struct
%   |--experiment:  [1x42] char
%   |--site:  [1x5] char
%   |--deployment:  [1x1] char
%   |--PI:  [1x25] char
%   |--platform_type:  [1x15] char
%   |--instrument:  [1x1] struct
%   |  |--type:  [1x13] char
%   |  |--manufacturer:  [1x29] char
%   |  |--reference:  [1x58] char
%   |  |--SN:  [1x2] double
%   |  |--HRH:  [1x1] struct
%   |  |  |--sn:  [1x1] double
%   |  |  |--height_cm:  [1x1] double
%   |  |  |--version:  [1x7] char
%   |  |  |--model:  [1x17] char
%   |  |  '--reference:  [1x61] char

if nargin() < 1
    fprintf('usage: struct_disp(strucutename)');
else
    % Figure the type and class of the input
    whosout = whos('mystrct');
    sizes =  whosout.size; 
    sizestr = [int2str(sizes(1)),'x',int2str(sizes(2))];
    endstr = [':  [' sizestr '] ' whosout.class];

    % Print out the properties of the input variable
    disp(' ');
    disp([inputname(1) endstr]);

    % Check if mystrct is a structure, then call the recursive function
    if isstruct(mystrct)
        recursor(mystrct,0,'');
    end
end
% Print out a blank line
disp(' ');

end


function recursor(mystrct,level,recstr)

recstr = [recstr '  |'];

fnames = fieldnames(mystrct);

for i = 1:length(fnames)
    
    %% Print out the current fieldname
    
    % Take out the i'th field
    tmpstruct = mystrct.(fnames{i});
    
    % Figure the type and class of the current field
    whosout = whos('tmpstruct');
    sizes = whosout.size;
    % disp([ 'class: ' whosout.class])
    
    % 201110 nrg if this is not a struct, not an array, print contents
    % instead of size/class
    
    issmall= 0; 
    if sizes(1) == 1 || sizes(2) == 1
        
        issmall = 1; 
        % added check on long arrays here 2011/10/20
        if sizes(1) > 120 || sizes(2) > 120
            issmall = 0;
        end    
    end
%     if ~ischar(tmpstruct)
%         if sizes(1) > 3 || sizes(2) > 3 
%            issmall = 0; 
%         end
%     end
    
    if ~isstruct(tmpstruct) && length(sizes) == 2 && issmall == 1
        try
          endstr=  [ ': ' num2str(tmpstruct) ];
%           for qq=1:length(tmpstruct)
%               endstr=[ endstr ' ' num2str(tmpstruct(qq)) ' ' ];  
%           end
        catch
           sizestr = [int2str(sizes(1)),'x',int2str(sizes(2))];
           endstr = [':  [' sizestr '] ' whosout.class]; 
        end
    else
        sizestr = [int2str(sizes(1)),'x',int2str(sizes(2))];
        endstr = [':  [' sizestr '] ' whosout.class];
    end   
     
    % Create the strings
    % 201110 dont make last field any diff
%     if i == length(fnames) % Last field in the current level
%         str = [recstr(1:(end-1)) '--' fnames{i} endstr];
%         recstr(end) = ' ';
%     else % Not the last field in the current level
        str = [recstr '--' fnames{i} endstr];
%     end
    
    % Print the output string to the command line
    disp(str);
    
    %% Determine if each field is a struct
    
    % Check if the i'th field of mystrct is a struct
    if isstruct(tmpstruct) % If tmpstruct is a struct, recursive function call
        recursor(tmpstruct,level+1,recstr); % Call self
    end
    
end

end






% fmtstr='';
% for jj=1:lev
%     fmtstr=[fmtstr '\t'];
% end
% fno=fieldnames(mystrct);
% for ii=1:length(fno)
%     fn=fno{ii};
%     myfmtstr=[fmtstr '%s: '];
%     fprintf(myfmtstr,fn);
%     cmd=['fld  =  mystrct.' fn ';' ];
%     eval (cmd);
%     if isstruct(fld )
%         mylev=lev+1;
%         struct_disp(fld,mylev)
%     else
% 
%         [m,n]=size(fld);
%         if m == 1 || n == 1
%             fmtstr=[fmtstr ' %s\n'];
% 
%         else
%             % array, just print size
%             fld = sprintf('[%d x %d]', m,n);
%             fmtstr=[fmtstr '% %s\n'];
%         end
%         % did you know that num2str doesn't mess up input strings???
%         fprintf(fmtstr, num2str(fld));
%     end
% end
