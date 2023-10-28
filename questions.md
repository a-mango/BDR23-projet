# Points to check together

- Est-ce que'on devrait avoir une seule enum pour les états de réparation? La même pour Reparation et Object et mettre des CI.
    #V: oui. (Et le laisser en tant qu'attribut seulement dans Reparation?)
- Est-ce que timestamp c'est ok pour dire date + heure? moi je dis oui #E
    -> A: oui, format TIMEDATE dans Postgres (je crois que juste date suffit dans le diagramme, a demander a l'assistant par teams ou regarder les exos ?)
- Est-ce qu'on devrait faire apparaître une classe conversation ou juste la cardinalité entre SMS et Reparation suffit à rendre ça clair? Oui c'est clair a mon avis #A
- Pour SMS, processState devrait être une énum plutôt? franchement, oui #E oui #A
- Object et Reparation ont besoin de clés uniques -> id donnés par nous? Oui #A (remember le labo, RIP)
- ok de pas donner de nom pour les associations concernant des enum? Les cardinalités suffisent? C'est toujours "a" quelque chose. -> #A: Mieux vaut mettre "a" ou "possède" ET une composition/aggrégation, non ? #V: bonne question..
- Même si le client refuse le devis, la réparation reste associée à lui, est-ce que c'est ok? #A oui, et on la passe en "ABANDONNED" 
- Est-ce que la réparation ne devrait pas préciser de quels domaines de spécilisation elle a besoin pour être faite? -> #A On en avait parlé en cours non ? Peut-être qu'il faut lui lier "Specialization" ! #V : ce serait pas mieux de créer une enum Specialization?
- sale entité faible de object? -> #A je comprends toujours rien a ca
    #V: jsp si ça ou de lui donner un id unique comme pour objet et reparation.
- effectiveTime de Reparation est redondant. Il suffit d'addtionner tous les TimeWorked de tous les Technicians à la fin. #A: absolument. 
- Si on laisse l'association "répond" entre Receptionist et SMS, c'est redondant avec le champ "sender" de SMS. #A voir commentaire en dessous
- Est-ce que Manager devrait hériter de Technicien ET Receptionist plutôt? Ou on dit qu'il a toujours tous les rôles? #A Yep c'est une idée, mais attention il peut aussi faire plus que les deux !  #V j'avoue, à voir comment on peut organiser ça

Aubry :
ProcessState : renommer ProcessingState ?
SMS : - Timestamp ne peut pas être une clé car il n'est pas garanti unique (2 sms à la même picosecond ? haha) 
    #V : Plusieurs clés? Mais est ce qu'on met les 3 attributs ou timestamp&msg ou timestamp&sender?
      - Ensemble de SMS s'appelle conversation : pas utile a préciser dans le DBMS mais seulement dans l'affichage ?
      - Les SMS ne deveraient-ils pas lier plutot un client et une réparation, sans passer par le Receptionist ? (le manager peut aussi répondre je crois)
      #V : si on le lie slmt à reparation ce serait pas suffisant? 
Reparation:  - On voulait tracker seulement le temps total passé n'est-ce pas ? (et non pas quel colaborateur a effectué du temps de travail c'est ca ?) #V : c'est quand meme utile de le tracker pour le stats et tout ça, non? 
Général : - client, receptionist, manager, technician peuvent tous hériter de "Person" non? On s'évite des répétitions de PhoneNo, Name, etc.
          - Les différents roles de collaborateurs définissent leurs niveaux d'accès a la DB -> pas sur car finalement en pratique on aura un seul accès à la DB depuis le serveur. Pas sur que ca soit pertinent de le mettre la.
          - Attention à ajouter les "disjoint, totale" etc. dans le diagramme pour préciser qu'on peut êtr eplusieurs choses à la fois !



