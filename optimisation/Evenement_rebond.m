function [value,isterminal,direction] = Evenement_rebond(t,Y)
value = Y(3) > feval('terrain',Y(1),Y(2));                   % arr�t de l'it�ration quand cette condition n'est plus v�rifi�e
isterminal = 1;                                              % arr�t de l'int�gration
direction = -1;                                              % pour les directions n�gatives seulement