function new_population = extinction(population,sigma)

    nbr_individus=length(population(:,1));
    
    for i=1:length(population(1,:))
        new_population(:,i) = normrnd(mean(population(:,i)),sigma(i),[nbr_individus,1]);
    end
end