package ch.heig.bdr.projet.api.models;

/**
 * Enum representing the state of a reparation.
 * waiting: The reparation is waiting to be processed.
 * ongoing: The reparation is being processed.
 * done: The reparation has been processed.
 * abandoned: The reparation has been abandoned.
 */
public enum ReparationState {

    waiting,
    ongoing,
    done,
    abandoned;
}
