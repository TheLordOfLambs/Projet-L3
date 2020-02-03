function new_population = tri(new_population,population,score,elite)

    taux_elitisme=length(elite(:,1));
    nbr_individus=length(new_population(:,1));

    [~,idx] = sort(score);
    population_classe = population(idx,:);
    
    new_population = population_classe(1:nbr_individus-taux_elitisme,:);
    new_population = [elite;new_population];
    






%{
classement=sort(score,'descend');

index_individus=zeros(taux_elitisme,1);
for i=1:taux_elitisme
    index_individus(i)=classement

for i =1:taux_elitisme
    new_population(index_individus(i),:)=population(elite(i),:);
end
    %}
end
