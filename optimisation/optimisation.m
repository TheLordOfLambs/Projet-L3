close all
clc
P = Parametres() ;


nbr_individus = 200;
taux_elitisme = 25;
population = 10*(ones(nbr_individus,3)-2*rand(nbr_individus,3));
lambda =  [5,5,5];
minimal_diversity = 10;

record = 9999999999999999;
record_generation = 99999999999999999;
generation = 1 ;
rec_plot=0;
recgen_plot=0;
gen_plot = 0 ;
var1 =0;
var2 =0;
var3 =0;

score = zeros(nbr_individus,1);
Y_record_generation=zeros(4,4);
Y_record=zeros(4,4);


while record > 0.1
    tic
    
    parfor n=1:nbr_individus

        Ytemp=simulation(population(n,:),P);
        score(n) = 1.5*norm(Ytemp(end,2:4)'-[P.tXo;P.tyo;terrain(P.tXo,P.tyo)])^2+0.2*Ytemp(end,1)^2;
        
    end
    
    Y_record_generation=simulation(population(find(score==min(score)),:),P);
    record_generation = min(score);
    
    toc
    if min(score)<record
        Y_record=Y_record_generation;
        record = min(score);
        
    end

    % Graphique

    % terrain
    terrain_x = min([Y_record_generation(:,2);Y_record(:,2);P.tXo])-1:0.2:max([Y_record_generation(:,2);Y_record(:,2);P.tXo])+1 ;
    terrain_y = (min([Y_record_generation(:,3);Y_record(:,3);P.tyo])-1:0.2:max([Y_record_generation(:,3);Y_record(:,3);P.tyo])+1)';
    terrain_z =  terrain(terrain_x,terrain_y);
    C = terrain_z;

    figure(1)
    mesh(terrain_x,terrain_y,terrain_z)
    %axis equal
    hold on
    plot3(Y_record(:,2),Y_record(:,3),Y_record(:,4),'b',Y_record_generation(:,2),Y_record_generation(:,3),Y_record_generation(:,4),'k')
    view(5,40)
    title(sprintf('génération=%f',generation))
    xlabel('x')
    ylabel('y')
    zlabel('z')
    quiver3([P.tXo],[P.tyo],[terrain(P.tXo,P.tyo)],[0],[0],[1],'r')
    grid ON
    hold off
    
   elite = elitisme(population,score,taux_elitisme);
   
   for i=1:taux_elitisme
        elite(i,:)=mutation(elite(i,:),[0,0,0]);
   end
   
   new_population = zeros(nbr_individus,length(population(1,:)));
   
    for i=1:nbr_individus
        
        parent=selection(population,score,20,2);
        enfant=crossover(parent,population);
        enfant=mutation(enfant,lambda);
        new_population(i,:)=enfant;
    end
      
    newscore = zeros(nbr_individus,1);
    parfor i=1:nbr_individus

        Ytemp=simulation(new_population(i,:),P);
        newscore(i) = 2*norm(Ytemp(end,2:4)'-[P.tXo;P.tyo;terrain(P.tXo,P.tyo)])^2+0.2*Ytemp(end,1)^2;

    end
    
    population = tri(new_population,population,newscore,elite);
    
    rec_plot=[rec_plot;record];
    recgen_plot=[recgen_plot;record_generation];
    var1=[var1;var(population(:,1))];
    var2=[var2;var(population(:,2))];
    var3=[var3;var(population(:,3))];
    gen_plot = [gen_plot;generation];
    
    
    figure(2)
    subplot(2,2,[1,2]);
    plot(gen_plot(2:end),recgen_plot(2:end),'k',gen_plot(2:end),rec_plot(2:end),'b');
    title(sprintf('best fitness=%f',record))
    legend('meilleur score de la génération','meilleur score')
    subplot(2,2,3);
    plot(gen_plot(2:end),recgen_plot(2:end),'k');
    title(sprintf('best fitness (génération)=%f',record_generation))
    subplot(2,2,4);
    plot(gen_plot(2:end),var1(2:end),'r',gen_plot(2:end),var2(2:end),'b',gen_plot(2:end),var3(2:end),'k');
    title(sprintf('variance moyenne (diversité) :%f',mean([var1(end),var2(end),var3(end)])))
    legend('variance Vox','variance Voy','variance Voz')
    
    if mean([var1(end),var2(end),var3(end)])< minimal_diversity
        population = extinction(population,lambda);
    end
   
    generation=generation+1;
    record_generation =9999999999999;

end