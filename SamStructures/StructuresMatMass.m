function structures = StructuresMatMass(structures,material,masses)
for i = 1:length(structures)
    structures(i).Mass = masses(i);
    structures(i).Material = material;
end