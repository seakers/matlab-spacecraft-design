function [packedVertices,packedDim] = PackingAlgorithm(rectangleDim,rectangleMass,tolerance,panelWidth)

% Rectangles come in with width and height.

% Tolerance is the minimum distance there should be between objects

% Send back the x,y of the center of the rectangles

rectangleDim = rectangleDim + tolerance;

packedVertices = zeros(size(rectangleDim,1),3);
packedDim = packedVertices; 

% Sort by mass first
[~,indices] = sort(rectangleMass,'descend');
rectangleMass = rectangleMass(indices,:);
rectangleDim = rectangleDim(indices,:);

% Check each component to see if height is greater than the width.
% 
for i = 1:size(indices,1)
    if rectangleDim(i,2) > rectangleDim(i,1) && rectangleDim(i,2) < panelWidth
        w = rectangleDim(i,1);
        rectangleDim(i,1) = rectangleDim(i,2);
        rectangleDim(i,2) = w;
    end
end

% Stack initial rectangles greater than half the width.

onehalfInd = (rectangleDim(:,1)./panelWidth > .5);
unpackedDim = rectangleDim(onehalfInd,:);
unpackedIndices = indices(onehalfInd);


% A0 = 0;
for i = 1:size(unpackedDim,1)
    if i == 1
        %   Leave the x,y of the first rectangle at 0,0
    else
        packedVertices(unpackedIndices(i),2) = packedVertices(unpackedIndices(i-1),2)+unpackedDim(i-1,2)+(unpackedDim(i,2)-tolerance)/2;
    end
    packedVertices(unpackedIndices(i),1) = (unpackedDim(i,1)-tolerance)/2;
    % Calculate the initial area
%     A0 = A0 + packedDim(i,1)*packedDim(i,2);
    packedDim(unpackedIndices(i),1) = unpackedDim(i,1);
    packedDim(unpackedIndices(i),2) = unpackedDim(i,2);
end
h0 = packedVertices(unpackedIndices(end),2)+unpackedDim(end,2);

% Sort rectangles by mass, then height (Leave this part out for now)

% for i = 1:
%     
% end

unpackedIndices = indices(~onehalfInd);
rectangleDim = rectangleDim(~onehalfInd,:);
rectangleMass = rectangleMass(~onehalfInd,:);

i = 1;
% A1 = 0;
% A2 = 0;
h1 = 0;
d1 = 0;
w0 = 0;
while i <= size(rectangleDim,1) && panelWidth > (w0 + rectangleDim(i,1))

    packedVertices(unpackedIndices(i),1) = w0 + (rectangleDim(i,1)-tolerance)/2;
    packedVertices(unpackedIndices(i),2) = h0 + (rectangleDim(i,2)-tolerance)/2;
    packedDim(unpackedIndices(i),1) = rectangleDim(i,1);
    packedDim(unpackedIndices(i),2) = rectangleDim(i,2);
    
%   Calculate the highest height for both sections.
    if w0 < panelWidth/2 && (w0+rectangleDim(i,1)) > panelWidth/2
        if h1 < (rectangleDim(i,2)+h0)
            h1 = rectangleDim(i,2)+h0;
        end
        if d1 < (rectangleDim(i,2)+h0)
            d1 = rectangleDim(i,2)+h0;
        end
    elseif w0 < panelWidth/2
        if h1 < (rectangleDim(i,2)+h0)
            h1 = rectangleDim(i,2)+h0;
        end
%         A1 = A1 + rectangleDim(i,1)*rectangleDim(i,2);
    else
%         A2 = A2 + rectangleDim(i,1)*rectangleDim(i,2);
        if d1 < (rectangleDim(i,2)+h0)
            d1 = rectangleDim(i,2)+h0;
        end
    end
    w0 = packedVertices(unpackedIndices(i),1) + rectangleDim(i,1);
    i = i+1;
end


% Stack more into the two sections
if i > size(rectangleDim,1)
else     
    while i <= size(rectangleDim,1)
        % Remove the components already packed.
        rectangleDim = rectangleDim(i:end,:);
        rectangleMass = rectangleMass(i:end,:);
        unpackedIndices = unpackedIndices(i:end,:);
        maxHeight = 0;
        i = 1;
        if h1 <= d1
            w0 = 0;
            w = panelWidth/2;
            height = h1;
        else
            w0 = panelWidth/2;
            w = panelWidth;
            height = d1;
        end
        % Place components in their sections.
        while i <= size(rectangleDim,1) && w > (w0 + rectangleDim(i,1))
            packedVertices(unpackedIndices(i),1) = w0 + (rectangleDim(i,1)-tolerance)/2;
            packedVertices(unpackedIndices(i),2) = height + (rectangleDim(i,1)-tolerance)/2;
            w0 = w0 + rectangleDim(i,1);
            packedDim(unpackedIndices(i),1) = rectangleDim(i,1);
            packedDim(unpackedIndices(i),2) = rectangleDim(i,2);
    
            if maxHeight < (height+rectangleDim(i,2))
                maxHeight = height+rectangleDim(i,2);
            end
            i = i+1;
        end
        %   Calculate the highest height for both sections.
        if i <= size(rectangleDim,1)
            if w0 <= panelWidth/2
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




