function [genParameters,components] = UpdateParameters(genParameters,components)
% Function that expands all the heights of the satellite to the highest height availabe
% for the component.

% Checks to see if this is a stacking satellite or otherwise
if any(genParameters.needExpand(:,1))
    needExpand = genParameters.needExpand(genParameters.needExpand(:,1)==1,:);
    [newHeight,i] = max(needExpand(:,2));
    % At the index of the newest height, see if the newWidth is greater than
    % the current width of the satellite's location.
    newWidth = needExpand(i,3);
    % Same for Length.
    newLength = needExpand(i,4);

    if strfind(genParameters.spacecraftType,'Cubesat')
        % If the newHeight to expand to is less than the current top height of
        % the spacecraft, just add another panel
        % Create more panels in which to pack the components on.
        if any(genParameters.needExpand(7:end,1));
            nTrays = size(genParameters.trays,1);
            trayHeight = max(genParameters.needExpand(7:end,2));
            genParameters.trays = [genParameters.trays; nTrays+1,trayHeight];
        end
        if newHeight >= genParameters.satHeight && newLength >= genParameters.satLength && newWidth >= genParameters.satWidth
            if genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight <= 0.3
                % If the satellite is a cubesat, expand the satellite up until 3u
                genParameters.satHeight = 0.3;
                genParameters.satLength = 0.2;
                genParameters.satWidth = 0.2;
            else
%                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
            end
        elseif newHeight >= genParameters.satHeight && newLength >= genParameters.satLength
            if genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight <= 0.3
                % If the satellite is a cubesat, expand the satellite up until 3u
                genParameters.satHeight = 0.3;
                genParameters.satWidth = 0.2;
            else   
%                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
            end
        elseif newHeight >= genParameters.satHeight && newWidth >= genParameters.satWidth
            if genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight <= 0.3
                % If the satellite is a cubesat, expand the satellite up until 3u
                genParameters.satHeight = 0.3;
                genParameters.satLength = 0.2;
            else
%                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
            end
        elseif newHeight >= genParameters.satHeight
            % If the height is more than the current top height of the spacecraft,
            % expand the top height and then create a new panel.
            if genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight <= 0.3
                % If the satellite is a cubesat, expand the satellite up until 3u
                genParameters.satHeight = genParameters.satHeight + 0.1;
            elseif genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight == 0.3
                % Else just add an arbitrary height.
                genParameters.satWidth = genParameters.satWidth + .1;
            elseif genParameters.satWidth == .2 && genParameters.satLength == .1 && newHeight == 0.3
                genParameters.satLength = genParameters.satLength + .1;
            else
%                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
            end
        end
    elseif strfind(genParameters.spacecraftType,'Stacked')
        if any(genParameters.needExpand(7:end,1));
            nTrays = size(genParameters.trays,1);
            trayHeight = max(genParameters.needExpand(7:end,2));
            genParameters.trays = [genParameters.trays; nTrays+1,trayHeight];
        end
        if newHeight > genParameters.satHeight
%             genParameters.satHeight = newHeight;
%         elseif newHeight == genParameters.satHeight
            genParameters.satHeight = newHeight + genParameters.tolerance;
        elseif newHeight == genParameters.satHeight
            genParameters.satHeight = genParameters.satHeight + genParameters.tolerance;
        end
        if newWidth >= genParameters.satWidth
            genParameters.satWidth = newWidth + genParameters.tolerance;
%         elseif newWidth == genParameters.satWidth
%             genParameters.satWidth = genParameters.satWidth + genParameters.tolerance;
        end
        if newLength >= genParameters.satLength
            genParameters.satLength = newLength + genParameters.tolerance;
%         elseif newLength == genParameters.satLength
%             genParameters.satLength = genParameters.satLength + genParameters.tolerance;
        end    
    else
        % Expand the structure for any structure that doesn't have mounting
        % panels
        if newHeight >= genParameters.satHeight
%             genParameters.satHeight = newHeight;
%         elseif newHeight == genParameters.satHeight
            genParameters.satHeight = newHeight + genParameters.tolerance;
        end
    end
    genParameters.needExpand(:,:) = 0;
end