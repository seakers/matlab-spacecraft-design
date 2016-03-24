% cleanStk2.m
objects = stkObjNames;
stkUnload(objects{3})
for i = length(objects):-1:2
    if i~= 3 && i~= 4 && i~= 5
        stkUnload(objects{i});
    end
end
% stkClose('all');
% stkClose();
