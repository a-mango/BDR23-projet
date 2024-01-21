package ch.heig.bdr.projet.api.models;

/**
 * Sms processing state.
 * received: The sms has been received.
 * read: The sms has been read.
 * processed: The sms has been processed.
 */
public enum ProcessingState {

    received,
    read,
    processed;
}
