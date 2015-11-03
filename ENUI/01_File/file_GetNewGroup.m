function Group = file_GetNewGroup(varargin)
%----------------------------------------------------------
% New Group
%
% varargin{1}   : Group Name
% varargin{2}   : File Indexes
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 03.
%----------------------------------------------------------

    if nargin == 0
        Group.Name = [];
        Group.Member = [];
    elseif nargin == 1
        Group.Name = varargin{1};
        Group.Member = [];
    else
        Group.Name = varargin{1};
        Group.Member = varargin{2};
    end
    
end