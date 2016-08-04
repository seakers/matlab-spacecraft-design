function [genParameters,components] = UpdateParameters(genParameters,components)
% Function that updates the initial parameters of the satellite based on
% what the fitting algorithms have calculated to be appropriate heights,
% widths, and lengths necessary for the components to fit on the satellite.

% For future updates: Might want to include changing thickness of
% structures, materials, or type of satellite as well, depending on
% calculations

% Checks to see if this is a stacking satellite or otherwise
if any(genParameters.needExpand(:,1))
    needExpand = genParameters.needExpand(genParameters.needExpand(:,1)==1,:);
    [newHeight,i] = max(needExpand(:,2));
    % At the index of the newest height, see if the newWidth is greater than
    % the current width of the satellite's location.
    newWidth = needExpand(i,3);
    % Same for Length.
    newLength = needExpand(i,4);

    if any(strfind(genParameters.spacecraftType,'Cubesat'))
        % If the newHeight to expand to is less than the current top height of
        % the spacecraft, just add another panel
        % Create more panels in which to pack the components on.        
%         if any(genParameters.needExpand(7:end,1));
%             nTrays = size(genParameters.trays,1);
%             trayHeight = max(genParameters.needExpand(7:end,2));
%             genParameters.trays = [genParameters.trays; nTrays+1,trayHeight];
%         end
        if any(genParameters.needExpand(1:6,1));
            % Expand the outside of the satellite first.
            if newHeight >= genParameters.satHeight && newLength >= genParameters.satLength && newWidth >= genParameters.satWidth
                % If the height, width, and length given by the code necessary to fit the
                % components is larger than the current ones, expand them
                % all.
                if genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight < 0.3
                    genParameters.satHeight = genParameters.satHeight + .1;
                    genParameters.satLength = 0.2;
                    genParameters.satWidth = 0.2;
                else
    %                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
                end
            elseif newHeight >= genParameters.satHeight && newLength >= genParameters.satLength
                if genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight < 0.3
                    % If the satellite is a cubesat, expand the satellite up until 3u
                    genParameters.satHeight = 0.3;
                    genParameters.satWidth = 0.2;
                else   
    %                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
                end
            elseif newHeight >= genParameters.satHeight && newWidth >= genParameters.satWidth
                if genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight < 0.3
                    % If the satellite is a cubesat, expand the satellite up until 3u
                    genParameters.satHeight = 0.3;
                    genParameters.satLength = 0.2;
                else
    %                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
                end
            elseif newHeight >= genParameters.satHeight
                % If the height is more than the current top height of the spacecraft,
                % expand the top height.
                if genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight < 0.3
                    % If the satellite is a cubesat, expand the satellite up until 3u
                    genParameters.satHeight = genParameters.satHeight + 0.1;
                elseif genParameters.satWidth == .1 && genParameters.satLength == .1 && newHeight >= 0.3
                    % Else just add an arbitrary width.
                    genParameters.satWidth = genParameters.satWidth + .1;
                elseif genParameters.satWidth == .2 && genParameters.satLength == .1 && newHeight >= 0.3
                    genParameters.satLength = genParameters.satLength + .1;
                else
    %                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
                end
            end
        elseif any(genParameters.needExpand(7:end,1));
            % Else if the trays need expansion, then expand them, unless
            % the height of the trays are already at the maximum, in which
            % case expand the size of the satellite as well.            
            nTrays = size(genParameters.trays,1);
            trayHeight = max(genParameters.needExpand(7:end,2));
            if trayHeight >= genParameters.satHeight
            % If the new tray height that the code wants is greater than
            % the current one of the satellite, expand the satellite until
            % it is 2u, 3u, 6u, or 12u.
                if genParameters.satWidth == .1 && genParameters.satLength == .1 && trayHeight < 0.3
                    % If the satellite is a cubesat, expand the satellite up until 3u
                    genParameters.satHeight = genParameters.satHeight + 0.1;
                    genParameters.trays = genParameters.trays(1,:); % make just one tray and build up from there.
                elseif genParameters.satWidth == .1 && genParameters.satLength == .1 && trayHeight >= 0.3
                    % Else if the satellite is already 3u, make it 6u
                    genParameters.satWidth = genParameters.satWidth + .1;
                    genParameters.trays = genParameters.trays(1,:); % make just one tray and build up from there.
                elseif genParameters.satWidth == .2 && genParameters.satLength == .1 && trayHeight >= 0.3
                    % else if the satellite is already 6u, make it 12u
                    genParameters.satLength = genParameters.satLength + .1;
                    genParameters.trays = genParameters.trays(1,:); % make just one tray and build up from there.
                else
    %                 fprintf('We can''t make a cubesat bigger than 12u folks\n')
                end
            else
            % Or if the tray height fits in the satellite, just add the new
            % tray.
                genParameters.trays = [genParameters.trays; nTrays+1,trayHeight];
            end
        end
    elseif any(strfind(genParameters.spacecraftType,'Stacked'))
    % If the satellite is a stacked satellite, 
        
        if any(genParameters.needExpand(1:6,1));
        % Expand the panels of the satellite first
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

        elseif any(genParameters.needExpand(7:end,1));
        % Then expand the inner trays of the satellite.
            % if the trays need expansion, then expand them, unless
            % the height of the trays are already at the maximum, in which
            % case expand the height of the satellite as well.            
            nTrays = size(genParameters.trays,1);
            trayHeight = max(genParameters.needExpand(7:end,2));
            if trayHeight >= genParameters.satHeight
            % If the new tray height that the code wants is greater than
            % the current one of the satellite, expand the height of the
            % satellite
                genParameters.satHeight = trayHeight + 0.1;
            else
            % Or if the tray height fits in the satellite, just add the new
            % tray.
                genParameters.trays = [genParameters.trays; nTrays+1,trayHeight];
            end
        end
    elseif any(strfind(genParameters.spacecraftType,'Panel Mounted'))
    % If the satellite is panel mounted
        if newHeight > genParameters.satHeight
%             genParameters.satHeight = newHeight;
%         elseif newHeight == genParameters.satHeight
            genParameters.satHeight = newHeight + genParameters.honeycombThickness;
        elseif newHeight == genParameters.satHeight
            genParameters.satHeight = genParameters.satHeight + genParameters.tolerance;
        end
        if newWidth >= genParameters.satWidth
            genParameters.satWidth = newWidth + 2*genParameters.honeycombThickness;
%         elseif newWidth == genParameters.satWidth
%             genParameters.satWidth = genParameters.satWidth + genParameters.tolerance;
        end
        if newLength >= genParameters.satLength
            genParameters.satLength = newLength + 2*genParameters.honeycombThickness;
%         elseif newLength == genParameters.satLength
%             genParameters.satLength = genParameters.satLength + genParameters.tolerance;
        end   
    else
        % Expand the central cylinder-based structure
        if newHeight >= genParameters.satHeight
%             genParameters.satHeight = newHeight;
%         elseif newHeight == genParameters.satHeight
            genParameters.satHeight = newHeight + genParameters.tolerance;
        end
    end
    genParameters.needExpand(:,:) = 0;
end
end