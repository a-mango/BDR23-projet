package ch.heig.bdr.projet.api.models;

/**
 * Enum representing the state of a reparation.
 * WAITING: The reparation is waiting to be processed.
 * ONGOING: The reparation is being processed.
 * DONE: The reparation has been processed.
 * ABANDONED: The reparation has been abandoned.
 */
public enum ReparationState {

    waiting, ongoing, done, abandoned;
}