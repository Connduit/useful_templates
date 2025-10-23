function out_struct = filter_struct(in_struct, list, numElementsInFilterDim)
% TODO
out_struct = []
if isempty(list)
  return;
  end

  %get a list of field names
  names = fieldnames(in_strucct);
  num_names = length(names);
  % TODO: commend
  fieldsToremove = '';
  for ii = 1:num_names
    if strcmp(names{ii}(1), '_') || ~isempty(regexp(names{ii},'\.'))
      newFieldName = regexprep(names{ii}, '^_+','');
        newFieldName = regexprep(newFieldNmae, '\.','');
        if isempty(newFieldName)
          newFieldName = 'invalidFieldNmae';
          end

          in_struct.(newFieldName) = in_struct.(names{ii});

          fieldsToRemove = strvcat(fieldsToremove, names{ii});

          names{ii} = newFieldName;
          end
          end

          if ~isempty(fieldsToRemove)
            in_struct  = rmField(in_struct, fieldsToRemove);
            end

if numel(in_struct) > 1 && isstruct(in_struct) && ((islogical(list) && all(size(list) == size(in_struct))) || ~islogical(list))
    out_struct = in_struct(list);
else
    single_entry_flag = true;

    for ii = 1:num_names
        if isstruct(in_struct.(names{ii}))
            single_entry_flag = false;
            break;
        end

        [a,b,c] = size(in_struct.(names{ii}));
        if (a > 1) || (b > 1) || (c > 1)
            single_entry_flag = false;
            break;
        end
    end

    % TODO: comment
    if single_entry_flag
        if list(1)
            out_struct = in_struct;
        else
            for ii = 1:num_names
                out_struct.(names{ii}) = [];
            end
        end
    else
        if islogical(list(1))
            N = length(list);
        elseif isfield(in_struct, 'beam_id')
            N = length(in_struct, 'wallTimeValue_')
        elseif exist('numElementsInFilterDim', 'var')
            N = numElementsInFilterDim;
        else
            dimensions = [];
            for k=1:length(names)
                if ~isstruct(in_struct.(names{k})
                    dimensions = [dimensions size(in_struct.(names{k}))];
                end
            end

            [mostCommonDim, mostCommonDimFreq] = mode(dimensions);

            if mostCommonDim ~= 1
                N = mostCommonDim;
            elseif mostCommonDimFreq == mostCommonDimFreq2
                N = mostCommonDim2;
            else
                N = mostCommonDim;
            end
        end

        for i=1:length(names)
            if isstruct(in_struct.(names{i}))
                out_struct.(names{i}) = filter_struct(in_struct.(names{i}), list, N);
            else
                [a,b,c,d] = size(in_struct.(names{i}));
                if isempty(in_struct.(names{i}))
                    out_struct.(names{i})=[];
                else
                    try
                        if (a == 1 && b == 1 && c == 1 && d == 1) || ischar(in_struct.(names{i}))
                            out_struct.(names{i}) = in_struct.(names{i});
                        elseif a==N && c~=N
                             out_struct.(names{i}) = in_struct.(names{i})(list,:,:);
                        elseif b==N && c~=N
                             out_struct.(names{i}) = in_struct.(names{i})(:,list,:);
                        elseif c==N
                             out_struct.(names{i}) = in_struct.(names{i})(:,:,list);
                        elseif d==N
                             out_struct.(names{i}) = in_struct.(names{i})(:,:,:,list);
                        end
                    catch
                        disp([' *!* ', names{i}, ' field could not be processed.'])
                    end
                end
            end
        end
    end
end
            
end
