function enfant=crossover(parent,population)

enfant = zeros(1,length(population(1,:)));
pere = parent(1,:);
mere = parent(2,:);
    for i =1:length(population(1,:))
        if rand <=0.5
            enfant(1,i) = pere(1,i);
        else
            enfant(1,i) = mere(1,i);
        end
    end
    
end
    