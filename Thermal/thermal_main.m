function thermal = thermal_main(drymass)
    
    thermal.mass=0.0607*drymass;
    thermal.cost=394*thermal.mass^(.635)+50.6*thermal.mass^.707;
end
      