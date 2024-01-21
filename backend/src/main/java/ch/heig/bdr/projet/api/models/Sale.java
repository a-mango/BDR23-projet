package ch.heig.bdr.projet.api.models;

public class Sale {

    public int id;
    public int objectId;
    public int price;
    public String dateCreated;
    public String dateSold;

    public Sale() {}

    /**
     * Sale constructor.
     *
     * @param idSale      The sale id.
     * @param price       The sale price.
     * @param dateCreated The sale creation date.
     * @param dateSold    The sale sold date.
     */
    public Sale(int idSale, int objectId,  int price, String dateCreated, String dateSold) {
        this.id = idSale;
        this.objectId = objectId;
        this.price = price;
        this.dateCreated = dateCreated;
        this.dateSold = dateSold;
    }
}
