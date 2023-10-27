# Points to check together

- Est-ce que'on devrait avoir une seule enum pour les états de réparation? La même pour Reparation et Object et mettre des CI.
- Est-ce que timestamp c'est ok pour dire date + heure? moi je dis oui #E
- Est-ce qu'on devrait faire apparaître une classe conversation ou juste la cardinalité entre SMS et Reparation suffit à rendre ça clair?
- Pour SMS, processState devrait être une énum plutôt? franchement, oui #E
- Object et Reparation ont besoin de clés uniques -> id donnés par nous? 
- ok de pas donner de nom pour les associations concernant des enum? Les cardinalités suffisent? C'est toujours "a" quelque chose.
- Même si le client refuse le devis, la réparation reste associée à lui, est-ce que c'est ok?
- Est-ce que la réparation ne devrait pas préciser de quels domaines de spécilisation elle a besoin pour être faite?
- sale entité faible de object?
- effectiveTime de Reparation est redondant. Il suffit d'addtionner tous les TimeWorked de tous les Technicians à la fin.
- Si on laisse l'association "répond" entre Receptionist et SMS, c'est redondant avec le champ "sender" de SMS.
- Est-ce que Manager devrait hériter de Technicien ET Receptionist plutôt? Ou on dit qu'il a toujours tous les rôles?