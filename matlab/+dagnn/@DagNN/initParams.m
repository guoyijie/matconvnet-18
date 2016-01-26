function initParams(obj)
% INITPARAM  Initialize the paramers of the DagNN
%   OBJ.INITPARAM() uses the INIT() method of each layer to initialize
%   the corresponding parameters (usually randomly).

% Copyright (C) 2015 Karel Lenc and Andrea Vedaldi.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

for l = 1:numel(obj.layers)
  p = obj.getParamIndex(obj.layers(l).params) ;
  params = obj.layers(l).block.initParams() ;
  frozen = false;
  if isprop(obj.layers(l).block,'frozen') && obj.layers(l).block.frozen, 
      frozen = true;
  end
  switch obj.device
    case 'cpu'
      params = cellfun(@gather, params, 'UniformOutput', false) ;
    case 'gpu'
      params = cellfun(@gpuArray, params, 'UniformOutput', false) ;
  end
  % [obj.params(p).value] = deal(params{:}) ;
  for i = 1:numel(params), 
      if ~frozen || isempty(obj.params(p(i)).value), 
          obj.params(p(i)).value = params{i};
      end
  end
end
