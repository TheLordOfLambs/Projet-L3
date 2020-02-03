function elite=elitisme(population,score,taux_elitisme)

    [~,idx] = sort(score);
    population_classe = population(idx,:);
    
    elite = population_classe(1:taux_elitisme,:);
    
    %{
    elite = find(score<=classement(taux_elitisme));
    
    if length(elite)~=taux_elitisme
        elite = elite(1:taux_elitisme);
    end
 % elite = zeros(taux_elitisme,length(population(1,:)));
    
    for i=1:taux_elitisme
        elite(i,:)=population(i,:) ;
    end
    %}
end
