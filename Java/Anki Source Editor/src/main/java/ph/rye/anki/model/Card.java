/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ph.rye.anki.model;

import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * @author royce
 */
public class Card {

    private transient String front;
    private transient String back;
    private final transient Set<String> tags = new LinkedHashSet<String>();


    public Card(final String front, final String back) {
        this.front = front;
        this.back = back;
    }

    public void removeTags(final String... tags) {
        for (final String tag : tags) {
            this.getTags().remove(tag);
        }
    }

    public void addTags(final String... tags) {
        for (final String tag : tags) {
            this.getTags().add(tag);
        }
    }

    /**
     * @return the front
     */
    public String getFront() {
        return front;
    }

    /**
     * @param front the front to set
     */
    public void setFront(final String front) {
        this.front = front;
    }

    /**
     * @return the back
     */
    public String getBack() {
        return back;
    }

    /**
     * @param back the back to set
     */
    public void setBack(final String back) {
        this.back = back;
    }

    /**
     * @return the tags
     */
    public Set<String> getTags() {
        return tags;
    }

    public void setTags(final String... newTags) {
        tags.clear();
        tags.addAll(Arrays.asList(newTags));
    }

    public String toSource() {
        final StringBuilder strBuilder = new StringBuilder();
        if (!getTags().isEmpty()) {
            strBuilder.append(AnkiService.TAGS_MARKER);
            for (final String string : tags) {
                if (strBuilder.length() > AnkiService.TAGS_MARKER.length()) {
                    strBuilder.append(", ");
                }
                strBuilder.append(string);
            }
            strBuilder.append('\n');
        }
        strBuilder
            .append(this.getFront())
            .append("\n\n")
            .append(this.getBack())
            .append('\n');
        return strBuilder.toString();
    }

}
