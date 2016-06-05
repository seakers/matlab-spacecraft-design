function [packedCG,packedDim,needExpand,isFit] = SleatorPacking_Limitless(rectangleDim,rectangleMass,tolerance,Width,Length,Height)
% Limitless because the panel height can expand until everything fits.

% Rectangles come in with height, width, and length, with the height and
% width being mounted on the panel directly.

% Tolerance is the minimum distance there should be between objects

% Send back the x,y of the center of the rectangles

% PanelWidth and PanelHeight are ranges from where the components start out
% to where they end on the panel.

% Need expand initially tells what componends need the panel to be expanded and for how much
needExpand = zeros(size(rectangleDim,1),4);

% Initialize variables
isFit = ones(size(rectangleDim,1),1);
packedCG = zeros(size(rectangleDim,1),3);
packedDim = packedCG;
packedVertices = zeros(size(rectangleDim,1),2);


for i = 1:size(rectangleDim,1)
    if rectangleDim(i,1) > rectangleDim(i,2) && rectangleDim(i,1) <= Width
    % Check each component to see if height is greater than the width but less
    % than the panelwidth, and then make the height the width and vice versa.
        w = rectangleDim(i,2);
        rectangleDim(i,2) = rectangleDim(i,1);
        rectangleDim(i,1) = w;
    end
%     if rectangleDim(i,1) > Height || rectangleDim(i,3) > Length || rectangleDim(i,2) > Width
        if rectangleDim(i,1) > Height
            % Else if the component is too large to fit on the panel
            % Width-wise, then add it to the list of components that do not fit
            % on this panel. Make the dimensions 0 so that it doesn't add to
            % anything in the algorithm
            isFit(i) = 0;
            needExpand(i,1) = 1;
            needExpand(i,2) = rectangleDim(i,1);
        end
        if rectangleDim(i,3) > Length
            % Else if the component is too large to fit on the panel
            % Width-wise, then add it to the list of components that do not fit
            % on this panel. Make the dimensions 0 so that it doesn't add to
            % anything in the algorithm
            isFit(i) = 0;
            needExpand(i,1) = 1;
            needExpand(i,4) = rectangleDim(i,3);
        end
        if rectangleDim(i,2) > Width
            % Else if the component is too large to fit on the panel
            % Width-wise, then add it to the list of components that do not fit
            % on this panel. Make the dimensions 0 so that it doesn't add to
            % anything in the algorithm
            isFit(i) = 0;
            needExpand(i,1) = 1;
            needExpand(i,3) = rectangleDim(i,2);
        end
%     rectangleDim(i,1:3) = 0;
%     end
end


% Sort by mass
[~,indices] = sort(rectangleMass,'descend');
rectangleMass = rectangleMass(indices,:);
rectangleDim = rectangleDim(indices,:);
% isFit = isFit(indices);


rectangleDim = rectangleDim + tolerance;

% Stack initial rectangles greater than half the width.

onehalfInd = (rectangleDim(:,2)./Width> .5);
unpackedDim = rectangleDim(onehalfInd,:);
unpackedIndices = indices(onehalfInd);

% A0 = 0;
h0 = 0;
if ~isempty(unpackedDim)
% If there are components that are greater than half the width of the
% satellite panel
    previousIndex = [];
    for i = 1:size(unpackedDim,1)
    % Go through each of those components
        if isFit(unpackedIndices(i))
        % If the component should fit on the satellite according to initial
        % runs,
            if (h0 + unpackedDim(i,1) - tolerance) > Height
            % check if the current height of the component plus the height
            % of the last component is too much or not. If it is, add it to
            % the list of components that don't fit on the current
            % iteration
                isFit(unpackedIndices(i)) = 0;
                needExpand(unpackedIndices(i),1) = 1;
                needExpand(unpackedIndices(i),2) = h0 + unpackedDim(i,1);
            else
            % If adding the component won't affect the height of the satellite, 
            % Add the component to the panel.
                if isempty(previousIndex)
                % If there is no previous component that fit, leave the vertex
                % of the first rectangle that fits at (0,0)
                else
                % If the previous component was a component that fit,
                % Increase the height of the current vertex by the
                % height of the previous rectangle.
                    packedVertices(unpackedIndices(i),2) = h0;
                end

                packedCG(unpackedIndices(i),2) = packedVertices(unpackedIndices(i),1)+(unpackedDim(i,2)-tolerance)/2;
                packedCG(unpackedIndices(i),3) = packedVertices(unpackedIndices(i),2)+(unpackedDim(i,1)-tolerance)/2;
                packedCG(unpackedIndices(i),1) = (unpackedDim(i,3)-tolerance)/2;
                % Calculate the initial area
            %     A0 = A0 + packedDim(i,1)*packedDim(i,2);
                packedDim(unpackedIndices(i),1) = unpackedDim(i,1);
                packedDim(unpackedIndices(i),2) = unpackedDim(i,2);
                packedDim(unpackedIndices(i),3) = unpackedDim(i,3);

                previousIndex = unpackedIndices(i); % Save the previous index of the component that fit.
                % Equals the height of the highest component packed in.
                h0 = packedVertices(unpackedIndices(i),2)+unpackedDim(i,1);
            end
        end
    end
end
maxHeight = h0;
unpackedIndices = indices(~onehalfInd);
rectangleDim = rectangleDim(~onehalfInd,:);
rectangleMass = rectangleMass(~onehalfInd,:);

i = 1;
% A1 = 0;
% A2 = 0;
h1 = h0;
d1 = h0;
w0 = 0;
while i <= size(rectangleDim,1) && Width > (w0 + rectangleDim(i,2))
    if (h0 + rectangleDim(i,1) - tolerance) > Height
        % If the component is too large in terms of height, then add it to
        % the list of components that don't fit on the panel.
        isFit(unpackedIndices(i)) = 0;        
    else
        packedVertices(unpackedIndices(i),1) = w0;
        packedVertices(unpackedIndices(i),2) = h0;

        packedCG(unpackedIndices(i),2) = packedVertices(unpackedIndices(i),1) + (rectangleDim(i,2)-tolerance)/2;
        packedCG(unpackedIndices(i),3) = packedVertices(unpackedIndices(i),2) + (rectangleDim(i,1)-tolerance)/2;
        packedCG(unpackedIndices(i),1) = (rectangleDim(i,3)-tolerance)/2;
        packedDim(unpackedIndices(i),1) = rectangleDim(i,1);
        packedDim(unpackedIndices(i),2) = rectangleDim(i,2);
        packedDim(unpackedIndices(i),3) = rectangleDim(i,3);
    end
%   Calculate the highest height for both halves of the panel.
    if w0 < Width/2 && (w0+rectangleDim(i,2)) > Width/2
        if h1 < (rectangleDim(i,1)+h0)
            h1 = rectangleDim(i,1)+h0;
        end
        if d1 < (rectangleDim(i,1)+h0)
            d1 = rectangleDim(i,1)+h0;
        end
    elseif w0 < Width/2
        if h1 < (rectangleDim(i,1)+h0)
            h1 = rectangleDim(i,1)+h0;
        end
%         A1 = A1 + rectangleDim(i,1)*rectangleDim(i,2);
    else
%         A2 = A2 + rectangleDim(i,1)*rectangleDim(i,2);
        if d1 < (rectangleDim(i,1)+h0)
            d1 = rectangleDim(i,1)+h0;
        end
    end
    w0 = packedVertices(unpackedIndices(i),1) + rectangleDim(i,2);
    i = i+1;
end


% Stack more into the two sections
maxHeight = max(h1,d1);  
if i <= size(rectangleDim,1) 
    while i <= size(rectangleDim,1)
        % Remove the components already packed.
        rectangleDim = rectangleDim(i:end,:);
        rectangleMass = rectangleMass(i:end,:);
        unpackedIndices = unpackedIndices(i:end,:);
        maxHeight = 0;
        i = 1;
        if h1 <= d1
            w0 = 0;
            w = Width/2;
            height = h1;
        else
            w0 = Width/2;
            w = Width;
            height = d1;
        end
        % Place components in their sections.
        while i <= size(rectangleDim,1) && w > (w0 + rectangleDim(i,2))
            if (height + rectangleDim(i,1) - tolerance) > Height
                % If the component is too large in terms of height, then add it to
                % the list of components that don't fit on the panel.
                isFit(unpackedIndices(i)) = 0;       
            else
                packedVertices(unpackedIndices(i),1) = w0;
                packedVertices(unpackedIndices(i),2) = height;

                packedCG(unpackedIndices(i),3) = packedVertices(unpackedIndices(i),2) + (rectangleDim(i,1)-tolerance)/2;
                packedCG(unpackedIndices(i),2) = packedVertices(unpackedIndices(i),1) + (rectangleDim(i,2)-tolerance)/2;
                packedCG(unpackedIndices(i),1) = (rectangleDim(i,3)-tolerance)/2;
                            
                packedDim(unpackedIndices(i),1) = rectangleDim(i,1);
                packedDim(unpackedIndices(i),2) = rectangleDim(i,2);
                packedDim(unpackedIndices(i),3) = rectangleDim(i,3);
            end
            w0 = w0 + rectangleDim(i,2);

            if maxHeight < (height+rectangleDim(i,1))
                maxHeight = height+rectangleDim(i,1);
            end
            i = i+1;
        end
        %   Calculate the highest height for both sections.
        if i <= size(rectangleDim,1)
            if w0 <= Width/2;
                h1 = maxHeight;
        %         A1 = A1 + rectangleDim(i,1)*rectangleDim(i,2);
            else
        %         A2 = A2 + rectangleDim(i,1)*rectangleDim(i,2)
                d1 = maxHeight;
            end
        end
    end    
end
packedDim = packedDim - tolerance;

isFit = logical(isFit); % Return the isFit vector in the order that the dimensions were inserted
maxHeight = maxHeight-tolerance;
% Include a comparing to the maximum height

packedCG = packedCG(isFit,:);
packedDim = packedDim(isFit,:);

if any(~isFit)
    if ~isempty(packedDim)
        needExpand = [1,max(max(needExpand(:,2)),maxHeight),max(needExpand(:,3)),max(max(needExpand(:,4)),max(packedDim(:,3)))+tolerance];
    else
        needExpand = [1,max(max(needExpand(:,2)),maxHeight),max(needExpand(:,3)),max(needExpand(:,4))];
    end
else
    needExpand = [0,0,0,0];
end

