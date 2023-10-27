# Points to check together

- Est-ce que'on devrait avoir une seule enum pour les états de réparation?
- Dans Reparation, est-ce que effectiveTime est redondant avec la classe d'association RepairTimeSpent?
- Est-ce que timestamp c'est ok pour dire date + heure?
- Est-ce qu'on devrait faire apparaître une classe conversation ou juste la cardinalité entre SMS et Reparation suffit à rendre ça clair?
- Pour SMS, processState devrait être une énum plutôt?
- La clé unique de objet est "name"? ou on rajoute un id
- ok de pas donner de nom pour les associations concernant des enum? C'est toujours "a" quelque chose.