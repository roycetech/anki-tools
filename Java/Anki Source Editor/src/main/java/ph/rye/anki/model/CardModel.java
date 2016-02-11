/**
 *   Copyright 2016 Royce Remulla
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package ph.rye.anki.model;

import java.util.ArrayList;
import java.util.List;

import javax.swing.table.AbstractTableModel;

import ph.rye.anki.util.StringUtil;

/**
 * @author royce
 *
 */
public class CardModel extends AbstractTableModel {


    /** */
    private static final long serialVersionUID = 1L;


    private final List<Card> cardList = new ArrayList<>();

    private final String[] columnNames = new String[] {
            "Front",
            "Back",
            "@Tags" };


    /* (non-Javadoc)
     * @see javax.swing.table.AbstractTableModel#getColumnName(int)
     */
    @Override
    public String getColumnName(final int column) {
        return columnNames[column];
    }

    /* (non-Javadoc)
     * @see javax.swing.table.TableModel#getRowCount()
     */
    @Override
    public int getRowCount() {
        return cardList.size();
    }

    /* (non-Javadoc)
     * @see javax.swing.table.TableModel#getColumnCount()
     */
    @Override
    public int getColumnCount() {
        return 3;
    }

    /* (non-Javadoc)
     * @see javax.swing.table.TableModel#getValueAt(int, int)
     */
    @Override
    public Object getValueAt(final int rowIndex, final int columnIndex) {
        final Card card = getCardAt(rowIndex);

        Object retval = null;
        switch (columnIndex) {
            case 0:
                retval = card.getFront();
                break;
            case 1:
                retval = card.getBack();
                break;
            case 2:
                retval = StringUtil.join(card.getTags(), ",");
                break;
        }
        return retval;
    }

    /* (non-Javadoc)
     * @see javax.swing.table.AbstractTableModel#getColumnClass(int)
     */
    @Override
    public Class<?> getColumnClass(final int columnIndex) {
        return String.class;
    }

    public Card getCardAt(final int rowIndex) {
        return cardList.get(rowIndex);
    }

    //    public void setCardAt(final int rowIndex, Card card) {
    //        final Card card = cardList.get(rowIndex);
    //        cardList.remove(rowIndex);
    //        card
    //        cardList.add(rowIndex, card);
    //    }

    public void addCard(final Card card) {
        cardList.add(card);
        super.fireTableRowsInserted(cardList.size() - 1, cardList.size() - 1);
    }

    /**
     *
     */
    public void reset() {
        cardList.clear();
        super.fireTableDataChanged();
    }


}
