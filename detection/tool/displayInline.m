function displayInline(str)
% displayInline 
%   Displays the string 'str' in the command window, 
%   overwriting any output the method previously displayed.
%   Useful to update any displayed string in place,
%   for example to indicate the the state of a simulation in progress.
%
%   e.g.
%       displayInline;
%       tic;
%       for k = 1:1e6
%           if mod(k,1000)==0
%               displayInline(sprintf('test: iteration %d, elapsed time: %g s', k, toc));
%           end
%           ...
%           RepeatSomeTimeConsumingTask;
%           ...
%       end
%       displayInline(sprintf('test: completed %d iterations (in %g s)', k, toc));
%
%   A persistent variable 'displayInlineCount' is used 
%   to keep track of the length of the previously displayed string,
%   so that it can be erased the next time. 
%   'displayInlineCount' is reset if no argument is passed in or 'str' is null.
%
%   Note: 
%   Any output on the command window made by other functions (e.g. display)
%   between successive calls to displayInline would cause 
%   an incorrect portion of the output to be overwritten.
%
%   Author        : Damith Senaratne, (http://www.damiths.info)
%   Released date : 11th August 2011 

persistent displayInlineCount;

if nargin==0 || isempty(str)
    displayInlineCount = [];
    return;
end

str = [str '\n'];

if ~exist('displayInlineCount','var') || isempty(displayInlineCount)
    fprintf(str,' ');
else
    fprintf([repmat('\b',1,displayInlineCount) str],' ');
end

displayInlineCount = length(eval('sprintf(str)'));