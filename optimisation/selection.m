function parents=selection(population,score,k,nbr_parent)

num_participant=ceil(length(population)*rand(k,1));

score_participant=zeros(k,1);
for n=1:k
  score_participant(n)=score(num_participant(n)) ;
end

[~,idx] = sort(score_participant);
population_classe = population(idx,:);
    
parents = population_classe(1:nbr_parent,:);

%{
score_participant=zeros(k,1);
for n=1:k
  score_participant(n)=score(num_participant(n)) ;
end

classement = sort(score_participant) ;


num_gagnant = find(score_participant<=classement(nbr_parent));

parents=zeros(nbr_parent,length(population(1,:)));

for i=1:nbr_parent
    parents(i,:)=population((num_gagnant(i)),:);
end
%}
