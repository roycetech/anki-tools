/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ph.rye.anki.model;

/**
 *
 * @author royce
 */
public class Tag {

    private final String name;
    private transient boolean checked;
    private transient int count;

    public Tag(final String name, final boolean checked) {
        assert name != null;

        this.name = name;
        this.checked = checked;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @return the show
     */
    public boolean isChecked() {
        return checked;
    }

    public void setChecked(final boolean state) {
        checked = state;
    }

    /**
     * @return the count
     */
    public int getCount() {
        return count;
    }

    /**
     * @param count the count to set
     */
    public void incrementCount() {
        count++;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(" + checked + "," + name + ")";
    }

}
