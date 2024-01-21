package ch.heig.bdr.projet.api.models;

/**
 * Enum representing the state of a quote.
 * accepted: The quote has been accepted.
 * declined: The quote has been declined.
 * waiting: The quote is waiting to be processed.
 */
public enum QuoteState {

    accepted,
    declined,
    waiting;
}
