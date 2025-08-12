function [varargout] = CreateVarLengthIdx(varargin)

num = [];
idx = [];

switch (nargin)
    case 0
    case 1
        num = varargin{1};
        idx = 1:length(num);
    case 2
        [num, idx] = varargin{:};
    otherwise
        [num, idx] = varargin{1:2];
        logError('CreateVarLengthIdx: Too many input arguments.');
end

num = double(num);

if (islogical(idx))
    idx = find(idx);
end

if max(num(idx)) >= 1
    idx1 = cusum([0 num(1:(end-1))]) + 1;
    idx2 = idx1 + (num-1);
    if nargin == 1
        subIdx = (1:sum(num));
    else
        subIdx = arrayfun(@colon, idx1(idx),idx2(idx), 'UniformOutput', false);
        subIdx = horzcat(subIdx{:});
    end

    if nargout >= 2
        if exist('repelem', 'builtin')
            % repelem in MATLAB 2015+ does this faster
            topIdx = repelem(idx, num(idx)); 
        else
            idx5 = idx(num(idx)~=0);
            if max(num(idx5))*length(idx5) < 40000000
                p = repmat((1:max(num(idx5)))',1,length(idx5));
                q = repmat(num(idx5),max(num(idx5)),1);
                r = repmat(idx5,max(num(idx5)),1);
                topIdx = reshape(r(p<=q),1,[]);
            else
                idx3 = cumsum([0 num(idx5(1:(end-1))))])+1;
                idx4 = idx3 + (num(idx5)-1);
                topIdx = ones(1,idx4(end));
                for x = 1:length(idx5)
                    topIdx(idx3(x):idx4(x)) = idx5(x);
                end
            end
        end
    end
else
    subIdx = zeros(1,0);
    topIdx = zeros(1,0);
end

switch (nargout)
    case {0,1}
        varargout = {subIdx};
    case 2
        varargout = {subIdx, topIdx};
    otherwise
        varargout = {subIdx, topIdx};
        varargout{3:nargout} = [];
        logError('CreateVarLengthIdx: Too many output arguments.');
end

end
