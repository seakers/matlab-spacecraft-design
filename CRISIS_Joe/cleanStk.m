% cleanStk.m
objects = stkObjNames;
for i = length(objects):-1:2
    stkUnload(objects{i});
end
stkClose('all');
stkClose();
