# Points to check together

- Est-ce que'on devrait avoir une seule enum pour les états de réparation? La même pour Reparation et Object et mettre des CI.
  #V: oui. (Et le laisser en tant qu'attribut seulement dans Reparation?)
- Est-ce que timestamp c'est ok pour dire date + heure? moi je dis oui #E
  -> A: oui, format TIMEDATE dans Postgres (je crois que juste date suffit dans le diagramme, a demander a l'assistant par teams ou regarder les exos ?)
- Est-ce qu'on devrait faire apparaître une classe conversation ou juste la cardinalité entre SMS et Reparation suffit à rendre ça clair? Oui c'est clair a mon avis #A
- Pour SMS, processState devrait être une énum plutôt? franchement, oui #E oui #A
- Object et Reparation ont besoin de clés uniques -> id donnés par nous? Oui #A (remember le labo, RIP)
- ok de pas donner de nom pour les associations concernant des enum? Les cardinalités suffisent? C'est toujours "a" quelque chose. -> #A: Mieux vaut mettre "a" ou "possède" ET une composition/aggrégation, non ? #V: bonne question.. #E: Je pense pas pour aggrégation/composition, ok pour le reste
- Même si le client refuse le devis, la réparation reste associée à lui, est-ce que c'est ok? #A oui, et on la passe en "ABANDONNED"
- Est-ce que la réparation ne devrait pas préciser de quels domaines de spécilisation elle a besoin pour être faite? -> #A On en avait parlé en cours non ? Peut-être qu'il faut lui lier "Specialization" ! #V : ce serait pas mieux de créer une enum Specialization? #E: On n'arrive pas à être exhaustif je pense
- sale entité faible de object? -> #A je comprends toujours rien a ca
  #V: jsp si ça ou de lui donner un id unique comme pour objet et reparation.
- effectiveTime de Reparation est redondant. Il suffit d'addtionner tous les TimeWorked de tous les Technicians à la fin. #A: absolument.
- Si on laisse l'association "répond" entre Receptionist et SMS, c'est redondant avec le champ "sender" de SMS. #A voir commentaire en dessous
- Est-ce que Manager devrait hériter de Technicien ET Receptionist plutôt? Ou on dit qu'il a toujours tous les rôles? #A Yep c'est une idée, mais attention il peut aussi faire plus que les deux ! #V j'avoue, à voir comment on peut organiser ça

Aubry :
ProcessState : renommer ProcessingState ?
SMS : - Timestamp ne peut pas être une clé car il n'est pas garanti unique (2 sms à la même picosecond ? haha)
#E: ça me semblait assez peu probable pour être négligeable mais ok, on peut mettre un id nous-même OK
#V : Plusieurs clés? Mais est ce qu'on met les 3 attributs ou timestamp&msg ou timestamp&sender? Mouais, pas convaincu. - Ensemble de SMS s'appelle conversation : pas utile a préciser dans le DBMS mais seulement dans l'affichage ? Je me disais la même chose #E OK - Les SMS ne deveraient-ils pas lier plutot un client et une réparation, sans passer par le Receptionist ? (le manager peut aussi répondre je crois)
#V : si on le lie slmt à reparation ce serait pas suffisant? ~~~~
#E : on peut faire ça mais il faut bien laisser sender ~~~~
Reparation: - On voulait tracker seulement le temps total passé n'est-ce pas ? (et non pas quel colaborateur a effectué du temps de travail c'est ca ?) #V : c'est quand meme utile de le tracker pour le stats et tout ça, non?
#E : Il me semblait qu'on voulait savoir combien de temps chaque technicien a passé sur une réparation OK
Général : - client, receptionist, manager, technician peuvent tous hériter de "Person" non? On s'évite des répétitions de PhoneNo, Name, etc. - Les différents roles de collaborateurs définissent leurs niveaux d'accès a la DB -> pas sur car finalement en pratique on aura un seul accès à la DB depuis le serveur. Pas sur que ca soit pertinent de le mettre la. - Attention à ajouter les "disjoint, totale" etc. dans le diagramme pour préciser qu'on peut êtr eplusieurs choses à la fois !

## Décisions

- Est-ce que'on devrait avoir une seule enum pour les états de réparation?
  On a remarqué qu'il fallait une association entre Object et Reparation. Sans ça, on n'arrive pas à remonter à la réparation depuis l'objet.
  Par conséquent, on n'a plus besoin de ObjectRepairState dans Object vu qu'on a l'information dans Reparation. OK
- On a rajouté des noms aux associations qui concernent des enum. OK
- Est-ce que la réparation ne devrait pas préciser de quels domaines de spécilisation elle a besoin pour être faite?
  On a rajouté une association entre Reparation et Specialization qui décrit les spécilisations dont a besoin la réparation. OK
- On a mis Sale comme entité faible de Object (n'existe pas si l'objet n'existe pas). On a rajouté id_sale comme clé unique de Sale. OK
- On a décidé de garder la classe d'association TimeWorked et d'enlever l'attribut effectiveTime de Reparation. On s'est dit que c'est une information intéressante
  pour faire des statistiques. OK
- On a fait une classe Person dont toutes les personnes héritent. Pour montret qu'un manager peut aussi avoir un autre rôle, on a séparé les flèches d'héritage.
  On n'a pas fait hériter manager de Receptionist et Techncien parce que c'est pas très logique qu'un manager ait toutes leurs associations. (genre il répare pas des trucs de base) OK
- Pour la clé unique de SMS, on a mis deux clés candidates: timestamp et message (même si je trouve tjs ça un peu excessif #E) Pas OK pour moi, remettre un ID
- Au final, on a fait une association entre SMS et Personne en précisant en CI qui a le droit d'envoyer des messages. Par conséquent, on a enlevé sender de SMS. Mais on sait pas qui a envoyé le message ?

## TO-DO

- Il faut penser à changer le cahier des charges en fonction de nos petits changements.
- Il faut mettre au propre l'UML

# Conceptualisation relationnelle

- Beaucoup de renommage d'attributs dans réparation.
  E: oui c'est vrai c'est parce que la classe est un peu liée à tout et au milieu :/ mais je vois pas trop comment faire autrement?
  J'ai l'impression que si on reomme pas un minimum, les attributs de Reparation seront pas très clair.
- Manque date created et last updated dans pas mal d'endroits -> est-ce aussi sensé apparaitre dans le diagramme ?
  E: Je pense autant les rajouter dans l'UML pour qu'ils soit complet.
- Finalement c'est un peu pourri le numéro de téléphone comme id... :^(
  E: c'est vrai qu'on est tout le temps en train renommer des trucs. On peut générer un id pour chaque nouveau client au lieu d'utiliser
  le numéro de téléphone et on rajoute dans l'UML?
- Dans Pagila, quasi toutes les tables ont un champ `last_update`, est-ce qu'on devrait s'inspirer de ça et en mettre partout aussi ?
  E: C'est peut être pas pertinent partout? Mais dans Reparation et Sale (et peut être d'autres) pourquoi pas?

- Ajouter `date_modified` dans réparation
- Modifier clé de `Person` en un `id`
- Renommer `SMS.timestamp` en `date_created`

Modif script

- changer "language" en "name"
- ajout comment dans person
- ajouter références à brand et category dans object
- ajoute primary key dans sale

# Phase 4

Ordre:

1. Triggers
2. Remplir base de données
3. Requêtes

## Triggers

- Sur changement de ReparationState ou QuoteState, mise à jour de `date_modified`
- Sur insertion de Sale, vérifier que QUOTE_STATE est DECLINED
- Sur update de Location en FOR_SALE ou SOLD, vérifier que QUOTE est DECLINED
- Sur update de ReparationState en ONGOING ou DONE, vérifier que QuoteState est ACCEPTED
- Sur création de Reparation, vérifier que Client.tosAccepted est TRUE
- Sur insertion d'une réparation, mettre QuoteState, ReparationState en WAITING et Location en IN_STOCK
- Sur update de QuoteState en accepted, ReparationState devient ONGOING

## Vues

## Requêtes (ou fonctions)

- Consulter toutes les réparations

### Technician

- Consulter les réparations qui lui sont attribuées
- Modifier l’état de la réparation
- Modifier le descriptif du travail effectué
- Ajouter un temps travaillé sur une réparation

### Réceptionniste

- Consulter, créer et modifier un client
- Consulter, créer et modifier une réparation
- Modifier l'état de devis (quoteState)
- Consulter, créer et modifier une vente
- Envoyer et consulter des SMS liés à une réparation

### Manager

En plus des actions entreprenables par les réceptionnistes et techniciens, un manager doit pouvoir entreprendre les actions suivantes (reprendre les requêtes ci-dessus).

- Créer, modifier et supprimer des collaborateurs
- Assigner un ou des rôles à des collaborateurs
- Créer, modifier et supprimer des réparation, clients, ventes (<= toute autre action manipulant les données de l’application)

### Statistiques

- Obtenir nombre de réparations en cours total
- Obtenir nombre de réparations en cours par catégorie

- Obtenir nombre de réparations effectuées total
- Obtenir nombre de réparations effectuées par catégorie

- Obtenir nombre total d'objets en vente
- Obtenir nombre total d'objets vendus

- Nombre d'objet traités par catégorie
- Nombre d'objet traités par marque

- Obtenir temps total de travail spécialisation

- Nombre de réparations par mois
- Nombre de réparations crées par réceptionniste
- Nombre de collaborateur qui parlent une certaine langue
- Nombre d'employés par sous-classes
- Nombre de SMS reçus par jour
- Nombre de SMS répondus par jour

## Corrections phase 3

### Traiter ON UPDATE / ON DELETE

- table receptionist_language: language (name) -> ON UPDATE CASCADE ON DELETE RESTRICT
- table technician_specialization: spec_name ON UPDATE CASCADE ON DELETE RESTRICT
- table object:
  brand ON UPDATE CASCADE ON DELETE SET NULL
  category ON UPDATE CASCADE ON DELETE RESTRICT
- table specialization_reparation
  spec_name ON UPDATE CASCADE ON DELETE RESTRICT
- tous les ids: ON UPDATE RESTRICT ON DELETE SET NULL

- modification du schéma pour rendre les FK nullable

### Vérifier NOW() et CURRENT_TIMESTAMP()

- Current_timestamp() est implémenté avec NOW() mais on peut lui passer la précision voulue en paramètre.
  J'ai utilisé NOW() pour nous simplifier la vie.

### Autres

- Pour tous les champs de temps/date -> TIMESTAMP WITH TIME ZONE pour standardiser.
- Corrigé commentaires dans .sql
- brand -> nullable
- toutes les FK -> nullable
- Ajout time_worked dans technician_reparation pour répresenter la quantité de minutes qu'un technician a passé sur une réparation.

A faire: ajouter time_worked dans uml
