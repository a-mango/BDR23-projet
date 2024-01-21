package ch.heig.bdr.projet.api.util;

import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.io.IOException;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

public class SqlTimeDeserializer extends JsonDeserializer<Time> {
    private static final SimpleDateFormat format = new SimpleDateFormat("HH:mm");

    @Override
    public Time deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        String str = p.getText().trim();
        try {
            return new Time(format.parse(str).getTime());
        } catch (ParseException e) {
            throw new RuntimeException("Failed to parse Time value: " + str, e);
        }
    }
}