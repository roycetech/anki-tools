/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ph.rye.anki;

/**
 *
 * @author royce
 */
public class Tag {

    private final String name;
    private transient boolean show;

    public Tag(final String name, final boolean show) {
        assert name != null;

        this.name = name;
        this.show = show;
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
    public boolean isShow() {
        return show;
    }

    /**
     * @param show the show to set
     */
    public void toggleState() {
        show = !show;
    }

    public void setShow(final boolean state) {
        show = state;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(" + name + "," + show + ")";
    }

}
