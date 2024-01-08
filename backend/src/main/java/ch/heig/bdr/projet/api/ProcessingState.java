package ch.heig.bdr.projet.api;

/**
 * Enum representing the state of a reparation.
 * WAITING: The reparation is waiting to be processed.
 * ONGOING: The reparation is being processed.
 * DONE: The reparation has been processed.
 * ABANDONED: The reparation has been abandoned.
 */
public enum ProcessingState {

    RECEIVED, READ, PROCESSED;
}
