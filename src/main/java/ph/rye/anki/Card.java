/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ph.rye.anki;

import java.util.ArrayList;
import java.util.List;

/**
 * @author royce
 */
public class Card {

    private transient String front;
    private transient String back;
    private transient List<String> tags = new ArrayList<String>();


    Card(final String front, final String back) {
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
    public List<String> getTags() {
        return tags;
    }

}
