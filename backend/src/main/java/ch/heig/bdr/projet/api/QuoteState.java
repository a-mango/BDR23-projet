package ch.heig.bdr.projet.api;

/**
 * Enum representing the state of a quote.
 * ACCEPTED: The quote has been accepted.
 * DECLINED: The quote has been declined.
 * WAITING: The quote is waiting to be processed.
 */
public enum QuoteState {

    accepted, declined, waiting;
}
